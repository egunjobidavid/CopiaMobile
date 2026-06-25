class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://copiaos-backend.onrender.com/api/v1',
  );

  static const Duration requestTimeout = Duration(seconds: 30);
  static const String storageKeyAccessToken = 'access_token';
  static const String storageKeyRefreshToken = 'refresh_token';
  static const String storageKeyTenantId = 'tenant_id';
  static const String storageKeyUser = 'user';
}
