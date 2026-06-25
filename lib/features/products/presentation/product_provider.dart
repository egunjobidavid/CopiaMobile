import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/product_repository.dart';
import '../models/product.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final api = ApiClient(storage);
  return ProductRepository(api);
});

final productSearchProvider = FutureProvider.family<List<Product>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  final repo = ref.watch(productRepositoryProvider);
  final results = await repo.searchProducts(query);
  return results.map((json) => Product.fromJson(json)).toList();
});

final productDetailProvider = FutureProvider.family<Product?, String>((ref, id) async {
  final repo = ref.watch(productRepositoryProvider);
  final json = await repo.getProduct(id);
  if (json == null) return null;
  return Product.fromJson(json);
});
