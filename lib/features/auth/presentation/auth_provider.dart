import 'dart:convert';
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
  final String? sessionId;
  final Map<String, dynamic>? user;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = true,
    this.biometricEnabled = false,
    this.accessToken,
    this.refreshToken,
    this.tenantId,
    this.sessionId,
    this.user,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? biometricEnabled,
    String? accessToken,
    String? refreshToken,
    String? tenantId,
    String? sessionId,
    Map<String, dynamic>? user,
  }) => AuthState(
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    isLoading: isLoading ?? this.isLoading,
    biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    accessToken: accessToken ?? this.accessToken,
    refreshToken: refreshToken ?? this.refreshToken,
    tenantId: tenantId ?? this.tenantId,
    sessionId: sessionId ?? this.sessionId,
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
      final sessionId = await _storage.getSessionId();

      if (token != null && token.isNotEmpty) {
        // Try to get user info
        Map<String, dynamic>? user;
        try {
          final response = await _api.get('/auth/me');
          final data = extractOne(response.data);
          user = data?['user'] as Map<String, dynamic>?;
        } catch (_) {
          // If /auth/me fails, try to restore from stored data
          try {
            final userData = await _storage.getUserData();
            if (userData != null && userData.isNotEmpty) {
              final parsed = jsonDecode(userData);
              if (parsed is Map<String, dynamic>) {
                user = parsed;
              }
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
            sessionId: sessionId,
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
      final data = response.data as Map<String, dynamic>;
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
        await _storage.setUserData(jsonEncode(user));
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
    try { await _storage.setTenantId(''); } catch (_) {}
    try { await _storage.setUserData(''); } catch (_) {}
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
