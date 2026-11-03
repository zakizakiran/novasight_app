import 'package:dio/dio.dart';
import 'package:lydera_app/app/core/network/database.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/api_exception.dart';
import '../../core/network/dio_client.dart';
import '../models/api_response.dart';

class RecordNoteRemoteProvider {

  final DioClient dioClient;

  RecordNoteRemoteProvider({required this.dioClient});

  Future<ApiResponse<RecordNoteData?>> getNotesByChapterId(int chapterId) async {
    try {
      final response = await dioClient.get(ApiEndpoints.studentRecordNote,queryParameters: {
        'chapter_id':chapterId
      });
      return ApiResponse<RecordNoteData?>.fromJson(
        response.data as Map<String, dynamic>,
            (data) => data == null
                ? null
                : RecordNoteData.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengambil catatan : ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<RecordNoteData>> createOrUpdateNote(RecordNoteData record) async {
    try {
      final response = await dioClient.post(ApiEndpoints.studentRecordNote,
      data: record.toJson());
      return ApiResponse<RecordNoteData>.fromJson(
        response.data as Map<String, dynamic>,
            (data) => RecordNoteData.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat menyimpan catatan : ${e.toString()}',
      );
    }
  }
}