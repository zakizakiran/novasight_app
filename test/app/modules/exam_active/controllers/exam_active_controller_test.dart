import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lydera_app/app/data/models/student_quiz_model.dart';
import 'package:lydera_app/app/data/repositories/student_repository.dart';
import 'package:lydera_app/app/modules/exam_active/controllers/exam_active_controller.dart';

class MockStudentRepository extends Mock implements StudentRepository {}

void main() {
  late MockStudentRepository repo;
  late ExamActiveController controller;

  QuizRequestStudentResponse buildQuiz({required bool isDone}) {
    return QuizRequestStudentResponse(
      id: 5,
      moduleId: 12,
      title: 'UTS',
      statusPublished: 'publish',
      maxDurationMinutes: 60,
      maxRetry: 2,
      startTime: DateTime.now().subtract(const Duration(days: 1)),
      endTime: DateTime.now().add(const Duration(days: 1)),
      module: ModuleQuizResponse(id: 12, title: 'Matematika', description: ''),
      progress: QuizRequestStudentProgressResponse(
        isDone: isDone,
        attemptCount: 1,
      ),
    );
  }

  /// INIT dari server yang masih membawa jawaban "A" untuk setiap soal.
  StudentQuizInitEvent initWithSavedAnswers() {
    QuizRequestQuestionResponse question(int id) {
      return QuizRequestQuestionResponse(
        id: id,
        chapterId: 1,
        bloomLevel: 1,
        questionText: 'Soal $id',
        options: [
          QuestionOptionResponse(id: 1, label: 'A', opsiText: '1'),
          QuestionOptionResponse(id: 2, label: 'B', opsiText: '2'),
        ],
        explanationSteps: const [],
        answer: QuizStudentAnswer(id: id, selectedOption: 'A', steps: []),
      );
    }

    return StudentQuizInitEvent(questions: [question(1), question(2)]);
  }

  Future<void> flushStream() => Future<void>.delayed(Duration.zero);

  Future<void> openExam(Object arguments) async {
    Get.routing.args = arguments;
    controller = ExamActiveController(studentRepository: repo)..onInit();
    await flushStream();
  }

  setUpAll(() {
    registerFallbackValue(const SoalSubmitRequest(selectedOption: 'A'));
  });

  setUp(() {
    repo = MockStudentRepository();
    when(() => repo.startQuizStream(quizId: any(named: 'quizId')))
        .thenAnswer((_) => Stream.value(initWithSavedAnswers()));
    when(
      () => repo.submitSoalAnswer(
        soalId: any(named: 'soalId'),
        request: any(named: 'request'),
      ),
    ).thenAnswer((_) async => SoalSubmitResponse(soalId: 1, status: 'ok'));
  });

  tearDown(() {
    controller.onClose();
    Get.routing.args = null;
  });

  group('ExamActiveController saved answers', () {
    test('retrying a finished exam starts with no selected options', () async {
      await openExam(buildQuiz(isDone: true));

      expect(controller.questions, hasLength(2));
      expect(
        controller.questions.map((q) => q.selectedOptionId),
        everyElement(isNull),
      );
      expect(controller.isAllAnswered, isFalse);
      expect(controller.currentIndex.value, 0);
    });

    test('resuming an unfinished exam restores the saved options', () async {
      // Bentuk argumen dari ExamDetailController.onStartExam.
      await openExam({
        'quizId': 5,
        'durationMinutes': 60,
        'title': 'UTS',
        'moduleTitle': 'Matematika',
        'quiz': buildQuiz(isDone: false),
      });

      expect(
        controller.questions.map((q) => q.selectedOptionId),
        everyElement('A'),
      );
    });

    test('options picked during a retry survive a repeated INIT', () async {
      await openExam(buildQuiz(isDone: true));

      await controller.selectOption('1', 'B');
      // "Coba Lagi" memanggil startQuiz lagi dan server mengirim INIT baru.
      await controller.startQuiz();
      await flushStream();

      expect(controller.questions[0].selectedOptionId, 'B');
      expect(controller.questions[1].selectedOptionId, isNull);
    });
  });
}
