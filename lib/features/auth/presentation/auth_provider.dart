import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';

class AuthState {
  final bool isAuthenticated;
  final bool biometricEnabled;
  final String? accessToken;
  final String? refreshToken;
  final String? tenantId;
  final Map<String, dynamic>? user;

  const AuthState({
    this.isAuthenticated = false,
    this.biometricEnabled = false,
    this.accessToken,
    this.refreshToken,
    this.tenantId,
    this.user,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? biometricEnabled,
    String? accessToken,
    String? refreshToken,
    String? tenantId,
    Map<String, dynamic>? user,
  }) => AuthState(
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    accessToken: accessToken ?? this.accessToken,
    refreshToken: refreshToken ?? this.refreshToken,
    tenantId: tenantId ?? this.tenantId,
    user: user ?? this.user,
  );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SecureStorage _storage;
  final ApiClient _api;

  AuthNotifier(this._storage, this._api) : super(const AuthState());

  Future<void> login(String email, String password) async {
    try {
      final response = await _api.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final envelope = response.data as Map<String, dynamic>;
      final data = envelope['data'] as Map<String, dynamic>? ?? envelope;
      final accessToken = data['accessToken'] as String;
      final refreshToken = data['refreshToken'] as String? ?? '';
      final tenantId = data['tenantId'] as String? ?? (data['tenant'] as Map<String, dynamic>?)?['id'] as String?;

      await _storage.saveToken(accessToken);
      if (refreshToken.isNotEmpty) {
        await _storage.saveRefreshToken(refreshToken);
      }
      if (tenantId != null) {
        await _storage.saveTenantId(tenantId);
      }

      state = AuthState(
        isAuthenticated: true,
        accessToken: accessToken,
        refreshToken: refreshToken,
        tenantId: tenantId,
        user: data['user'] as Map<String, dynamic>?,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.deleteToken();
    await _storage.deleteRefreshToken();
    state = const AuthState();
  }

  void setBiometricEnabled(bool enabled) {
    state = state.copyWith(biometricEnabled: enabled);
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final api = ApiClient(storage);
  return AuthNotifier(storage, api);
});
