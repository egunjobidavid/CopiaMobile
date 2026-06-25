import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/inventory_repository.dart';
import '../models/stock_balance.dart';
import '../models/stock_movement.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final api = ApiClient(storage);
  return InventoryRepository(api);
});

final stockBalancesProvider = FutureProvider<List<StockBalance>>((ref) async {
  final repo = ref.watch(inventoryRepositoryProvider);
  final results = await repo.getStockBalances();
  return results.map((json) => StockBalance.fromJson(json)).toList();
});

final stockMovementsProvider = FutureProvider<List<StockMovement>>((ref) async {
  final repo = ref.watch(inventoryRepositoryProvider);
  final results = await repo.getStockMovements();
  return results.map((json) => StockMovement.fromJson(json)).toList();
});

final productStockBalancesProvider = FutureProvider.family<List<StockBalance>, String>((ref, productId) async {
  final repo = ref.watch(inventoryRepositoryProvider);
  final results = await repo.getStockBalances(productId: productId);
  return results.map((json) => StockBalance.fromJson(json)).toList();
});

final productStockMovementsProvider = FutureProvider.family<List<StockMovement>, String>((ref, productId) async {
  final repo = ref.watch(inventoryRepositoryProvider);
  final results = await repo.getStockMovements(productId: productId);
  return results.map((json) => StockMovement.fromJson(json)).toList();
});
