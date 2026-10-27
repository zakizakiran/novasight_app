import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:lydera_app/app/core/constants/api_endpoints.dart';
import 'package:lydera_app/app/core/errors/api_exception.dart';
import 'package:lydera_app/app/core/network/dio_client.dart';
import 'package:lydera_app/app/data/models/api_response.dart';
import 'package:lydera_app/app/data/models/student_model.dart';
import 'package:lydera_app/app/data/models/student_quiz_model.dart';

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

  /// GET /api/students/quizzes
  Future<ApiResponse<List<QuizRequestStudentResponse>>> getQuizzes({
    required int classroomId,
    QuizRequestStudentQueryStatus? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'classroom_id': classroomId,
      };
      if (status != null) {
        queryParams['status'] = status.value;
      }

      final response = await dioClient.get(
        ApiEndpoints.studentQuizzes,
        queryParameters: queryParams,
      );
      return ApiResponse<List<QuizRequestStudentResponse>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map((e) =>
                QuizRequestStudentResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengambil kuis siswa: ${e.toString()}',
      );
    }
  }

  /// POST /api/students/quizzes/{quiz_id}/start — SSE Stream
  Stream<StudentQuizEvent> startQuizStream({
    required int quizId,
  }) async* {
    try {
      final response = await dioClient.dio.post<ResponseBody>(
        ApiEndpoints.studentQuizStart(quizId),
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
            'Content-Type': 'application/json',
            'Cache-Control': 'no-cache',
          },
        ),
      );

      final stream = response.data!.stream
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (final line in stream) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith(':')) continue;

        String jsonStr = trimmed;
        if (trimmed.startsWith('data:')) {
          jsonStr = trimmed.substring(5).trim();
        }
        if (jsonStr.isEmpty) continue;

        try {
          final decoded = jsonDecode(jsonStr);
          if (decoded is Map<String, dynamic>) {
            final type = decoded['type'] as String? ?? '';
            if (type == 'INIT') {
              final questionsList = (decoded['questions'] as List? ?? [])
                  .map((e) => QuizRequestQuestionResponse.fromJson(
                      e as Map<String, dynamic>))
                  .toList();
              final targetEndTime = decoded['target_end_time'] != null
                  ? DateTime.tryParse(decoded['target_end_time'] as String)
                  : null;
              yield StudentQuizInitEvent(
                questions: questionsList,
                targetEndTime: targetEndTime,
              );
            } else if (type == 'TICK') {
              yield StudentQuizTickEvent(
                time: decoded['time'] as String? ?? '00:00',
              );
            } else if (type == 'TIMEOUT') {
              yield StudentQuizTimeoutEvent(
                message: decoded['message'] as String? ??
                    'Waktu pengerjaan telah habis',
              );
            } else if (decoded.containsKey('error')) {
              yield StudentQuizErrorEvent(
                error: decoded['error'] as String? ??
                    'Terjadi kesalahan pada kuis',
              );
            }
          }
        } catch (_) {
          // Skip SSE lines that are not valid JSON
        }
      }
    } on DioException catch (e) {
      String? errorBody;
      if (e.response?.data is ResponseBody) {
        try {
          final responseBody = e.response!.data as ResponseBody;
          final bytes = await responseBody.stream.toList();
          final fullBytes = bytes.expand((x) => x).toList();
          errorBody = utf8.decode(fullBytes);
        } catch (_) {}
      }
      if (errorBody != null && errorBody.isNotEmpty) {
        throw ApiException(
          message: ApiException.extractErrorMessageFromString(
              errorBody, e.response?.statusCode),
          statusCode: e.response?.statusCode,
          data: errorBody,
        );
      }
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Gagal memulai kuis: ${e.toString()}',
      );
    }
  }

  /// POST /api/students/soal/{soal_id}/select-option
  Future<ApiResponse<SoalSubmitResponse>> submitSoalAnswer({
    required int soalId,
    required SoalSubmitRequest request,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.studentSoalSubmit(soalId),
        data: request.toJson(),
      );
      return ApiResponse<SoalSubmitResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => SoalSubmitResponse.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengirim jawaban: ${e.toString()}',
      );
    }
  }

  /// POST /api/students/soal/{soal_id}/steps
  Future<ApiResponse<StudentStep>> submitStepAnswer({
    required int soalId,
    required SoalStepRequest request,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.studentSoalStep(soalId),
        data: request.toJson(),
      );
      return ApiResponse<StudentStep>.fromJson(
        response.data as Map<String, dynamic>,
            (data) => StudentStep.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengirim langkah: ${e.toString()}',
      );
    }
  }

  /// POST /api/students/steps/{step_id}
  Future<ApiResponse<bool>> deleteStepAnswer({
    required int stepId,
  }) async {
    try {
      final response = await dioClient.delete(
        ApiEndpoints.studentDeleteStep(stepId),
      );
      return ApiResponse<bool>.fromJson(
        response.data as Map<String, dynamic>,
            (data) => data as bool,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat menghapus langkah: ${e.toString()}',
      );
    }
  }

  /// POST /api/students/quizzes/{quiz_id}/finish
  Future<ApiResponse<Map<String, dynamic>>> finishQuiz({
    required int quizId,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.studentQuizFinish(quizId),
      );
      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as Map<String, dynamic>?) ?? {},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat menyelesaikan kuis: ${e.toString()}',
      );
    }
  }

  /// GET /api/students/quizzes/{quiz_request_id}/my-results
  Future<ApiResponse<List<QuizResultItem>>> getMyQuizResults({
    required int quizRequestId,
  }) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.studentQuizMyResults(quizRequestId),
      );
      return ApiResponse<List<QuizResultItem>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map((e) => QuizResultItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengambil hasil kuis: ${e.toString()}',
      );
    }
  }
}
