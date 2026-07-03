import '../../../core/network/api_client.dart';

class SalesRepository {
  final ApiClient _api;

  SalesRepository(this._api);

  Future<List<Map<String, dynamic>>> getOrders({int page = 1, int limit = 20}) async {
    final response = await _api.get(
      '/sales/orders',
      queryParameters: {'page': page.toString(), 'limit': limit.toString()},
    );
    return extractList(response.data);
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload) async {
    final response = await _api.post('/sales/orders', data: payload);
    return extractOne(response.data) ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>?> getOrder(String id) async {
    try {
      final response = await _api.get('/sales/orders/$id');
      return extractOne(response.data);
    } catch (_) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCustomers({String? search}) async {
    final params = <String, String>{'limit': '20'};
    if (search != null && search.trim().isNotEmpty) params['search'] = search;
    final response = await _api.get('/customers', queryParameters: params);
    return extractList(response.data);
  }
}
