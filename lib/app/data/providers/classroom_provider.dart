import 'package:dio/dio.dart';
import 'package:novasight_app/app/core/constants/api_endpoints.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/network/dio_client.dart';
import 'package:novasight_app/app/data/models/api_response.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';

class ClassroomProvider {
  final DioClient dioClient;

  ClassroomProvider({required this.dioClient});

  /// GET /api/classroom-types — publicly accessible
  Future<ApiResponse<List<ClassroomTypeModel>>> getClassroomTypes() async {
    try {
      final response = await dioClient.get(ApiEndpoints.classroomTypes);
      return ApiResponse<List<ClassroomTypeModel>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map((e) =>
                ClassroomTypeModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengambil tipe kelas: ${e.toString()}',
      );
    }
  }

  /// GET /api/cities — requires TEACHER role
  Future<ApiResponse<List<CityResponseModel>>> getCities() async {
    try {
      final response = await dioClient.get(ApiEndpoints.cities);
      return ApiResponse<List<CityResponseModel>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map((e) =>
                CityResponseModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengambil daftar kota: ${e.toString()}',
      );
    }
  }

  /// GET /api/schools/city/{city_id} — requires TEACHER role
  Future<ApiResponse<List<SchoolResponseModel>>> getSchoolsByCity(
    int cityId,
  ) async {
    try {
      final response =
          await dioClient.get('${ApiEndpoints.schools}/city/$cityId');
      return ApiResponse<List<SchoolResponseModel>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map((e) =>
                SchoolResponseModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message:
            'Terjadi kesalahan saat mengambil daftar sekolah: ${e.toString()}',
      );
    }
  }

  /// POST /api/classrooms — requires TEACHER role
  Future<ApiResponse<ClassroomResponseModel>> createClassroom(
    ClassroomCreateModel request,
  ) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.classrooms,
        data: request.toJson(),
      );
      return ApiResponse<ClassroomResponseModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) =>
            ClassroomResponseModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat membuat kelas: ${e.toString()}',
      );
    }
  }

  /// POST /api/classrooms/join — requires STUDENT role
  Future<ApiResponse<void>> joinClassroom(
    JoinClassroomRequestModel request,
  ) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.joinClassroom,
        data: request.toJson(),
      );
      return ApiResponse<void>.fromJson(
        response.data as Map<String, dynamic>,
        (_) {},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message:
            'Terjadi kesalahan saat bergabung ke kelas: ${e.toString()}',
      );
    }
  }

  /// GET /api/classrooms — requires TEACHER or STUDENT role
  Future<ApiResponse<List<ClassroomResponseModel>>> getClassrooms() async {
    try {
      final response = await dioClient.get(ApiEndpoints.classrooms);
      return ApiResponse<List<ClassroomResponseModel>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .map((e) =>
                ClassroomResponseModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message:
            'Terjadi kesalahan saat mengambil daftar kelas: ${e.toString()}',
      );
    }
  }
}
