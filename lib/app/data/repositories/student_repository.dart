import 'package:lydera_app/app/data/models/student_model.dart';
import 'package:lydera_app/app/data/models/student_quiz_model.dart';
import 'package:lydera_app/app/data/providers/student_provider.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';

class StudentRepository {
  final StudentProvider studentProvider;
  final StorageService? storageService;

  StudentRepository({
    required this.studentProvider,
    this.storageService,
  });

  /// Fetch dashboard metrics & classroom summary for student
  Future<StudentDashboardModel> getDashboard({
    required int classroomId,
  }) async {
    final response = await studentProvider.getDashboard(classroomId: classroomId);
    final dashboard = response.data;

    // Cache useful student dashboard info to local storage if available
    if (storageService != null) {
      if (dashboard.classroomInfo != null) {
        if (dashboard.classroomInfo!.code != null &&
            dashboard.classroomInfo!.code!.isNotEmpty) {
          await storageService!.writeClassCode(dashboard.classroomInfo!.code!);
        }
        await storageService!.writeClassName(
          '${dashboard.classroomInfo!.classroomType} - Kelas ${dashboard.classroomInfo!.gradeClass}',
        );
      }
      if (dashboard.studentEmail.isNotEmpty) {
        await storageService!.writeUserEmail(dashboard.studentEmail);
      }
    }

    return dashboard;
  }

  /// Fetch student dashboard tasks (modules & exams) filtered by status
  Future<StudentTaskModel> getDashboardTasks({
    required int classroomId,
    StudentTaskStatus? status,
  }) async {
    final response = await studentProvider.getDashboardTasks(
      classroomId: classroomId,
      status: status,
    );
    return response.data;
  }

  /// Fetch all modules available to the student
  Future<List<StudentModuleModel>> getModules({
    required int classroomId,
    StudentModuleStatus? status,
  }) async {
    final response = await studentProvider.getModules(
      classroomId: classroomId,
      status: status,
    );
    return response.data;
  }

  /// Fetch module detail with chapter list for student
  Future<StudentModuleDetailModel> getModuleDetail({
    required int moduleId,
    required int classroomId,
  }) async {
    final response = await studentProvider.getModuleDetail(
      moduleId: moduleId,
      classroomId: classroomId,
    );
    return response.data;
  }

  /// Start reading a chapter, returns blocks and progress
  Future<StudentChapterDetailModel> startChapter({
    required int chapterId,
  }) async {
    final response = await studentProvider.startChapter(chapterId: chapterId);
    return response.data;
  }

  /// Mark chapter as completed
  Future<bool> markChapterComplete({
    required int chapterId,
  }) async {
    final response = await studentProvider.markChapterComplete(chapterId: chapterId);
    return response.data;
  }

  /// Fetch all quizzes/exams for student
  Future<List<QuizRequestStudentResponse>> getQuizzes({
    required int classroomId,
    QuizRequestStudentQueryStatus? status,
  }) async {
    final response = await studentProvider.getQuizzes(
      classroomId: classroomId,
      status: status,
    );
    return response.data;
  }

  /// Start quiz and listen to SSE events (questions list, timer ticks, timeout)
  Stream<StudentQuizEvent> startQuizStream({
    required int quizId,
  }) {
    return studentProvider.startQuizStream(quizId: quizId);
  }

  /// Submit answer for a specific question
  Future<SoalSubmitResponse> submitSoalAnswer({
    required int soalId,
    required SoalSubmitRequest request,
  }) async {
    final response = await studentProvider.submitSoalAnswer(
      soalId: soalId,
      request: request,
    );
    return response.data;
  }

  /// Finish quiz
  Future<Map<String, dynamic>> finishQuiz({
    required int quizId,
  }) async {
    final response = await studentProvider.finishQuiz(quizId: quizId);
    return response.data;
  }

  /// Get student quiz results with justifications
  Future<List<QuizResultItem>> getMyQuizResults({
    required int quizRequestId,
  }) async {
    final response = await studentProvider.getMyQuizResults(
      quizRequestId: quizRequestId,
    );
    return response.data;
  }
}
