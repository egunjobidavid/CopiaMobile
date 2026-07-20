import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

class SecureStorage {
  FlutterSecureStorage? _storage;

  SecureStorage() {
    try {
      _storage = const FlutterSecureStorage();
    } catch (_) {
      _storage = null;
    }
  }

  Future<void> setAccessToken(String token) async {
    try {
      await _storage?.write(key: ApiConstants.storageKeyAccessToken, value: token);
    } catch (_) {}
  }

  Future<String?> getAccessToken() async {
    try {
      return await _storage?.read(key: ApiConstants.storageKeyAccessToken);
    } catch (_) {
      return null;
    }
  }

  Future<void> setRefreshToken(String token) async {
    try {
      await _storage?.write(key: ApiConstants.storageKeyRefreshToken, value: token);
    } catch (_) {}
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage?.read(key: ApiConstants.storageKeyRefreshToken);
    } catch (_) {
      return null;
    }
  }

  Future<void> setTenantId(String id) async {
    try {
      await _storage?.write(key: ApiConstants.storageKeyTenantId, value: id);
    } catch (_) {}
  }

  Future<String?> getTenantId() async {
    try {
      return await _storage?.read(key: ApiConstants.storageKeyTenantId);
    } catch (_) {
      return null;
    }
  }

  Future<void> setUserData(String data) async {
    try {
      await _storage?.write(key: ApiConstants.storageKeyUser, value: data);
    } catch (_) {}
  }

  Future<String?> getUserData() async {
    try {
      return await _storage?.read(key: ApiConstants.storageKeyUser);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAll() async {
    try {
      await _storage?.deleteAll();
    } catch (_) {}
  }

  Future<void> setSessionId(String id) async {
    try {
      await _storage?.write(key: 'session_id', value: id);
    } catch (_) {}
  }

  Future<String?> getSessionId() async {
    try {
      return await _storage?.read(key: 'session_id');
    } catch (_) {
      return null;
    }
  }

  // Legacy alias methods
  Future<void> saveToken(String token) => setAccessToken(token);
  Future<void> saveRefreshToken(String token) => setRefreshToken(token);
  Future<void> saveTenantId(String id) => setTenantId(id);
  Future<void> deleteToken() async {
    try { await _storage?.delete(key: ApiConstants.storageKeyAccessToken); } catch (_) {}
  }
  Future<void> deleteRefreshToken() async {
    try { await _storage?.delete(key: ApiConstants.storageKeyRefreshToken); } catch (_) {}
  }
}
