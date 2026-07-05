import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

import '../data/product_repository.dart';
import '../models/product.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return ProductRepository(api);
});

final productsListProvider = FutureProvider<List<Product>>((ref) async {
  try {
    final repo = ref.watch(productRepositoryProvider);
    final items = await repo.listProducts();
    return items.map((json) => Product.fromJson(json)).toList();
  } catch (e) {
    return [];
  }
});

final productSearchProvider = FutureProvider.family<List<Product>, String>((ref, query) async {
  if (query.trim().isEmpty) {
    return ref.watch(productsListProvider.future);
  }
  try {
    final repo = ref.watch(productRepositoryProvider);
    final results = await repo.searchProducts(query);
    return results.map((json) => Product.fromJson(json)).toList();
  } catch (e) {
    return [];
  }
});

final productDetailProvider = FutureProvider.family<Product?, String>((ref, id) async {
  try {
    final repo = ref.watch(productRepositoryProvider);
    final json = await repo.getProduct(id);
    if (json == null) return null;
    return Product.fromJson(json);
  } catch (e) {
    return null;
  }
});
