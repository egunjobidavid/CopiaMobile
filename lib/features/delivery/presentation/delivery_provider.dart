import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/delivery_repository.dart';
import '../models/delivery.dart';

final deliveryRepositoryProvider = Provider<DeliveryRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return DeliveryRepository(api);
});

final deliveryListProvider = FutureProvider<List<Delivery>>((ref) async {
  final repo = ref.watch(deliveryRepositoryProvider);
  final results = await repo.getDeliveries();
  return results.map((json) => Delivery.fromJson(json)).toList();
});

final deliveryDetailProvider = FutureProvider.family<Delivery?, String>((ref, id) async {
  final repo = ref.watch(deliveryRepositoryProvider);
  final json = await repo.getDelivery(id);
  if (json == null) return null;
  return Delivery.fromJson(json);
});
