import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../../core/constants.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;

  AuthInterceptor(this._storage);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getAccessToken();
    final tenantId = await _storage.getTenantId();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    if (tenantId != null) {
      options.headers['x-tenant-id'] = tenantId;
    }

    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        try {
          final response = await Dio().post(
            '${ApiConstants.baseUrl}/auth/refresh',
            data: {'refreshToken': refreshToken},
          );
          final envelope = response.data as Map<String, dynamic>;
          final data = envelope['data'] as Map<String, dynamic>? ?? envelope;
          final newToken = data['accessToken'] as String;
          await _storage.setAccessToken(newToken);

          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final retryResponse = await Dio().fetch(err.requestOptions);
          handler.resolve(retryResponse);
          return;
        } catch (_) {
          await _storage.clearAll();
        }
      }
    }
    handler.next(err);
  }
}
