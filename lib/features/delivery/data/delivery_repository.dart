import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';

class DeliveryRepository {
  final ApiClient _api;

  DeliveryRepository(this._api);

  Future<List<Map<String, dynamic>>> getDeliveries({String? status}) async {
    final params = <String, String>{};
    if (status != null) params['status'] = status;
    final response = await _api.get('/deliveries', queryParameters: params);
    final data = response.data;
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data.containsKey('data')) return List<Map<String, dynamic>>.from(data['data']);
    return [];
  }

  Future<Map<String, dynamic>?> getDelivery(String id) async {
    try {
      final response = await _api.get('/deliveries/$id');
      return response.data as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> confirmDelivery(String id, Map<String, dynamic> payload) async {
    final response = await _api.post('/deliveries/$id/confirm', data: payload);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> recordProofOfDelivery(String id, String imagePath) async {
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(imagePath),
    });
    final response = await _api.post('/deliveries/$id/pod', data: formData);
    return response.data as Map<String, dynamic>;
  }
}
