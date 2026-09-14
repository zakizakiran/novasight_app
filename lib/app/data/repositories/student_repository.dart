import 'package:novasight_app/app/data/models/student_model.dart';
import 'package:novasight_app/app/data/providers/student_provider.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';

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
}
