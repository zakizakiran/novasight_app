import 'package:flutter_test/flutter_test.dart';
import 'package:lydera_app/app/data/models/student_quiz_model.dart';

void main() {
  final now = DateTime.parse('2026-11-13T08:00:00.000Z');

  QuizRequestStudentResponse buildQuiz({
    int maxRetry = 2,
    QuizRequestStudentProgressResponse? progress,
    DateTime? endTime,
  }) {
    return QuizRequestStudentResponse(
      id: 1,
      moduleId: 1,
      title: 'UTS',
      statusPublished: 'publish',
      maxDurationMinutes: 60,
      maxRetry: maxRetry,
      startTime: now.subtract(const Duration(days: 1)),
      endTime: endTime ?? now.add(const Duration(days: 1)),
      progress: progress,
      module: ModuleQuizResponse(id: 1, title: 'Modul', description: ''),
    );
  }

  group('QuizRequestStudentResponse retry rule', () {
    test('can retry when done, attempts remain, and before end_time', () {
      final quiz = buildQuiz(
        maxRetry: 2,
        progress: QuizRequestStudentProgressResponse(
          isDone: true,
          attemptCount: 1,
        ),
      );

      expect(quiz.remainingAttempts, 1);
      expect(quiz.canRetryAt(now), isTrue);
    });

    test('cannot retry when attempt_count reaches max_retry', () {
      final quiz = buildQuiz(
        maxRetry: 2,
        progress: QuizRequestStudentProgressResponse(
          isDone: true,
          attemptCount: 2,
        ),
      );

      expect(quiz.remainingAttempts, 0);
      expect(quiz.canRetryAt(now), isFalse);
    });

    test('cannot retry with the default max_retry of 1 after one attempt', () {
      final quiz = buildQuiz(
        maxRetry: 1,
        progress: QuizRequestStudentProgressResponse(
          isDone: true,
          attemptCount: 1,
        ),
      );

      expect(quiz.canRetryAt(now), isFalse);
    });

    test('cannot retry when the exam is not done yet', () {
      final quiz = buildQuiz(
        maxRetry: 3,
        progress: QuizRequestStudentProgressResponse(
          isDone: false,
          attemptCount: 1,
        ),
      );

      expect(quiz.canRetryAt(now), isFalse);
    });

    test('cannot retry when progress is null', () {
      final quiz = buildQuiz(maxRetry: 3, progress: null);

      expect(quiz.remainingAttempts, 3);
      expect(quiz.canRetryAt(now), isFalse);
    });

    test('cannot retry after end_time', () {
      final quiz = buildQuiz(
        maxRetry: 3,
        endTime: now.subtract(const Duration(minutes: 1)),
        progress: QuizRequestStudentProgressResponse(
          isDone: true,
          attemptCount: 1,
        ),
      );

      expect(quiz.canRetryAt(now), isFalse);
    });

    test('remainingAttempts never goes below zero', () {
      final quiz = buildQuiz(
        maxRetry: 1,
        progress: QuizRequestStudentProgressResponse(
          isDone: true,
          attemptCount: 5,
        ),
      );

      expect(quiz.remainingAttempts, 0);
    });

    test('reads max_retry and attempt_count from JSON', () {
      final quiz = QuizRequestStudentResponse.fromJson({
        'id': 7,
        'title': 'UAS',
        'max_retry': 3,
        'end_time': now.add(const Duration(days: 2)).toIso8601String(),
        'progress': {'attempt_count': 1, 'is_done': true},
      });

      expect(quiz.remainingAttempts, 2);
      expect(quiz.canRetryAt(now), isTrue);
    });
  });
}
