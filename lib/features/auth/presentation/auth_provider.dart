import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final bool biometricEnabled;
  final String? accessToken;
  final String? refreshToken;
  final String? tenantId;
  final Map<String, dynamic>? user;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = true,
    this.biometricEnabled = false,
    this.accessToken,
    this.refreshToken,
    this.tenantId,
    this.user,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? biometricEnabled,
    String? accessToken,
    String? refreshToken,
    String? tenantId,
    Map<String, dynamic>? user,
  }) => AuthState(
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    isLoading: isLoading ?? this.isLoading,
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

  AuthNotifier(this._storage, this._api) : super(const AuthState()) {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    try {
      final token = await _storage.getAccessToken();
      final refreshToken = await _storage.getRefreshToken();
      final tenantId = await _storage.getTenantId();

      if (token != null && token.isNotEmpty) {
        // Try to get user info
        Map<String, dynamic>? user;
        try {
          final response = await _api.get('/auth/me');
          final data = extractOne(response.data);
          user = data?['user'] as Map<String, dynamic>?;
        } catch (_) {
          // If /auth/me fails, token might be expired — still restore what we have
          try {
            final userData = await _storage.getUserData();
            if (userData != null) {
              user = Map<String, dynamic>.from(
                Map<String, dynamic>.from(
                  const {} // fallback
                )..addAll({'fullName': 'User'})
              );
            }
          } catch (_) {}
        }

        if (mounted) {
          state = AuthState(
            isAuthenticated: true,
            isLoading: false,
            accessToken: token,
            refreshToken: refreshToken,
            tenantId: tenantId,
            user: user,
          );
        }
        return;
      }
    } catch (_) {}

    if (mounted) {
      state = const AuthState(isLoading: false);
    }
  }

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
      final tenantId = data['tenantId'] as String? ??
          (data['tenant'] as Map<String, dynamic>?)?['id'] as String?;
      final user = data['user'] as Map<String, dynamic>?;

      await _storage.setAccessToken(accessToken);
      if (refreshToken.isNotEmpty) {
        await _storage.setRefreshToken(refreshToken);
      }
      if (tenantId != null) {
        await _storage.setTenantId(tenantId);
      }
      if (user != null) {
        await _storage.setUserData(
          const <String, dynamic>{}.toString(),
        );
      }

      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        accessToken: accessToken,
        refreshToken: refreshToken,
        tenantId: tenantId,
        user: user,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try { await _storage.deleteToken(); } catch (_) {}
    try { await _storage.deleteRefreshToken(); } catch (_) {}
    state = const AuthState(isLoading: false);
  }

  void setBiometricEnabled(bool enabled) {
    state = state.copyWith(biometricEnabled: enabled);
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final api = ref.watch(apiClientProvider);
  return AuthNotifier(storage, api);
});
