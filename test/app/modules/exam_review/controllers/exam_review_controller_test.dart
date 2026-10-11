import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/data/models/student_quiz_model.dart';
import 'package:novasight_app/app/data/repositories/student_repository.dart';
import 'package:novasight_app/app/modules/exam_review/controllers/exam_review_controller.dart';

class MockStudentRepository extends Mock implements StudentRepository {}

void main() {
  late MockStudentRepository mockStudentRepository;
  late ExamReviewController controller;

  setUp(() {
    mockStudentRepository = MockStudentRepository();
  });

  group('ExamReviewController Tests', () {
    test('fetchResults populates questions with real API data', () async {
      final mockResults = [
        QuizResultItem(
          soalId: 101,
          questionText: 'Berapakah 2 + 2?',
          selectedOption: 'B',
          correctOption: 'B',
          studentSteps: [],
          isCorrect: true,
          justification: SoalJustification(
            diagnosis: 'Jawaban tepat',
            personalizedJustification: 'Langkah sudah benar',
          ),
          options: [
            QuestionOptionResponse(id: 1, label: 'A', opsiText: 'Opsi A'),
            QuestionOptionResponse(id: 2, label: 'B', opsiText: 'Opsi B'),
          ],
        ),
        QuizResultItem(
          soalId: 102,
          questionText: 'Berapakah 5 * 5?',
          selectedOption: 'A',
          correctOption: 'C',
          options: [
            QuestionOptionResponse(id: 1, label: 'A', opsiText: 'Opsi A'),
            QuestionOptionResponse(id: 2, label: 'B', opsiText: 'Opsi B'),
          ],
          studentSteps: [],
          isCorrect: false,
          justification: SoalJustification(
            divergenceStep: 1,
            diagnosis: 'Salah perkalian',
            personalizedJustification: '5 * 5 = 25',
          ),
        ),
      ];

      when(() => mockStudentRepository.getMyQuizResults(quizRequestId: any(named: 'quizRequestId')))
          .thenAnswer((_) async => mockResults);

      controller = ExamReviewController(studentRepository: mockStudentRepository);
      controller.quizRequestId.value = 10;

      await controller.fetchResults();

      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, isEmpty);
      expect(controller.questions.length, 2);
      expect(controller.questions[0].id, 101);
      expect(controller.questions[0].question, 'Berapakah 2 + 2?');
      expect(controller.questions[0].isCorrect, true);
      expect(controller.questions[0].score, 20);
      expect(controller.questions[1].id, 102);
      expect(controller.questions[1].isCorrect, false);
      expect(controller.questions[1].score, 0);
      expect(controller.questions[1].errorStepIndex, 0);
    });

    test('fetchResults leaves questions empty and sets message when API returns empty', () async {
      when(() => mockStudentRepository.getMyQuizResults(quizRequestId: any(named: 'quizRequestId')))
          .thenAnswer((_) async => []);

      controller = ExamReviewController(studentRepository: mockStudentRepository);
      controller.quizRequestId.value = 99;

      await controller.fetchResults();

      expect(controller.isLoading.value, false);
      expect(controller.questions, isEmpty);
      expect(controller.errorMessage.value, contains('Belum ada hasil evaluasi'));
    });

    test('fetchResults leaves questions empty and sets errorMessage on ApiException', () async {
      when(() => mockStudentRepository.getMyQuizResults(quizRequestId: any(named: 'quizRequestId')))
          .thenThrow(const ApiException(message: 'Quiz not found', statusCode: 404));

      controller = ExamReviewController(studentRepository: mockStudentRepository);
      controller.quizRequestId.value = 999;

      await controller.fetchResults();

      expect(controller.isLoading.value, false);
      expect(controller.questions, isEmpty);
      expect(controller.errorMessage.value, 'Quiz not found');
    });

    test('navigation methods update currentIndex correctly', () async {
      final mockResults = [
        QuizResultItem(
          soalId: 1,
          questionText: 'Soal 1',
          selectedOption: 'A',
          correctOption: 'A',
          studentSteps: [],
          options: [
            QuestionOptionResponse(id: 1, label: 'A', opsiText: 'Opsi A'),
            QuestionOptionResponse(id: 2, label: 'B', opsiText: 'Opsi B'),
          ],
          isCorrect: true,
        ),
        QuizResultItem(
          soalId: 2,
          questionText: 'Soal 2',
          selectedOption: 'B',
          correctOption: 'B',
          studentSteps: [],
          options: [
            QuestionOptionResponse(id: 1, label: 'A', opsiText: 'Opsi A'),
            QuestionOptionResponse(id: 2, label: 'B', opsiText: 'Opsi B'),
          ],
          isCorrect: true,
        ),
      ];

      when(() => mockStudentRepository.getMyQuizResults(quizRequestId: any(named: 'quizRequestId')))
          .thenAnswer((_) async => mockResults);

      controller = ExamReviewController(studentRepository: mockStudentRepository);
      await controller.fetchResults();

      expect(controller.currentIndex.value, 0);
      controller.nextQuestion();
      expect(controller.currentIndex.value, 1);
      controller.nextQuestion(); // should stay at 1
      expect(controller.currentIndex.value, 1);

      controller.previousQuestion();
      expect(controller.currentIndex.value, 0);

      controller.goToQuestion(1);
      expect(controller.currentIndex.value, 1);
    });
  });
}
