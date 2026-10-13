import 'package:novasight_app/app/data/models/student_quiz_model.dart';

import '../../core/utils/module_status.dart';

class ExamModel {
  final String id;
  final String title;
  final String subtitle;
  final String statusText;
  final String score;
  final PublicStatus status;
  final QuizRequestStudentResponse? rawQuiz;

  ExamModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.score,
    required this.status,
    this.rawQuiz,
  });
}