import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../../core/constants.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;

  AuthInterceptor(this._storage);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _storage.getAccessToken();
      final tenantId = await _storage.getTenantId();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      if (tenantId != null && tenantId.isNotEmpty) {
        options.headers['x-tenant-id'] = tenantId;
      }
    } catch (_) {
      // SecureStorage may fail on web — continue without auth headers
      // The server will return 401 if auth is required
    }

    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _storage.getRefreshToken();
        if (refreshToken != null && refreshToken.isNotEmpty) {
          try {
            final response = await Dio().post(
              '${ApiConstants.baseUrl}/auth/refresh',
              data: {'refreshToken': refreshToken},
            );
            final envelope = response.data as Map<String, dynamic>;
            final data = envelope['data'] as Map<String, dynamic>? ?? envelope;
            final newToken = data['accessToken'] as String?;
            if (newToken != null) {
              await _storage.setAccessToken(newToken);
              err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final retryResponse = await Dio().fetch(err.requestOptions);
              handler.resolve(retryResponse);
              return;
            }
          } catch (_) {
            try { await _storage.clearAll(); } catch (_) {}
          }
        }
      } catch (_) {
        // SecureStorage failure — just pass through the 401
      }
    }
    handler.next(err);
  }
}
