import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'drift_database.dart';
import 'cache_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  try {
    final db = AppDatabase();
    ref.onDispose(() => db.close());
    return db;
  } catch (_) {
    rethrow;
  }
});

final cacheServiceProvider = Provider<CacheService?>((ref) {
  try {
    final db = ref.watch(databaseProvider);
    return CacheService(db);
  } catch (_) {
    return null;
  }
});

final cachedProductsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final cache = ref.watch(cacheServiceProvider);
  if (cache == null) return [];
  return cache.getCachedProducts();
});

final cachedCustomersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final cache = ref.watch(cacheServiceProvider);
  if (cache == null) return [];
  return cache.getCachedCustomers();
});

final cachedOrdersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final cache = ref.watch(cacheServiceProvider);
  if (cache == null) return [];
  return cache.getCachedOrders();
});
