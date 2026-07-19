import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../cache/drift_database.dart';
import '../network/api_client.dart';

/// Generic SWR state for an entity list.
class SWRState<T> {
  final List<T> data;
  final bool isStale;
  final bool isValidating;
  final Object? error;

  const SWRState({
    this.data = const [],
    this.isStale = true,
    this.isValidating = false,
    this.error,
  });

  SWRState<T> copyWith({
    List<T>? data,
    bool? isStale,
    bool? isValidating,
    Object? error,
  }) {
    return SWRState<T>(
      data: data ?? this.data,
      isStale: isStale ?? this.isStale,
      isValidating: isValidating ?? this.isValidating,
      error: error,
    );
  }
}

/// Generic SWR notifier. Subclass it for each entity type.
abstract class SWRNotifier<T> extends StateNotifier<SWRState<T>> {
  final ApiClient _api;

  SWRNotifier(this._api) : super(const SWRState()) {
    _init();
  }

  Future<void> _init() async {
    final cached = await readFromCache();
    if (cached.isNotEmpty && mounted) {
      state = state.copyWith(data: cached, isStale: true);
    }
    await revalidate();
  }

  Future<List<T>> readFromCache();
  Future<void> writeToCache(List<T> items);
  T parseItem(Map<String, dynamic> json);
  String get endpoint;

  Future<void> revalidate() async {
    if (!mounted) return;
    state = state.copyWith(isValidating: true, error: null);
    try {
      final response = await _api.get(endpoint);
      final rawList = extractList(response.data);
      final items = rawList.map(parseItem).toList();
      if (!mounted) return;
      state = state.copyWith(data: items, isStale: false, isValidating: false);
      writeToCache(items).catchError((_) {});
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isValidating: false, error: e);
    }
  }

  void mutate() {
    state = state.copyWith(isStale: true);
    revalidate();
  }
}

/// Products SWR provider.
final swrProductsProvider =
    StateNotifierProvider<SWRProductsNotifier, SWRState<Map<String, dynamic>>>((ref) {
  return SWRProductsNotifier(ref.watch(apiClientProvider));
});

class SWRProductsNotifier extends SWRNotifier<Map<String, dynamic>> {
  SWRProductsNotifier(ApiClient api) : super(api);

  @override
  String get endpoint => '/inventory/products?limit=200';

  @override
  Map<String, dynamic> parseItem(Map<String, dynamic> json) => json;

  @override
  Future<List<Map<String, dynamic>>> readFromCache() async {
    try {
      final db = AppDatabase();
      final rows = await db.select(db.cachedProducts).get();
      return rows
          .map((r) => {
                'id': r.id,
                'sku': r.sku,
                'name': r.name,
                'description': r.description ?? '',
                'unitPrice': r.unitPrice,
                'productType': r.productType,
                'uom': r.uom,
                'isActive': r.isActive,
                'stockQuantity': r.stockQuantity,
              })
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> writeToCache(List<Map<String, dynamic>> items) async {
    try {
      final db = AppDatabase();
      await db.batch((batch) {
        batch.deleteWhere(db.cachedProducts, (_) => const Constant(true));
        batch.insertAll(
          db.cachedProducts,
          items.map((m) => CachedProductsCompanion.insert(
                id: m['id'] as String,
                sku: m['sku'] as String,
                name: m['name'] as String,
                description: Value(m['description'] as String?),
                unitPrice: (m['unitPrice'] as num?)?.toDouble() ?? 0,
                productType: m['productType'] as String? ?? 'finished_good',
                uom: m['uom'] as String? ?? 'pcs',
                isActive: Value(m['isActive'] as bool? ?? true),
                stockQuantity: Value((m['stockQuantity'] as num?)?.toDouble() ?? 0),
                jsonData: '',
                syncedAt: DateTime.now(),
              )),
        );
      });
    } catch (_) {}
  }
}
