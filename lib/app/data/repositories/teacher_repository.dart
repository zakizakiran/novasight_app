import 'package:novasight_app/app/data/models/block_regenerate_model.dart';
import 'package:novasight_app/app/data/models/chapter_create_response_model.dart';
import 'package:novasight_app/app/data/models/chapter_job_stream_model.dart';
import 'package:novasight_app/app/data/models/cp_model.dart';
import 'package:novasight_app/app/data/models/fase_model.dart';
import 'package:novasight_app/app/data/models/quiz_teacher_model.dart';
import 'package:novasight_app/app/data/models/student_progress_quiz.dart';
import 'package:novasight_app/app/data/models/teacher_model.dart';
import 'package:novasight_app/app/data/providers/teacher_provider.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';

class TeacherRepository {
  final TeacherProvider teacherProvider;
  final StorageService? storageService;

  TeacherRepository({
    required this.teacherProvider,
    this.storageService,
  });

  /// Fetch teacher dashboard metrics and classroom info
  Future<TeacherDashboardModel> getDashboard({
    required int classroomId,
    int? limit,
  }) async {
    final response = await teacherProvider.getDashboard(
      classroomId: classroomId,
      limit: limit,
    );
    final dashboard = response.data;

    // Cache useful teacher dashboard info to local storage if available
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
      if (dashboard.teacherEmail.isNotEmpty) {
        await storageService!.writeUserEmail(dashboard.teacherEmail);
      }
    }

    return dashboard;
  }

  /// Fetch all modules available for teacher in a classroom
  Future<List<TeacherModuleModel>> getModules({
    required int classroomId,
    String? search,
    TeacherModuleStatus? status,
  }) async {
    final response = await teacherProvider.getModules(
      classroomId: classroomId,
      search: search,
      status: status,
    );
    return response.data;
  }

  /// Fetch detailed information of a module for teacher
  Future<TeacherModuleDetailModel> getModuleDetail({
    required int moduleId,
    required int classroomId,
  }) async {
    final response = await teacherProvider.getModuleDetail(
      moduleId: moduleId,
      classroomId: classroomId,
    );
    return response.data;
  }

  /// Fetch detailed information and blocks of a chapter for teacher
  Future<TeacherChapterDetailModel> getChapterDetail({
    required int chapterId,
  }) async {
    final response = await teacherProvider.getChapterDetail(
      chapterId: chapterId,
    );
    return response.data;
  }

  /// Publish a module for teacher
  Future<bool> publishModule(int moduleId) async {
    final response = await teacherProvider.publishModule(moduleId: moduleId);
    return response.data;
  }

  /// Delete a module for teacher
  Future<bool> deleteModule({
    required int moduleId,
    required int classroomId,
  }) async {
    final response = await teacherProvider.deleteModule(
      moduleId: moduleId,
      classroomId: classroomId,
    );
    return response.data;
  }

  /// Create a new module for teacher
  Future<TeacherNewestModuleModel> createModule({
    required String title,
    required String description,
    required int faseId,
    required int classroomId,
    String status = 'draft',
  }) async {
    final response = await teacherProvider.createModule(
      title: title,
      description: description,
      faseId: faseId,
      classroomId: classroomId,
      status: status,
    );
    return response.data;
  }

  /// Get list of fases for teacher
  Future<List<FaseModel>> getFases() async {
    final response = await teacherProvider.getFases();
    return response.data;
  }

  /// Get list of cp for teacher
  Future<List<CpModel>> getCpByFaseId(int faseId) async {
    final response = await teacherProvider.getCpByFaseId(faseId);
    return response.data;
  }

  /// Create a chapter by uploading a sliced PDF file
  Future<ChapterCreateResponseModel> createChapter({
    required List<int> fileBytes,
    required String fileName,
    required int moduleId,
    required String title,
    int cpId = 1,
    int? number,
  }) async {
    final response = await teacherProvider.createChapter(
      fileBytes: fileBytes,
      fileName: fileName,
      moduleId: moduleId,
      title: title,
      cpId: cpId,
      number: number,
    );
    return response.data;
  }

  /// Stream real-time job progress updates via SSE
  Stream<ChapterJobStreamEvent> streamChapterJob(int jobId) {
    return teacherProvider.streamChapterJob(jobId: jobId);
  }

  /// Get chapter annotation preview blocks
  Future<List<BlockPreviewResponseModel>> previewChapter(String annotationPath) async {
    final response = await teacherProvider.previewChapter(annotationPath: annotationPath);
    return response.data;
  }

  /// Confirm chapter annotation and ingest: POST /api/chapters/confirm/{chapter_id}
  Future<bool> confirmChapter({
    required int chapterId,
    required String annotationPath,
  }) async {
    final response = await teacherProvider.confirmChapter(
      chapterId: chapterId,
      annotationPath: annotationPath,
    );
    return response.message.isNotEmpty || response.data > 0;
  }

  /// Bulk regenerate special blocks (images, tables, diagrams): POST /api/blocks/bulk-regenerate/special
  Future<List<RegenerateDetailResponseModel>> bulkRegenerateSpecial({
    required List<int> blockIds,
    required String feedback,
  }) async {
    final response = await teacherProvider.bulkRegenerateSpecial(
      blockIds: blockIds,
      feedback: feedback,
    );
    return response.data;
  }

  /// Bulk regenerate text blocks: POST /api/blocks/bulk-regenerate/text
  Future<RegenerateResponseModel> bulkRegenerateText({
    required List<int> blockIds,
    required String feedback,
  }) async {
    final response = await teacherProvider.bulkRegenerateText(
      blockIds: blockIds,
      feedback: feedback,
    );
    return response.data;
  }

  /// Fetch list of quizzes for teacher: GET /api/teachers/quizzes/{quiz_id}/students
  Future<List<StudentProgressQuiz>> getStudentQuizzesProgress({
    required int classroomId,
    required int quizId,
  }) async {
    final response = await teacherProvider.getStudentQuizzesProgress(
      classroomId: classroomId,
      quizId: quizId,
    );
    return response.data;
  }

  /// Fetch list of quizzes for teacher: GET /api/teachers/quizzes
  Future<List<QuizRequestTeacherModel>> getQuizzes({
    required int classroomId,
    String? status,
  }) async {
    final response = await teacherProvider.getQuizzes(
      classroomId: classroomId,
      status: status,
    );
    return response.data;
  }

  /// Fetch quiz detail: GET /api/teachers/quizzes/{quiz_id}
  Future<QuizRequestTeacherDetailModel> getQuizDetail({
    required int quizId,
    required int classroomId,
  }) async {
    final response = await teacherProvider.getQuizDetail(
      quizId: quizId,
      classroomId: classroomId,
    );
    return response.data;
  }

  /// Delete quiz: DELETE /api/teachers/quizzes/{quiz_id}
  Future<bool> deleteQuiz({
    required int quizId,
    required int classroomId,
  }) async {
    final response = await teacherProvider.deleteQuiz(
      quizId: quizId,
      classroomId: classroomId,
    );
    return response.data;
  }

  /// Update quiz status (draft/publish): PATCH /api/teachers/quizzes/statuses/{quiz_id}
  Future<bool> updateQuizStatus({
    required int quizId,
    required int classroomId,
    required String status,
  }) async {
    final response = await teacherProvider.updateQuizStatus(
      quizId: quizId,
      classroomId: classroomId,
      status: status,
    );
    return response.data;
  }

  /// Create quiz stream (SSE): POST /api/teachers/quizzes
  Stream<QuizStreamEvent> createQuizStream(QuizRequestCreatePayload payload) {
    return teacherProvider.createQuizStream(payload);
  }

  /// Regenerate question stimulus: POST /api/teachers/soal/stimulus/regenerate/{soal_id}
  Future<List<SoalResponseModel>> regenerateStimulusSoal({
    required int soalId,
    required String feedback,
  }) async {
    final response = await teacherProvider.regenerateStimulusSoal(
      soalId: soalId,
      feedback: feedback,
    );
    return response.data;
  }

  /// Edit question: PATCH /api/teachers/soal/{soal_id}
  Future<SoalResponseModel> editSoal({
    required int soalId,
    required SoalEditRequest payload,
  }) async {
    final response = await teacherProvider.editSoal(
      soalId: soalId,
      payload: payload,
    );
    return response.data;
  }
}
