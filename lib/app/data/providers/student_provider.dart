import 'package:dio/dio.dart';
import 'package:novasight_app/app/core/constants/api_endpoints.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/network/dio_client.dart';
import 'package:novasight_app/app/data/models/api_response.dart';
import 'package:novasight_app/app/data/models/student_model.dart';

class StudentProvider {
  final DioClient dioClient;

  StudentProvider({required this.dioClient});

  /// GET /api/students/dashboard
  Future<ApiResponse<StudentDashboardModel>> getDashboard({
    required int classroomId,
  }) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.studentDashboard,
        queryParameters: {'classroom_id': classroomId},
      );
      return ApiResponse<StudentDashboardModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => StudentDashboardModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengambil dashboard siswa: ${e.toString()}',
      );
    }
  }

  /// GET /api/students/dashboard/tasks
  Future<ApiResponse<StudentTaskModel>> getDashboardTasks({
    required int classroomId,
    StudentTaskStatus? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'classroom_id': classroomId,
      };
      if (status != null) {
        queryParams['status'] = status.value;
      }

      final response = await dioClient.get(
        ApiEndpoints.studentDashboardTasks,
        queryParameters: queryParams,
      );
      return ApiResponse<StudentTaskModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => StudentTaskModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengambil tugas siswa: ${e.toString()}',
      );
    }
  }

  /// GET /api/students/modules
  Future<ApiResponse<List<StudentModuleModel>>> getModules({
    required int classroomId,
    StudentModuleStatus? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'classroom_id': classroomId,
      };
      if (status != null) {
        queryParams['status'] = status.value;
      }

      final response = await dioClient.get(
        ApiEndpoints.studentModules,
        queryParameters: queryParams,
      );
      return ApiResponse<List<StudentModuleModel>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map((e) => StudentModuleModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengambil modul siswa: ${e.toString()}',
      );
    }
  }

  /// GET /api/students/modules/{module_id}
  Future<ApiResponse<StudentModuleDetailModel>> getModuleDetail({
    required int moduleId,
    required int classroomId,
  }) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.studentModuleDetail(moduleId),
        queryParameters: {'classroom_id': classroomId},
      );
      return ApiResponse<StudentModuleDetailModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) =>
            StudentModuleDetailModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengambil detail modul: ${e.toString()}',
      );
    }
  }

  /// POST /api/students/chapters/{chapter_id}/start
  Future<ApiResponse<StudentChapterDetailModel>> startChapter({
    required int chapterId,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.studentChapterStart(chapterId),
      );
      return ApiResponse<StudentChapterDetailModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) =>
            StudentChapterDetailModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat membuka bab materi: ${e.toString()}',
      );
    }
  }

  /// POST /api/students/chapters/{chapter_id}/mark-complete
  Future<ApiResponse<bool>> markChapterComplete({
    required int chapterId,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.studentChapterMarkComplete(chapterId),
      );
      return ApiResponse<bool>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data as bool? ?? false,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat menandai bab selesai: ${e.toString()}',
      );
    }
  }
}
