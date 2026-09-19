import 'package:dio/dio.dart';
import 'package:novasight_app/app/core/constants/api_endpoints.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/network/dio_client.dart';
import 'package:novasight_app/app/data/models/api_response.dart';
import 'package:novasight_app/app/data/models/chatbot_model.dart';

class ChatbotProvider {
  final DioClient dioClient;

  ChatbotProvider({required this.dioClient});

  /// POST /api/chatbot/sessions — Student creates new chat session
  Future<ApiResponse<ChatSessionResponse>> createSession(
    ChatSessionCreate request,
  ) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.chatbotSessions,
        data: request.toJson(),
      );
      return ApiResponse<ChatSessionResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => ChatSessionResponse.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat membuat sesi chatbot: ${e.toString()}',
      );
    }
  }

  /// GET /api/chatbot/sessions — Student lists chat sessions for a classroom
  Future<ApiResponse<List<ChatSessionResponseWithMessage>>> getSessions({
    required int classroomId,
  }) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.chatbotSessions,
        queryParameters: {'classroom_id': classroomId},
      );
      return ApiResponse<List<ChatSessionResponseWithMessage>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map((e) => ChatSessionResponseWithMessage.fromJson(
                e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengambil riwayat sesi chatbot: ${e.toString()}',
      );
    }
  }

  /// POST /api/chatbot/sessions/{session_id}/messages — Student asks question
  Future<ApiResponse<ChatAnswerResponse>> askQuestion({
    required int sessionId,
    required ChatAskRequest request,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.chatbotSessionMessages(sessionId),
        data: request.toJson(),
      );
      return ApiResponse<ChatAnswerResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => ChatAnswerResponse.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengirim pertanyaan chatbot: ${e.toString()}',
      );
    }
  }

  /// GET /api/chatbot/sessions/{session_id}/messages — Student lists messages in a session
  Future<ApiResponse<List<ChatMessageResponse>>> getMessages({
    required int sessionId,
  }) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.chatbotSessionMessages(sessionId),
      );
      return ApiResponse<List<ChatMessageResponse>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map((e) =>
                ChatMessageResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat memuat pesan chatbot: ${e.toString()}',
      );
    }
  }

  /// POST /api/chatbot/chapters/{chapter_id}/reindex — Teacher reindexes a chapter
  Future<ApiResponse<dynamic>> reindexChapter(int chapterId) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.chatbotChapterReindex(chapterId),
      );
      return ApiResponse<dynamic>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat reindex bab: ${e.toString()}',
      );
    }
  }

  /// POST /api/chatbot/classrooms/{classroom_id}/reindex — Teacher reindexes entire classroom
  Future<ApiResponse<dynamic>> reindexClassroom(int classroomId) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.chatbotClassroomReindex(classroomId),
      );
      return ApiResponse<dynamic>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat reindex kelas: ${e.toString()}',
      );
    }
  }
}
