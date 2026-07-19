import '../../../core/network/api_client.dart';
import '../../../core/network/request_cache.dart';

class ProductRepository {
  final ApiClient _api;

  ProductRepository(this._api);

  void _invalidateCache() {
    RequestCache.instance.invalidate('/inventory/products');
  }

  Future<List<Map<String, dynamic>>> listProducts() async {
    final response = await _api.get(
      '/inventory/products',
      queryParameters: {'limit': '200'},
    );
    return extractList(response.data);
  }

  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    if (query.trim().isEmpty) return listProducts();
    final response = await _api.get(
      '/inventory/products',
      queryParameters: {'search': query, 'limit': '20'},
    );
    return extractList(response.data);
  }

  Future<Map<String, dynamic>?> getProduct(String id) async {
    try {
      final response = await _api.get('/inventory/products/$id');
      return extractOne(response.data);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getProductBySku(String sku) async {
    try {
      final response = await _api.get(
        '/inventory/products',
        queryParameters: {'search': sku, 'limit': '1'},
      );
      final items = extractList(response.data);
      if (items.isNotEmpty) return items.first;
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> createProduct(Map<String, dynamic> body) async {
    final response = await _api.post('/inventory/products', data: body);
    _invalidateCache();
    return extractOne(response.data);
  }

  Future<Map<String, dynamic>?> updateProduct(String id, Map<String, dynamic> body) async {
    final response = await _api.patch('/inventory/products/$id', data: body);
    _invalidateCache();
    return extractOne(response.data);
  }

  Future<void> deleteProduct(String id) async {
    await _api.delete('/inventory/products/$id');
    _invalidateCache();
  }
}
