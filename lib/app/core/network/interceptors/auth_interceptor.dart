import 'package:dio/dio.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';

class AuthInterceptor extends QueuedInterceptor {
  final StorageService storageService;

  AuthInterceptor({required this.storageService});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Inject Bearer token if present and not already added
    if (!options.headers.containsKey('Authorization')) {
      final token = await storageService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Clear token upon 401 unauthorized to prevent stale auth states
      await storageService.clearAccessToken();
    }
    handler.next(err);
  }
}
