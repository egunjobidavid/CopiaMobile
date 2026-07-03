import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';

class DeliveryRepository {
  final ApiClient _api;

  DeliveryRepository(this._api);

  Future<List<Map<String, dynamic>>> getDeliveries({String? status}) async {
    final params = <String, String>{};
    if (status != null) params['status'] = status;
    final response = await _api.get('/deliveries', queryParameters: params);
    return extractList(response.data);
  }

  Future<Map<String, dynamic>?> getDelivery(String id) async {
    try {
      final response = await _api.get('/deliveries/$id');
      return extractOne(response.data);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> confirmDelivery(String id, Map<String, dynamic> payload) async {
    final response = await _api.post('/deliveries/$id/confirm', data: payload);
    return extractOne(response.data) ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> recordProofOfDelivery(String id, String imagePath) async {
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(imagePath),
    });
    final response = await _api.post('/deliveries/$id/pod', data: formData);
    return extractOne(response.data) ?? <String, dynamic>{};
  }
}
