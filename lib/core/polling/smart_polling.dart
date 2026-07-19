import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Configuration for smart polling.
class SmartPollConfig {
  final Duration interval;
  final bool pauseWhenHidden;
  final int maxErrorsBeforeBackoff;
  final double backoffMultiplier;
  final Duration maxBackoffInterval;

  const SmartPollConfig({
    this.interval = const Duration(seconds: 30),
    this.pauseWhenHidden = true,
    this.maxErrorsBeforeBackoff = 3,
    this.backoffMultiplier = 2.0,
    this.maxBackoffInterval = const Duration(minutes: 5),
  });
}

/// State of the smart poller.
class SmartPollState<T> {
  final T? data;
  final bool isPolling;
  final bool isPaused;
  final DateTime? lastPollAt;
  final int errorCount;

  const SmartPollState({
    this.data,
    this.isPolling = false,
    this.isPaused = false,
    this.lastPollAt,
    this.errorCount = 0,
  });

  SmartPollState<T> copyWith({
    T? data,
    bool? isPolling,
    bool? isPaused,
    DateTime? lastPollAt,
    int? errorCount,
  }) {
    return SmartPollState<T>(
      data: data ?? this.data,
      isPolling: isPolling ?? this.isPolling,
      isPaused: isPaused ?? this.isPaused,
      lastPollAt: lastPollAt ?? this.lastPollAt,
      errorCount: errorCount ?? this.errorCount,
    );
  }
}

/// Smart poller that pauses when app is hidden, backs off on errors.
class SmartPoller<T> extends StateNotifier<SmartPollState<T>> {
  final Future<T> Function() fetcher;
  final SmartPollConfig config;
  final void Function(T data)? onSuccess;
  final void Function(Object error)? onErrorCallback;

  Timer? _timer;
  Duration _currentInterval;
  int _pauseCount = 0;
  bool _disposed = false;

  SmartPoller({
    required this.fetcher,
    this.config = const SmartPollConfig(),
    this.onSuccess,
    this.onErrorCallback,
  })  : _currentInterval = config.interval,
        super(const SmartPollState()) {
    _start();
  }

  void _start() {
    _poll();
    _timer = Timer.periodic(_currentInterval, (_) => _poll());
  }

  Future<void> _poll() async {
    if (_disposed || state.isPaused) return;

    state = state.copyWith(isPolling: true);
    try {
      final result = await fetcher();
      if (!_disposed) {
        state = state.copyWith(
          data: result,
          isPolling: false,
          lastPollAt: DateTime.now(),
          errorCount: 0,
        );
        _currentInterval = config.interval; // Reset backoff
        onSuccess?.call(result);
      }
    } catch (e) {
      if (!_disposed) {
        final newErrorCount = state.errorCount + 1;
        state = state.copyWith(
          isPolling: false,
          errorCount: newErrorCount,
        );

        // Apply backoff if too many errors
        if (newErrorCount >= config.maxErrorsBeforeBackoff) {
          final backoffMs = (_currentInterval.inMilliseconds *
                  config.backoffMultiplier)
              .round();
          _currentInterval = Duration(
            milliseconds: backoffMs < config.maxBackoffInterval.inMilliseconds
                ? backoffMs
                : config.maxBackoffInterval.inMilliseconds,
          );
          _restart();
        }

        onErrorCallback?.call(e);
      }
    }
  }

  void _restart() {
    _timer?.cancel();
    if (!_disposed && !state.isPaused) {
      _timer = Timer.periodic(_currentInterval, (_) => _poll());
    }
  }

  /// Force an immediate poll.
  void pollNow() {
    _poll();
  }

  /// Pause polling.
  void pause() {
    _pauseCount++;
    state = state.copyWith(isPaused: true);
    _timer?.cancel();
  }

  /// Resume polling.
  void resume() {
    _pauseCount = (_pauseCount - 1).clamp(0, 999);
    if (_pauseCount == 0) {
      state = state.copyWith(isPaused: false);
      _currentInterval = config.interval; // Reset backoff on resume
      _restart();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}

/// Mixin for StateNotifierProviders that adds smart polling behavior.
///
/// Usage:
///   final myProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
///     return MyNotifier(ref);
///   });
///
///   class MyNotifier extends StateNotifier<MyState> with SmartPollMixin<MyState> {
///     MyNotifier(Ref ref) : super(const MyState()) {
///       initSmartPoll(ref, fetcher: () async { ... }, interval: Duration(seconds: 30));
///     }
///   }
mixin SmartPollMixin<T> on StateNotifier<T> {
  Timer? _smartPollTimer;
  Duration _smartPollInterval = const Duration(seconds: 30);
  int _smartPollPauseCount = 0;
  bool _smartPollDisposed = false;

  void initSmartPoll(
    dynamic ref, {
    required Future<void> Function() fetcher,
    Duration interval = const Duration(seconds: 30),
    bool pauseWhenHidden = true,
  }) {
    _smartPollInterval = interval;
    _smartPollFetch = fetcher;

    _smartPoll();
    _smartPollTimer = Timer.periodic(interval, (_) => _smartPoll());
  }

  Future<void> Function()? _smartPollFetch;

  Future<void> _smartPoll() async {
    if (_smartPollDisposed || _smartPollPauseCount > 0) return;
    try {
      await _smartPollFetch?.call();
    } catch (_) {}
  }

  void smartPollPause() {
    _smartPollPauseCount++;
    _smartPollTimer?.cancel();
  }

  void smartPollResume() {
    _smartPollPauseCount = (_smartPollPauseCount - 1).clamp(0, 999);
    if (_smartPollPauseCount == 0) {
      _smartPollTimer?.cancel();
      _smartPollTimer = Timer.periodic(_smartPollInterval, (_) => _smartPoll());
    }
  }

  void smartPollNow() => _smartPoll();

  @override
  void dispose() {
    _smartPollDisposed = true;
    _smartPollTimer?.cancel();
    super.dispose();
  }
}

/// Widget that automatically pauses/resumes a SmartPoller based on app lifecycle.
class SmartPollLifecycle extends StatefulWidget {
  final SmartPoller poller;
  final Widget child;

  const SmartPollLifecycle({
    super.key,
    required this.poller,
    required this.child,
  });

  @override
  State<SmartPollLifecycle> createState() => _SmartPollLifecycleState();
}

class _SmartPollLifecycleState extends State<SmartPollLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      widget.poller.pause();
    } else if (state == AppLifecycleState.resumed) {
      widget.poller.resume();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
