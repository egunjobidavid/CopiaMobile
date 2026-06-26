import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'delivery_provider.dart';

class DeliveryDetailScreen extends ConsumerWidget {
  final String deliveryId;

  const DeliveryDetailScreen({super.key, required this.deliveryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryAsync = ref.watch(deliveryDetailProvider(deliveryId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Detail'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/deliveries/$deliveryId/confirm'),
            child: const Text('Confirm'),
          ),
        ],
      ),
      body: deliveryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text('Delivery not found', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
        data: (delivery) {
          if (delivery == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('Delivery not found', style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(delivery.deliveryNumber, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
                      const SizedBox(height: 8),
                      _StatusBadge(status: delivery.status),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer Details', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
                      const SizedBox(height: 8),
                      if (delivery.customerName != null) _Row(label: 'Name', value: delivery.customerName!),
                      if (delivery.customerPhone != null) _Row(label: 'Phone', value: delivery.customerPhone!),
                      if (delivery.address != null) _Row(label: 'Address', value: delivery.address!),
                      if (delivery.orderNumber != null) _Row(label: 'Order', value: delivery.orderNumber!),
                    ],
                  ),
                ),
              ),
              if (delivery.driverName != null || delivery.driverPhone != null) ...[
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Driver', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                        const SizedBox(height: 8),
                        if (delivery.driverName != null) _Row(label: 'Name', value: delivery.driverName!),
                        if (delivery.driverPhone != null) _Row(label: 'Phone', value: delivery.driverPhone!),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: delivery.isDelivered ? null : () {
                    Navigator.pushNamed(context, '/deliveries/${delivery.id}/confirm');
                  },
                  icon: const Icon(Icons.check_circle),
                  label: Text(delivery.isDelivered ? 'Delivered' : 'Confirm Delivery'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: delivery.isDelivered ? Colors.grey : Colors.green,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'delivered' => Colors.green,
      'in_transit' => Colors.orange,
      'failed' => Colors.red,
      _ => Colors.grey,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(label, style: TextStyle(color: Colors.grey[600]))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
