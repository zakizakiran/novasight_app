import 'package:novasight_app/app/data/models/student_quiz_model.dart';
import 'package:novasight_app/app/data/models/user_model.dart';

class StudentProgressQuiz {
  ProfileResponseModel profileResponse;
  QuizRequestStudentProgressResponse? quizProgress;

  StudentProgressQuiz({
    required this.profileResponse,
    this.quizProgress
  });

  factory StudentProgressQuiz.fromJson(Map<String, dynamic> json) {
    return StudentProgressQuiz(
      profileResponse: ProfileResponseModel.fromJson(json['student_profile']),
      quizProgress: json['quiz'] != null ? QuizRequestStudentProgressResponse.fromJson(json['quiz']) : null
    );
  }
}