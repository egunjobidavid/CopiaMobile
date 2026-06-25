import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage() : _storage = const FlutterSecureStorage();

  Future<void> setAccessToken(String token) async {
    await _storage.write(key: ApiConstants.storageKeyAccessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: ApiConstants.storageKeyAccessToken);
  }

  Future<void> setRefreshToken(String token) async {
    await _storage.write(key: ApiConstants.storageKeyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: ApiConstants.storageKeyRefreshToken);
  }

  Future<void> setTenantId(String id) async {
    await _storage.write(key: ApiConstants.storageKeyTenantId, value: id);
  }

  Future<String?> getTenantId() async {
    return _storage.read(key: ApiConstants.storageKeyTenantId);
  }

  Future<void> setUserData(String data) async {
    await _storage.write(key: ApiConstants.storageKeyUser, value: data);
  }

  Future<String?> getUserData() async {
    return _storage.read(key: ApiConstants.storageKeyUser);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Legacy alias methods
  Future<void> saveToken(String token) => setAccessToken(token);
  Future<void> saveRefreshToken(String token) => setRefreshToken(token);
  Future<void> saveTenantId(String id) => setTenantId(id);
  Future<void> deleteToken() => _storage.delete(key: ApiConstants.storageKeyAccessToken);
  Future<void> deleteRefreshToken() => _storage.delete(key: ApiConstants.storageKeyRefreshToken);
}
