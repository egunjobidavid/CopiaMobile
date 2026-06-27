import '../../../core/network/api_client.dart';

class InventoryRepository {
  final ApiClient _api;

  InventoryRepository(this._api);

  Future<List<Map<String, dynamic>>> getStockBalances({String? productId}) async {
    final params = <String, String>{};
    if (productId != null) params['productId'] = productId;
    final response = await _api.get('/inventory/stock', queryParameters: params);
    final data = response.data;
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data.containsKey('data')) return List<Map<String, dynamic>>.from(data['data']);
    return [];
  }

  Future<List<Map<String, dynamic>>> getStockMovements({
    String? productId,
    int limit = 50,
  }) async {
    final params = <String, String>{'limit': limit.toString()};
    if (productId != null) params['productId'] = productId;
    final response = await _api.get('/inventory/movements', queryParameters: params);
    final data = response.data;
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data.containsKey('data')) return List<Map<String, dynamic>>.from(data['data']);
    return [];
  }

  Future<List<Map<String, dynamic>>> getWarehouses() async {
    final response = await _api.get('/inventory/warehouses');
    final data = response.data;
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data.containsKey('data')) return List<Map<String, dynamic>>.from(data['data']);
    return [];
  }

  Future<Map<String, dynamic>> createGoodsReceipt(Map<String, dynamic> payload) async {
    final response = await _api.post('/procurement/goods-receipts', data: payload);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPurchaseOrder(String id) async {
    final response = await _api.get('/procurement/purchase-orders/$id');
    final data = response.data;
    if (data is Map && data.containsKey('data')) return data['data'] as Map<String, dynamic>;
    return data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> adjustStock(Map<String, dynamic> payload) async {
    final response = await _api.post('/inventory/adjust', data: payload);
    return response.data as Map<String, dynamic>;
  }
}
