import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

import '../data/sales_repository.dart';
import '../models/sales_order.dart';
import '../models/order_item.dart';

final salesRepositoryProvider = Provider<SalesRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return SalesRepository(api);
});

final orderListProvider = FutureProvider<List<SalesOrder>>((ref) async {
  try {
    final repo = ref.watch(salesRepositoryProvider);
    final results = await repo.getOrders();
    return results.map((json) => SalesOrder.fromJson(json)).toList();
  } catch (e) {
    return [];
  }
});

final orderDetailProvider = FutureProvider.family<SalesOrder?, String>((ref, orderId) async {
  try {
    final repo = ref.watch(salesRepositoryProvider);
    final data = await repo.getOrder(orderId);
    if (data == null) return null;
    return SalesOrder.fromJson(data);
  } catch (e) {
    return null;
  }
});

class CartNotifier extends StateNotifier<List<OrderItem>> {
  CartNotifier() : super([]);

  void addItem(OrderItem item) {
    final index = state.indexWhere((i) => i.productId == item.productId);
    if (index >= 0) {
      final existing = state[index];
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index) existing.copyWith(quantity: existing.quantity + item.quantity) else state[i],
      ];
    } else {
      state = [...state, item];
    }
  }

  void updateQuantity(String productId, double quantity) {
    state = [
      for (final item in state)
        if (item.productId == productId) item.copyWith(quantity: quantity.clamp(0.5, 9999)) else item,
    ];
  }

  void removeItem(String productId) {
    state = state.where((i) => i.productId != productId).toList();
  }

  void clear() => state = [];

  double get subtotal => state.fold(0, (sum, item) => sum + item.totalPrice);
  int get itemCount => state.length;
}

final cartProvider = StateNotifierProvider<CartNotifier, List<OrderItem>>((ref) => CartNotifier());
final cartSubtotalProvider = Provider<double>((ref) => ref.watch(cartProvider).fold(0, (s, i) => s + i.totalPrice));
final cartCountProvider = Provider<int>((ref) => ref.watch(cartProvider).length);

final customerSearchProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  try {
    final repo = ref.watch(salesRepositoryProvider);
    return await repo.getCustomers(search: query);
  } catch (e) {
    return [];
  }
});
