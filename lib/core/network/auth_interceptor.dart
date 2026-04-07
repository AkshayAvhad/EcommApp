import 'package:dio/dio.dart';
import 'package:ecomm/features/auth/data/datasources/auth_local_data_source.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource authLocalDataSource;

  AuthInterceptor({required this.authLocalDataSource});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Grab the token from Secure Storage
    final token = await authLocalDataSource.getToken();

    // 2. If token exists, add it to headers
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // 3. Continue the request
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 4. If we get a 401 (Unauthorized), we should trigger a logout!
    if (err.response?.statusCode == 401) {
      // We will handle the "Auto-Logout" logic here later via the Auth BLoC
    }
    return handler.next(err);
  }
}
