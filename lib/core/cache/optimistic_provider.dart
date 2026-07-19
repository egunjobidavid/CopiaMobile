import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'swr_provider.dart';
import 'drift_database.dart';
import '../network/api_client.dart';

/// Optimistic operation result.
class OptimisticResult {
  final bool success;
  final Object? error;

  const OptimisticResult({required this.success, this.error});
}

/// Mixin that adds optimistic operations to any SWRNotifier.
///
/// Usage:
///   class MyProducts extends SWRNotifier<Map<String, dynamic>>
///       with OptimisticMixin<Map<String, dynamic>> {
///     // ...existing code...
///   }
///
///   final notifier = ref.read(swrProductsProvider.notifier);
///   await notifier.optimisticInsert({...newItem...}, () => api.post(...));
///   await notifier.optimisticUpdate(id, {...updates...}, () => api.patch(...));
///   await notifier.optimisticDelete(id, () => api.delete(...));
mixin OptimisticMixin<T> on SWRNotifier<T> {
  String _getKey(T item);

  /// Insert: add item to local list, then confirm with server.
  /// Rolls back on failure.
  Future<OptimisticResult> optimisticInsert(
    T item,
    Future<void> Function() serverCall,
  ) async {
    final snapshot = List<T>.from(state.data);
    final key = _getKey(item);

    // Check for duplicate
    final exists = state.data.any((i) => _getKey(i) == key);
    if (exists) {
      return const OptimisticResult(success: false, error: 'Duplicate item');
    }

    // Optimistic update
    state = state.copyWith(data: [item, ...state.data]);

    try {
      await serverCall();
      return const OptimisticResult(success: true);
    } catch (e) {
      // Rollback
      state = state.copyWith(data: snapshot);
      return OptimisticResult(success: false, error: e);
    }
  }

  /// Update: replace item fields in local list, then confirm with server.
  /// Rolls back on failure.
  Future<OptimisticResult> optimisticUpdate(
    String id,
    T item,
    Future<void> Function() serverCall,
  ) async {
    final snapshot = List<T>.from(state.data);

    state = state.copyWith(
      data: state.data.map((i) => _getKey(i) == id ? item : i).toList(),
    );

    try {
      await serverCall();
      return const OptimisticResult(success: true);
    } catch (e) {
      state = state.copyWith(data: snapshot);
      return OptimisticResult(success: false, error: e);
    }
  }

  /// Delete: remove item from local list, then confirm with server.
  /// Rolls back on failure.
  Future<OptimisticResult> optimisticDelete(
    String id,
    Future<void> Function() serverCall,
  ) async {
    final snapshot = List<T>.from(state.data);

    state = state.copyWith(
      data: state.data.where((i) => _getKey(i) != id).toList(),
    );

    try {
      await serverCall();
      return const OptimisticResult(success: true);
    } catch (e) {
      state = state.copyWith(data: snapshot);
      return OptimisticResult(success: false, error: e);
    }
  }

  /// Status transition: update status field instantly, confirm via PATCH.
  Future<OptimisticResult> optimisticStatusTransition(
    String id,
    String newStatus,
    Future<void> Function() serverCall,
  ) async {
    final snapshot = List<T>.from(state.data);

    state = state.copyWith(
      data: state.data.map((i) {
        if (_getKey(i) != id) return i;
        final map = i as Map<String, dynamic>;
        return Map<String, dynamic>.from(map)..['status'] = newStatus;
      }).toList() as List<T>,
    );

    try {
      await serverCall();
      return const OptimisticResult(success: true);
    } catch (e) {
      state = state.copyWith(data: snapshot);
      return OptimisticResult(success: false, error: e);
    }
  }
}

/// Concrete products notifier with optimistic mixin.
class OptimisticProductsNotifier extends SWRNotifier<Map<String, dynamic>>
    with OptimisticMixin<Map<String, dynamic>> {
  OptimisticProductsNotifier(ApiClient api) : super(api);

  @override
  String _getKey(Map<String, dynamic> item) => item['id'] as String;

  @override
  String get endpoint => '/inventory/products?limit=200';

  @override
  Map<String, dynamic> parseItem(Map<String, dynamic> json) => json;

  @override
  Future<List<Map<String, dynamic>>> readFromCache() async {
    // Read from Drift cache (same as SWRProductsNotifier)
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

/// Provider for optimistic products.
final optimisticProductsProvider =
    StateNotifierProvider<OptimisticProductsNotifier, SWRState<Map<String, dynamic>>>((ref) {
  return OptimisticProductsNotifier(ref.watch(apiClientProvider));
});
