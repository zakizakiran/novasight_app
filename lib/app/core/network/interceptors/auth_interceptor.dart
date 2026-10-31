import 'package:dio/dio.dart';
import 'package:lydera_app/app/core/constants/api_endpoints.dart';
import 'package:lydera_app/app/core/utils/user_roles.dart';
import 'package:lydera_app/app/data/models/auth_request_model.dart';
import 'package:lydera_app/app/data/providers/auth_provider.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';

class AuthInterceptor extends QueuedInterceptor {
  final StorageService storageService;
  final Dio dio;
  final Dio authDio;

  AuthInterceptor({required this.storageService, required this.dio, required this.authDio});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Inject Bearer token if present and not already added
    try {
      if (!options.headers.containsKey('Authorization')) {
        final token = await storageService.getAccessToken();

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
        ),
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final requestOptions = err.requestOptions;

    if (statusCode != 401 || requestOptions.extra['retryAfterLogin'] == true) {
      handler.next(err);
      return;
    }
    try {
      final email = storageService.getUserEmail();
      final password = await storageService.getPassword();
      final role = storageService.getRole();

      if (email == null || email.isEmpty || password == null || password.isEmpty || role == null) {
        handler.next(err);
        return;
      }

      final backendRole = UserRoleHelper.mapRoleToBackend(role);
      final loginResponse = await authDio.post(
        ApiEndpoints.login,
        data: LoginRequestModel(
          email: email,
          password: password,
          role: backendRole,
        ).toJson(),
      );

      final token = loginResponse.data['data'];
      await storageService.writeAccessToken(token);

      requestOptions.headers['Authorization'] = 'Bearer $token';
      requestOptions.extra['retryAfterLogin'] = true;

      final retryResponse = await dio.fetch(requestOptions);
      handler.resolve(retryResponse);

    } on DioException catch (e) {
      handler.next(e);
    } catch (e) {
      handler.next(
        DioException(
          requestOptions: requestOptions,
          error: e,
        ),
      );
    }
  }
}
