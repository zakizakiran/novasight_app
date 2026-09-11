import 'package:dio/dio.dart';
import 'package:novasight_app/app/core/constants/api_endpoints.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/network/dio_client.dart';
import 'package:novasight_app/app/data/models/api_response.dart';
import 'package:novasight_app/app/data/models/auth_request_model.dart';
import 'package:novasight_app/app/data/models/user_model.dart';

class AuthProvider {
  final DioClient dioClient;

  AuthProvider({required this.dioClient});

  Future<ApiResponse<String>> login(LoginRequestModel request) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );
      return ApiResponse<String>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data.toString(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Terjadi kesalahan saat login: ${e.toString()}');
    }
  }

  Future<ApiResponse<StudentResponseModel>> registerStudent(
    RegisterStudentRequestModel request,
  ) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.registerStudent,
        data: request.toJson(),
      );
      return ApiResponse<StudentResponseModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => StudentResponseModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat registrasi siswa: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<TeacherResponseModel>> registerTeacher(
    RegisterTeacherRequestModel request,
  ) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.registerTeacher,
        data: request.toJson(),
      );
      return ApiResponse<TeacherResponseModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => TeacherResponseModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat registrasi guru: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<ProfileResponseModel>> getProfile() async {
    try {
      final response = await dioClient.get(ApiEndpoints.profile);
      return ApiResponse<ProfileResponseModel>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => ProfileResponseModel.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Terjadi kesalahan saat mengambil data profil: ${e.toString()}',
      );
    }
  }
}
