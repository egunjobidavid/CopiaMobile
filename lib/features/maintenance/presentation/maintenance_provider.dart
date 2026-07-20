import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

class MaintenanceState {
  final bool checking;
  final bool enabled;
  final String message;
  final String? error;

  const MaintenanceState({
    this.checking = true,
    this.enabled = false,
    this.message = '',
    this.error,
  });

  MaintenanceState copyWith({
    bool? checking,
    bool? enabled,
    String? message,
    String? error,
  }) => MaintenanceState(
    checking: checking ?? this.checking,
    enabled: enabled ?? this.enabled,
    message: message ?? this.message,
    error: error,
  );
}

class VersionState {
  final bool checking;
  final bool forceUpdate;
  final String version;
  final String minVersion;
  final String changelog;
  final String downloadUrl;
  final String? error;

  const VersionState({
    this.checking = true,
    this.forceUpdate = false,
    this.version = '',
    this.minVersion = '',
    this.changelog = '',
    this.downloadUrl = '',
    this.error,
  });

  VersionState copyWith({
    bool? checking,
    bool? forceUpdate,
    String? version,
    String? minVersion,
    String? changelog,
    String? downloadUrl,
    String? error,
  }) => VersionState(
    checking: checking ?? this.checking,
    forceUpdate: forceUpdate ?? this.forceUpdate,
    version: version ?? this.version,
    minVersion: minVersion ?? this.minVersion,
    changelog: changelog ?? this.changelog,
    downloadUrl: downloadUrl ?? this.downloadUrl,
    error: error,
  );
}

class MaintenanceNotifier extends StateNotifier<MaintenanceState> {
  final ApiClient _api;

  MaintenanceNotifier(this._api) : super(const MaintenanceState()) {
    check();
  }

  Future<void> check() async {
    state = state.copyWith(checking: true);
    try {
      final data = await _api.get('/system/maintenance');
      final map = Map<String, dynamic>.from(data as Map);
      state = MaintenanceState(
        checking: false,
        enabled: map['enabled'] == true,
        message: map['message']?.toString() ?? '',
      );
    } catch (e) {
      state = MaintenanceState(checking: false, error: e.toString());
    }

    // Report session (fire-and-forget)
    _api.post('/system/session', {'platform': 'mobile'}).catchError((_) {});

    // Fetch remote config (fire-and-forget)
    _api.get('/system/config').catchError((_) {});
  }
}

class VersionCheckNotifier extends StateNotifier<VersionState> {
  final ApiClient _api;

  VersionCheckNotifier(this._api) : super(const VersionState()) {
    check();
  }

  Future<void> check() async {
    state = state.copyWith(checking: true);
    try {
      final data = await _api.get('/system/version/mobile');
      final map = Map<String, dynamic>.from(data as Map);
      state = VersionState(
        checking: false,
        forceUpdate: map['forceUpdate'] == true,
        version: map['version']?.toString() ?? '',
        minVersion: map['minVersion']?.toString() ?? '',
        changelog: map['changelog']?.toString() ?? '',
        downloadUrl: map['downloadUrl']?.toString() ?? '',
      );
    } catch (e) {
      state = VersionState(checking: false, error: e.toString());
    }
  }
}

final maintenanceProvider = StateNotifierProvider<MaintenanceNotifier, MaintenanceState>((ref) {
  final api = ref.watch(apiClientProvider);
  return MaintenanceNotifier(api);
});

final versionCheckProvider = StateNotifierProvider<VersionCheckNotifier, VersionState>((ref) {
  final api = ref.watch(apiClientProvider);
  return VersionCheckNotifier(api);
});
