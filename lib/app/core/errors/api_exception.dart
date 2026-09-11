import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiException(
          message: 'Koneksi ke server timeout. Silakan periksa jaringan internet Anda.',
          statusCode: null,
        );
      case DioExceptionType.sendTimeout:
        return const ApiException(
          message: 'Permintaan kirim data timeout. Silakan coba lagi.',
          statusCode: null,
        );
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Server membutuhkan waktu terlalu lama untuk merespons. Silakan coba lagi.',
          statusCode: null,
        );
      case DioExceptionType.badCertificate:
        return const ApiException(
          message: 'Sertifikat keamanan server tidak valid.',
          statusCode: null,
        );
      case DioExceptionType.badResponse:
        final response = dioException.response;
        final statusCode = response?.statusCode;
        final message = _extractErrorMessage(response?.data, statusCode);
        return ApiException(
          message: message,
          statusCode: statusCode,
          data: response?.data,
        );
      case DioExceptionType.cancel:
        return const ApiException(
          message: 'Permintaan dibatalkan.',
          statusCode: null,
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'Gagal terhubung ke server. Pastikan koneksi internet Anda aktif.',
          statusCode: null,
        );
      case DioExceptionType.unknown:
      default:
        return ApiException(
          message: dioException.message ?? 'Terjadi kesalahan yang tidak diketahui.',
          statusCode: null,
        );
    }
  }

  static String _extractErrorMessage(dynamic responseData, int? statusCode) {
    if (responseData is Map<String, dynamic>) {
      // 1. Check "detail" field
      final detail = responseData['detail'];
      if (detail is String && detail.isNotEmpty) {
        return _translateCommonErrors(detail, statusCode);
      } else if (detail is List && detail.isNotEmpty) {
        // FastAPI validation errors: detail: [{"msg": "...", "loc": [...]}]
        final first = detail.first;
        if (first is Map<String, dynamic> && first['msg'] != null) {
          return first['msg'].toString();
        }
      }

      // 2. Check "errors" field: {"errors": [{"msg": "...", "loc": [...]}]}
      final errors = responseData['errors'];
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is Map<String, dynamic> && first['msg'] != null) {
          return first['msg'].toString();
        }
      }

      // 3. Check "message" field
      final message = responseData['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    } else if (responseData is String && responseData.isNotEmpty) {
      return responseData;
    }

    // Default status code fallback
    switch (statusCode) {
      case 400:
        return 'Permintaan tidak valid. Silakan periksa kembali data Anda.';
      case 401:
        return 'Email atau kata sandi tidak valid.';
      case 403:
        return 'Anda tidak memiliki akses ke fitur ini.';
      case 404:
        return 'Data atau layanan tidak ditemukan.';
      case 422:
        return 'Format data yang dikirim tidak sesuai ketentuan.';
      case 500:
      case 502:
      case 503:
        return 'Terjadi gangguan pada server. Silakan coba beberapa saat lagi.';
      default:
        return 'Terjadi kesalahan (Kode: $statusCode). Silakan coba lagi.';
    }
  }

  static String _translateCommonErrors(String rawDetail, int? statusCode) {
    final lower = rawDetail.toLowerCase();
    if (lower.contains('email or password is invalid') || lower.contains('invalid credentials')) {
      return 'Email atau kata sandi salah. Silakan coba lagi.';
    }
    if (lower.contains('already exists') || lower.contains('already registered') || lower.contains('email is already registered')) {
      return 'Email sudah terdaftar. Silakan gunakan email lain atau masuk.';
    }
    if (lower.contains('user not found')) {
      return 'Pengguna tidak ditemukan.';
    }
    if (lower.contains('token expired') || lower.contains('unauthorized')) {
      return 'Sesi Anda telah berakhir. Silakan masuk kembali.';
    }
    return rawDetail;
  }

  @override
  String toString() => message;
}
