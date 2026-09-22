import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/data/models/api_response.dart';
import 'package:novasight_app/app/data/models/student_quiz_model.dart';
import 'package:novasight_app/app/data/providers/student_provider.dart';
import 'package:novasight_app/app/data/repositories/student_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';

class MockStudentProvider extends Mock implements StudentProvider {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockStudentProvider mockProvider;
  late MockStorageService mockStorage;
  late StudentRepository repository;

  final testNow = DateTime.parse('2026-09-17T00:00:00.000Z');

  setUp(() {
    mockProvider = MockStudentProvider();
    mockStorage = MockStorageService();
    repository = StudentRepository(
      studentProvider: mockProvider,
      storageService: mockStorage,
    );
  });

  group('StudentRepository Quiz Endpoints Tests', () {
    test('getQuizzes returns List<QuizRequestStudentResponse>', () async {
      final List<QuizRequestStudentResponse> mockQuizzes = [
        QuizRequestStudentResponse(
          id: 101,
          moduleId: 12,
          title: 'Kuis Biologi Sel',
          statusPublished: 'publish',
          maxDurationMinutes: 45,
          maxRetry: 1,
          startTime: testNow,
          endTime: testNow.add(const Duration(days: 3)),
          questionCounts: 10,
          module: ModuleQuizResponse(id: 12, title: 'Biologi Sel', description: 'Deskripsi modul'),
          progress: QuizRequestStudentProgressResponse(
            isDone: false,
            score: null,
            attemptCount: 0,
          ),
        ),
      ];

      when(() => mockProvider.getQuizzes(
            classroomId: 1,
            status: QuizRequestStudentQueryStatus.semua,
          )).thenAnswer((_) async => ApiResponse<List<QuizRequestStudentResponse>>(
            message: 'Success',
            data: mockQuizzes,
          ));

      final result = await repository.getQuizzes(
        classroomId: 1,
        status: QuizRequestStudentQueryStatus.semua,
      );

      expect(result.length, 1);
      expect(result.first.id, 101);
      expect(result.first.title, 'Kuis Biologi Sel');
      expect(result.first.questionCounts, 10);
      expect(result.first.isDone, false);
      expect(result.first.isPublished, true);
    });

    test('getQuizzes throws ApiException when provider fails', () async {
      when(() => mockProvider.getQuizzes(classroomId: 1))
          .thenThrow(const ApiException(message: 'Network error', statusCode: 500));

      expect(
        () => repository.getQuizzes(classroomId: 1),
        throwsA(isA<ApiException>()),
      );
    });

    test('startQuizStream yields SSE StudentQuizEvent properly', () async {
      final streamEvents = <StudentQuizEvent>[
        StudentQuizInitEvent(
          targetEndTime: DateTime.parse('2026-09-17T01:00:00Z'),
          questions: [
            QuizRequestQuestionResponse(
              id: 1,
              chapterId: 10,
              bloomLevel: 2,
              questionText: 'Apa fungsi mitokondria?',
              options: [
                QuestionOptionResponse(id: 1, label: 'A', opsiText: 'Penghasil energi'),
                QuestionOptionResponse(id: 2, label: 'B', opsiText: 'Sintesis protein'),
              ],
              explanationSteps: [],
            ),
          ],
        ),
        const StudentQuizTickEvent(time: '44:59'),
        const StudentQuizTimeoutEvent(message: 'Waktu habis!'),
      ];

      when(() => mockProvider.startQuizStream(quizId: 101))
          .thenAnswer((_) => Stream.fromIterable(streamEvents));

      final stream = repository.startQuizStream(quizId: 101);
      final emitted = await stream.toList();

      expect(emitted.length, 3);
      expect(emitted[0], isA<StudentQuizInitEvent>());
      expect((emitted[0] as StudentQuizInitEvent).questions.first.questionText, 'Apa fungsi mitokondria?');
      expect(emitted[1], isA<StudentQuizTickEvent>());
      expect((emitted[1] as StudentQuizTickEvent).time, '44:59');
      expect(emitted[2], isA<StudentQuizTimeoutEvent>());
    });

    test('submitSoalAnswer successfully posts answer and returns response', () async {
      const request = SoalSubmitRequest(
        selectedOption: 'A',
      );
      final response = SoalSubmitResponse(
        soalId: 1,
        status: 'success',
      );

      when(() => mockProvider.submitSoalAnswer(soalId: 1, request: request))
          .thenAnswer((_) async => ApiResponse<SoalSubmitResponse>(
                message: 'Answer recorded',
                data: response,
              ));

      final result = await repository.submitSoalAnswer(soalId: 1, request: request);

      expect(result.soalId, 1);
      expect(result.status, 'success');
    });

    test('finishQuiz returns data map', () async {
      when(() => mockProvider.finishQuiz(quizId: 101)).thenAnswer(
        (_) async => ApiResponse<Map<String, dynamic>>(
          message: 'Quiz completed',
          data: {'status': 'completed', 'score': 90},
        ),
      );

      final result = await repository.finishQuiz(quizId: 101);

      expect(result['status'], 'completed');
      expect(result['score'], 90);
    });

    test('getMyQuizResults returns list of QuizResultItem with justification', () async {
      final List<QuizResultItem> mockResults = [
        QuizResultItem(
          soalId: 1,
          questionText: 'Apa fungsi mitokondria?',
          selectedOption: 'A',
          correctOption: 'A',
          studentSteps: [],
          isCorrect: true,
          justification: SoalJustification(
            diagnosis: 'Pemahaman konsep respirasi seluler sudah sangat baik.',
            personalizedJustification: 'Jawaban Anda konsisten dengan konsep.',
          ),
        ),
      ];

      when(() => mockProvider.getMyQuizResults(quizRequestId: 101)).thenAnswer(
        (_) async => ApiResponse<List<QuizResultItem>>(
          message: 'Results retrieved',
          data: mockResults,
        ),
      );

      final result = await repository.getMyQuizResults(quizRequestId: 101);

      expect(result.length, 1);
      expect(result.first.soalId, 1);
      expect(result.first.isCorrect, true);
      expect(result.first.justification?.diagnosis,
          'Pemahaman konsep respirasi seluler sudah sangat baik.');
    });
  });
}
