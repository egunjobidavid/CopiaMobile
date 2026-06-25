import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'delivery_provider.dart';
import 'delivery_confirm_screen.dart';

class DeliveryListScreen extends ConsumerWidget {
  const DeliveryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveriesAsync = ref.watch(deliveryListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Deliveries')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(deliveryListProvider.future),
        child: deliveriesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_shipping, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('No deliveries', style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          ),
          data: (deliveries) {
            if (deliveries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_shipping, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text('No deliveries found', style: TextStyle(color: Colors.grey[500])),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: deliveries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final d = deliveries[index];
                return Card(
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeliveryConfirmScreen(deliveryId: d.id),
                      ),
                    ),
                    leading: Icon(
                      d.isDelivered ? Icons.check_circle : (d.isInTransit ? Icons.local_shipping : Icons.pending),
                      color: d.isDelivered
                          ? Colors.green
                          : (d.isInTransit ? Colors.orange : Colors.grey),
                    ),
                    title: Text(d.deliveryNumber),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (d.customerName != null) Text(d.customerName!),
                        if (d.address != null) Text(d.address!, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(d.statusLabel, style: const TextStyle(fontSize: 11)),
                      visualDensity: VisualDensity.compact,
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
