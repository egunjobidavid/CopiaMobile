import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'drift_database.dart';
import 'cache_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final cacheServiceProvider = Provider<CacheService>((ref) {
  final db = ref.watch(databaseProvider);
  return CacheService(db);
});

final cachedProductsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final cache = ref.watch(cacheServiceProvider);
  return cache.getCachedProducts();
});

final cachedCustomersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final cache = ref.watch(cacheServiceProvider);
  return cache.getCachedCustomers();
});

final cachedOrdersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final cache = ref.watch(cacheServiceProvider);
  return cache.getCachedOrders();
});
