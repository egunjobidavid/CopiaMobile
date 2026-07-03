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
    final data = response.data;
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data.containsKey('data')) {
      final inner = data['data'];
      if (inner is List) return inner.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<Map<String, dynamic>?> getProduct(String id) async {
    try {
      final response = await _api.get('/inventory/products/$id');
      final data = response.data;
      if (data is Map && data.containsKey('data')) return data['data'] as Map<String, dynamic>;
      return data as Map<String, dynamic>;
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
      final data = response.data;
      List<dynamic> items;
      if (data is List) {
        items = data;
      } else if (data is Map && data.containsKey('data')) {
        items = data['data'] as List? ?? [];
      } else {
        return null;
      }
      if (items.isNotEmpty) return items[0] as Map<String, dynamic>;
      return null;
    } catch (_) {
      return null;
    }
  }
}
