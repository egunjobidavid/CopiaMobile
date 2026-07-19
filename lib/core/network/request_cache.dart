import 'dart:async';

class _CacheEntry {
  final dynamic data;
  final DateTime timestamp;

  _CacheEntry(this.data) : timestamp = DateTime.now();

  bool isExpired(Duration ttl) =>
      DateTime.now().difference(timestamp) > ttl;
}

class RequestCache {
  static final RequestCache instance = RequestCache._();
  RequestCache._();

  final Map<String, _CacheEntry> _cache = {};
  final Map<String, Completer<dynamic>> _inflight = {};

  /// Expose inflight map for DedupeInterceptor to register before awaiting.
  Map<String, Completer<dynamic>> get inflight => _inflight;

  String makeKey(String path, [Map<String, dynamic>? params]) {
    if (params == null || params.isEmpty) return path;
    final sorted = params.entries
        .where((e) => e.value != null && e.value.toString().isNotEmpty)
        .toList()
        ..sort((a, b) => a.key.compareTo(b.key));
    final qs = sorted.map((e) => '${e.key}=${e.value}').join('&');
    return qs.isEmpty ? path : '$path?$qs';
  }

  dynamic get(String key, Duration ttl) {
    final entry = _cache[key];
    if (entry != null && !entry.isExpired(ttl)) return entry.data;
    _cache.remove(key);
    return null;
  }

  void set(String key, dynamic data) {
    _cache[key] = _CacheEntry(data);
  }

  Future<T> deduplicatedFetch<T>(
    String key,
    Future<T> Function() fetcher, {
    Duration ttl = const Duration(seconds: 5),
  }) async {
    final cached = get(key, ttl);
    if (cached != null) return cached as T;

    final inflight = _inflight[key];
    if (inflight != null) return inflight.future as Future<T>;

    final completer = Completer<dynamic>();
    _inflight[key] = completer;

    try {
      final result = await fetcher();
      set(key, result);
      completer.complete(result);
      return result;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _inflight.remove(key);
    }
  }

  void invalidate([String? pattern]) {
    if (pattern == null) {
      _cache.clear();
    } else {
      _cache.removeWhere((k, _) => k.contains(pattern));
    }
  }

  void clear() {
    _cache.clear();
    _inflight.clear();
  }
}
