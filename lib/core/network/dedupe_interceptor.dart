import 'dart:async';
import 'package:dio/dio.dart';
import 'request_cache.dart';

class DedupeInterceptor extends Interceptor {
  final RequestCache _cache = RequestCache.instance;
  final Duration ttl;
  final Duration staleTolerance;

  DedupeInterceptor({
    this.ttl = const Duration(seconds: 5),
    this.staleTolerance = const Duration(milliseconds: 500),
  });

  bool _isCacheableMethod(String method) =>
      method == 'GET' || method == 'HEAD';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!_isCacheableMethod(options.method)) {
      handler.next(options);
      return;
    }

    final key = _cache.makeKey(
      options.path,
      options.queryParameters,
    );

    final cached = _cache.get(key, ttl);
    if (cached != null) {
      handler.resolve(Response(
        requestOptions: options,
        data: cached,
        statusCode: 200,
        statusMessage: 'OK (cached)',
      ));
      return;
    }

    final inflightCompleter = _cache.inflight[key];
    if (inflightCompleter != null) {
      inflightCompleter.future.then((data) {
        handler.resolve(Response(
          requestOptions: options,
          data: data,
          statusCode: 200,
          statusMessage: 'OK (inflight)',
        ));
      }).catchError((e) {
        handler.next(options);
      });
      return;
    }

    final completer = Completer<dynamic>();
    _cache.inflight[key] = completer;

    options.extra['dedupe_key'] = key;
    options.extra['dedupe_completer'] = completer;

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final key = response.requestOptions.extra['dedupe_key'] as String?;
    final completer =
        response.requestOptions.extra['dedupe_completer'] as Completer<dynamic>?;

    if (key != null) {
      _cache.set(key, response.data);
      _cache.inflight.remove(key);
      completer?.complete(response.data);
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final key = err.requestOptions.extra['dedupe_key'] as String?;
    final completer =
        err.requestOptions.extra['dedupe_completer'] as Completer<dynamic>?;

    if (key != null) {
      _cache.inflight.remove(key);
      completer?.completeError(err);
    }

    handler.next(err);
  }
}
