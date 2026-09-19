import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:novasight_app/app/core/constants/api_endpoints.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/network/dio_client.dart';
import 'package:novasight_app/app/data/models/api_response.dart';
import 'package:novasight_app/app/data/models/block_regenerate_model.dart';
import 'package:novasight_app/app/data/models/chapter_create_response_model.dart';
import 'package:novasight_app/app/data/models/chapter_job_stream_model.dart';
import 'package:novasight_app/app/data/models/fase_model.dart';
import 'package:novasight_app/app/data/models/quiz_teacher_model.dart';
import 'package:novasight_app/app/data/models/teacher_model.dart';

class TeacherProvider {
  final DioClient dioClient;

  TeacherProvider({required this.dioClient});

  /// GET /api/teachers/dashboard
  Future<ApiResponse<TeacherDashboardModel>> getDashboard({
    required int classroomId,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{'classroom_id': classroomId};
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      final response = await dioClient.get(
        ApiEndpoints.teacherDashboard,
        queryParameters: queryParams,
      );
      return ApiResponse<TeacherDashboardModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => TeacherDashboardModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message:
            'Terjadi kesalahan saat mengambil dashboard guru: ${e.toString()}',
      );
    }
  }

  /// GET /api/teachers/modules
  Future<ApiResponse<List<TeacherModuleModel>>> getModules({
    required int classroomId,
    String? search,
    TeacherModuleStatus? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{'classroom_id': classroomId};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (status != null) {
        queryParams['status'] = status.value;
      }

      final response = await dioClient.get(
        ApiEndpoints.teacherModules,
        queryParameters: queryParams,
      );
      return ApiResponse<List<TeacherModuleModel>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map((e) => TeacherModuleModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message:
            'Terjadi kesalahan saat mengambil daftar modul guru: ${e.toString()}',
      );
    }
  }

  /// GET /api/teachers/modules/{module_id}
  Future<ApiResponse<TeacherModuleDetailModel>> getModuleDetail({
    required int moduleId,
    required int classroomId,
  }) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.teacherModuleDetail(moduleId),
        queryParameters: {'classroom_id': classroomId},
      );
      return ApiResponse<TeacherModuleDetailModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) =>
            TeacherModuleDetailModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message:
            'Terjadi kesalahan saat mengambil detail modul guru: ${e.toString()}',
      );
    }
  }

  /// GET /api/teachers/chapters/{chapter_id}
  Future<ApiResponse<TeacherChapterDetailModel>> getChapterDetail({
    required int chapterId,
  }) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.teacherChapterDetail(chapterId),
      );
      return ApiResponse<TeacherChapterDetailModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) =>
            TeacherChapterDetailModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message:
            'Terjadi kesalahan saat mengambil detail bab guru: ${e.toString()}',
      );
    }
  }

  /// POST /api/modules/publish/{module_id}
  Future<ApiResponse<bool>> publishModule({required int moduleId}) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.publishModule(moduleId),
      );
      return ApiResponse<bool>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data as bool? ?? true,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message:
            'Terjadi kesalahan saat mempublikasikan modul: ${e.toString()}',
      );
    }
  }

  /// DELETE /api/teachers/modules/{module_id}?classroom_id={classroom_id}
  Future<ApiResponse<bool>> deleteModule({
    required int moduleId,
    required int classroomId,
  }) async {
    try {
      final response = await dioClient.delete(
        ApiEndpoints.teacherModuleDetail(moduleId),
        queryParameters: {'classroom_id': classroomId},
      );
      return ApiResponse<bool>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => true,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat menghapus modul: ${e.toString()}',
      );
    }
  }

  /// POST /api/modules
  Future<ApiResponse<TeacherNewestModuleModel>> createModule({
    required String title,
    required String description,
    required int faseId,
    required int classroomId,
    String status = 'draft',
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.createModule,
        data: {
          'title': title,
          'description': description,
          'fase_id': faseId,
          'classroom_id': classroomId,
          'status': status,
        },
      );
      return ApiResponse<TeacherNewestModuleModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) =>
            TeacherNewestModuleModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat membuat modul: ${e.toString()}',
      );
    }
  }

  /// GET /api/fases — requires TEACHER role
  Future<ApiResponse<List<FaseModel>>> getFases() async {
    try {
      final response = await dioClient.get(ApiEndpoints.fases);
      return ApiResponse<List<FaseModel>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map((e) => FaseModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message:
            'Terjadi kesalahan saat mengambil daftar fase: ${e.toString()}',
      );
    }
  }

  /// POST /api/chapters — multipart/form-data
  Future<ApiResponse<ChapterCreateResponseModel>> createChapter({
    required List<int> fileBytes,
    required String fileName,
    required int moduleId,
    required String title,
    int cpId = 1,
    int? number,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
        'module_id': moduleId,
        'title': title,
        'cp_id': cpId,
        'number': ?number,
      });

      final response = await dioClient.post(
        ApiEndpoints.createChapter,
        data: formData,
      );

      return ApiResponse<ChapterCreateResponseModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) =>
            ChapterCreateResponseModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat membuat chapter: ${e.toString()}',
      );
    }
  }

  /// GET /api/chapters/jobs/{job_id}/stream — SSE Stream
  Stream<ChapterJobStreamEvent> streamChapterJob({required int jobId}) async* {
    try {
      final response = await dioClient.dio.get<ResponseBody>(
        ApiEndpoints.chapterJobStream(jobId),
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'text/event-stream', 'Cache-Control': 'no-cache'},
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
            yield ChapterJobStreamEvent.fromJson(decoded);
          }
        } catch (_) {}
      }
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Gagal mendengarkan progress job chapter: ${e.toString()}',
      );
    }
  }

  /// GET /api/chapters/preview?annotation_path={annotation_path}
  Future<ApiResponse<List<BlockPreviewResponseModel>>> previewChapter({
    required String annotationPath,
  }) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.previewChapter,
        queryParameters: {'annotation_path': annotationPath},
      );
      return ApiResponse<List<BlockPreviewResponseModel>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map(
              (e) =>
                  BlockPreviewResponseModel.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message:
            'Terjadi kesalahan saat mengambil preview chapter: ${e.toString()}',
      );
    }
  }

  /// POST /api/chapters/confirm/{chapter_id}
  Future<ApiResponse<int>> confirmChapter({
    required int chapterId,
    required String annotationPath,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.confirmChapter(chapterId),
        data: {'annotation_path': annotationPath},
      );
      return ApiResponse<int>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data as int? ?? 0,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message:
            'Terjadi kesalahan saat mengonfirmasi chapter: ${e.toString()}',
      );
    }
  }

  /// POST /api/blocks/bulk-regenerate/special
  Future<ApiResponse<List<RegenerateDetailResponseModel>>>
      bulkRegenerateSpecial({
    required List<int> blockIds,
    required String feedback,
  }) async {
    try {
      final payload = RegenerateRequestModel(
        feedback: feedback,
        blockIds: blockIds,
      );
      final response = await dioClient.post(
        ApiEndpoints.bulkRegenerateSpecial,
        data: payload.toJson(),
      );
      return ApiResponse<List<RegenerateDetailResponseModel>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map(
              (e) => RegenerateDetailResponseModel.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message:
            'Terjadi kesalahan saat meregenerasi block gambar: ${e.toString()}',
      );
    }
  }

  /// POST /api/blocks/bulk-regenerate/text
  Future<ApiResponse<RegenerateResponseModel>> bulkRegenerateText({
    required List<int> blockIds,
    required String feedback,
  }) async {
    try {
      final payload = RegenerateRequestModel(
        feedback: feedback,
        blockIds: blockIds,
      );
      final response = await dioClient.post(
        ApiEndpoints.bulkRegenerateText,
        data: payload.toJson(),
      );
      return ApiResponse<RegenerateResponseModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) =>
            RegenerateResponseModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message:
            'Terjadi kesalahan saat meregenerasi block teks: ${e.toString()}',
      );
    }
  }

  /// GET /api/teachers/quizzes
  Future<ApiResponse<List<QuizRequestTeacherModel>>> getQuizzes({
    required int classroomId,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{'classroom_id': classroomId};
      if (status != null && status != 'Semua' && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await dioClient.get(
        ApiEndpoints.teacherQuizzes,
        queryParameters: queryParams,
      );

      return ApiResponse<List<QuizRequestTeacherModel>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map((e) =>
                QuizRequestTeacherModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengambil daftar kuis: ${e.toString()}',
      );
    }
  }

  /// GET /api/teachers/quizzes/{quiz_id}
  Future<ApiResponse<QuizRequestTeacherDetailModel>> getQuizDetail({
    required int quizId,
    required int classroomId,
  }) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.teacherQuizDetail(quizId),
        queryParameters: {'classroom_id': classroomId},
      );

      return ApiResponse<QuizRequestTeacherDetailModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => QuizRequestTeacherDetailModel.fromJson(
            data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengambil detail kuis: ${e.toString()}',
      );
    }
  }

  /// DELETE /api/teachers/quizzes/{quiz_id}
  Future<ApiResponse<bool>> deleteQuiz({
    required int quizId,
    required int classroomId,
  }) async {
    try {
      final response = await dioClient.delete(
        ApiEndpoints.teacherQuizDelete(quizId),
        data: {'classroom_id': classroomId},
      );

      return ApiResponse<bool>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data as bool? ?? true,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat menghapus kuis: ${e.toString()}',
      );
    }
  }

  /// PATCH /api/teachers/quizzes/statuses/{quiz_id}
  Future<ApiResponse<bool>> updateQuizStatus({
    required int quizId,
    required int classroomId,
    required String status,
  }) async {
    try {
      final response = await dioClient.patch(
        ApiEndpoints.teacherQuizStatus(quizId),
        data: {
          'classroom_id': classroomId,
          'status': status.toLowerCase(),
        },
      );

      return ApiResponse<bool>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data as bool? ?? true,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat memperbarui status kuis: ${e.toString()}',
      );
    }
  }

  /// POST /api/teachers/quizzes — SSE Stream
  Stream<QuizStreamEvent> createQuizStream(
      QuizRequestCreatePayload payload) async* {
    try {
      debugPrint('[TeacherProvider.createQuizStream] POST ${ApiEndpoints.teacherQuizzes}');
      debugPrint('[TeacherProvider.createQuizStream] Payload: ${jsonEncode(payload.toJson())}');

      final response = await dioClient.dio.post<ResponseBody>(
        ApiEndpoints.teacherQuizzes,
        data: payload.toJson(),
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
        debugPrint('[TeacherProvider.createQuizStream] Raw SSE Line: $line');
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
            final event = QuizStreamEvent.fromJson(decoded);
            debugPrint('[TeacherProvider.createQuizStream] Parsed Event -> status: "${event.status}", msg: "${event.message}", completed: ${event.completed}/${event.total}');
            yield event;
          }
        } catch (jsonErr) {
          debugPrint('[TeacherProvider.createQuizStream] JSON parse error: $jsonErr on: $jsonStr');
        }
      }
    } on DioException catch (e) {
      debugPrint('[TeacherProvider.createQuizStream] DioException caught: ${e.message} (status: ${e.response?.statusCode})');
      String? errorBody;
      if (e.response?.data is ResponseBody) {
        try {
          final responseBody = e.response!.data as ResponseBody;
          final bytes = await responseBody.stream.toList();
          final fullBytes = bytes.expand((x) => x).toList();
          errorBody = utf8.decode(fullBytes);
          debugPrint('[TeacherProvider.createQuizStream] Extracted server error body: $errorBody');
        } catch (streamErr) {
          debugPrint('[TeacherProvider.createQuizStream] Could not read error response stream: $streamErr');
        }
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
    } catch (e, stack) {
      debugPrint('[TeacherProvider.createQuizStream] Unexpected exception: $e\n$stack');
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Gagal mendengarkan progress pembuatan kuis: ${e.toString()}',
      );
    }
  }

  /// POST /api/teachers/soal/stimulus/regenerate/{soal_id}
  Future<ApiResponse<List<SoalResponseModel>>> regenerateStimulusSoal({
    required int soalId,
    required String feedback,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.teacherSoalStimulusRegenerate(soalId),
        data: {'feedback': feedback},
      );

      return ApiResponse<List<SoalResponseModel>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map((e) =>
                SoalResponseModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat meregenerasi stimulus soal: ${e.toString()}',
      );
    }
  }

  /// PATCH /api/teachers/soal/{soal_id}
  Future<ApiResponse<SoalResponseModel>> editSoal({
    required int soalId,
    required SoalEditRequest payload,
  }) async {
    try {
      final response = await dioClient.patch(
        ApiEndpoints.teacherSoalEdit(soalId),
        data: payload.toJson(),
      );

      return ApiResponse<SoalResponseModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => SoalResponseModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengubah soal: ${e.toString()}',
      );
    }
  }
}
