import 'package:novasight_app/app/data/models/student_progress_quiz.dart';

class ExamStudentDetailProgressArgs {
  final StudentProgressQuiz quiz;
  final int quizId;
  final String title;

  const ExamStudentDetailProgressArgs({
    required this.quiz,
    required this.quizId,
    this.title = 'Hasil Ujian',
  });
}