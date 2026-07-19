import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage.dart';
import '../../core/constants.dart';
import 'auth_interceptor.dart';
import 'dedupe_interceptor.dart';

class EnvelopeInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final raw = response.data;
    if (raw is Map && raw.containsKey('success') && raw.containsKey('data')) {
      response.data = raw['data'];
    }
    handler.next(response);
  }
}

/// Extracts a list from any backend response format.
/// Handles: {data: [...]}, {rows: [...]}, or raw [...]
List<Map<String, dynamic>> extractList(dynamic data) {
  if (data is List) {
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
  if (data is Map) {
    if (data.containsKey('data') && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    if (data.containsKey('rows') && data['rows'] is List) {
      return (data['rows'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
  }
  return [];
}

/// Extracts a single object from any backend response format.
Map<String, dynamic>? extractOne(dynamic data) {
  if (data is Map) return Map<String, dynamic>.from(data);
  return null;
}

class ApiClient {
  late final Dio _dio;
  final SecureStorage _storage;

  ApiClient(this._storage) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.requestTimeout,
      receiveTimeout: ApiConstants.requestTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.addAll([
      DedupeInterceptor(ttl: const Duration(seconds: 5)),
      EnvelopeInterceptor(),
      AuthInterceptor(_storage),
    ]);
  }

  Dio get client => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post<T>(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
  }) {
    return _dio.patch<T>(path, data: data);
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
  }) {
    return _dio.put<T>(path, data: data);
  }

  Future<Response<T>> delete<T>(String path) {
    return _dio.delete<T>(path);
  }
}

/// Shared ApiClient singleton — all screens should use this
final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return ApiClient(storage);
});
