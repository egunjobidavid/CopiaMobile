import '../../../core/network/api_client.dart';

class SalesRepository {
  final ApiClient _api;

  SalesRepository(this._api);

  Future<List<Map<String, dynamic>>> getOrders({int page = 1, int limit = 20}) async {
    final response = await _api.get(
      '/sales/orders',
      queryParameters: {'page': page.toString(), 'limit': limit.toString()},
    );
    final data = response.data;
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data.containsKey('data')) return List<Map<String, dynamic>>.from(data['data']);
    return [];
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload) async {
    final response = await _api.post('/sales/orders', data: payload);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> getOrder(String id) async {
    try {
      final response = await _api.get('/sales/orders/$id');
      return response.data as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCustomers({String? search}) async {
    final params = <String, String>{'limit': '20'};
    if (search != null && search.trim().isNotEmpty) params['search'] = search;
    final response = await _api.get('/customers', queryParameters: params);
    final data = response.data;
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data.containsKey('data')) return List<Map<String, dynamic>>.from(data['data']);
    return [];
  }
}
