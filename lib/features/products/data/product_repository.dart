import '../../../core/network/api_client.dart';

class ProductRepository {
  final ApiClient _api;

  ProductRepository(this._api);

  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    if (query.trim().isEmpty) return [];
    final response = await _api.get(
      '/inventory/products',
      queryParameters: {'search': query, 'limit': '20'},
    );
    return extractList(response.data);
  }

  Future<Map<String, dynamic>?> getProduct(String id) async {
    try {
      final response = await _api.get(
        '/inventory/products',
        queryParameters: {'limit': '200'},
      );
      final items = extractList(response.data);
      for (final item in items) {
        if (item['id'] == id) return item;
      }
      return null;
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
}
