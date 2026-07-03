import '../../../core/network/api_client.dart';

class InventoryRepository {
  final ApiClient _api;

  InventoryRepository(this._api);

  Future<List<Map<String, dynamic>>> getStockBalances({String? productId}) async {
    final params = <String, String>{};
    if (productId != null) params['productId'] = productId;
    final response = await _api.get('/inventory/stock', queryParameters: params);
    return extractList(response.data);
  }

  Future<List<Map<String, dynamic>>> getStockMovements({
    String? productId,
    int limit = 50,
  }) async {
    final params = <String, String>{'limit': limit.toString()};
    if (productId != null) params['productId'] = productId;
    final response = await _api.get('/inventory/movements', queryParameters: params);
    return extractList(response.data);
  }

  Future<List<Map<String, dynamic>>> getWarehouses() async {
    final response = await _api.get('/inventory/warehouses');
    return extractList(response.data);
  }

  Future<Map<String, dynamic>> createGoodsReceipt(Map<String, dynamic> payload) async {
    final response = await _api.post('/procurement/goods-receipts', data: payload);
    return extractOne(response.data) ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> getPurchaseOrder(String id) async {
    final response = await _api.get('/procurement/purchase-orders/$id');
    return extractOne(response.data) ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> adjustStock(Map<String, dynamic> payload) async {
    final response = await _api.post('/inventory/adjust', data: payload);
    return extractOne(response.data) ?? <String, dynamic>{};
  }
}
