import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/inventory_repository.dart';
import '../models/stock_balance.dart';
import '../models/stock_movement.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return InventoryRepository(api);
});

final stockBalancesProvider = FutureProvider<List<StockBalance>>((ref) async {
  try {
    final repo = ref.watch(inventoryRepositoryProvider);
    final results = await repo.getStockBalances();
    return results.map((json) => StockBalance.fromJson(json)).toList();
  } catch (e) {
    return [];
  }
});

final stockMovementsProvider = FutureProvider<List<StockMovement>>((ref) async {
  try {
    final repo = ref.watch(inventoryRepositoryProvider);
    final results = await repo.getStockMovements();
    return results.map((json) => StockMovement.fromJson(json)).toList();
  } catch (e) {
    return [];
  }
});

final productStockBalancesProvider = FutureProvider.family<List<StockBalance>, String>((ref, productId) async {
  try {
    final repo = ref.watch(inventoryRepositoryProvider);
    final results = await repo.getStockBalances(productId: productId);
    return results.map((json) => StockBalance.fromJson(json)).toList();
  } catch (e) {
    return [];
  }
});

final productStockMovementsProvider = FutureProvider.family<List<StockMovement>, String>((ref, productId) async {
  try {
    final repo = ref.watch(inventoryRepositoryProvider);
    final results = await repo.getStockMovements(productId: productId);
    return results.map((json) => StockMovement.fromJson(json)).toList();
  } catch (e) {
    return [];
  }
});

final purchaseOrderProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
  final repo = ref.watch(inventoryRepositoryProvider);
  return repo.getPurchaseOrder(id);
});

final warehousesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final repo = ref.watch(inventoryRepositoryProvider);
    return repo.getWarehouses();
  } catch (e) {
    return [];
  }
});
