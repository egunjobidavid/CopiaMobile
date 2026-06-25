import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'delivery_provider.dart';

class DeliveryConfirmScreen extends ConsumerStatefulWidget {
  final String deliveryId;

  const DeliveryConfirmScreen({super.key, required this.deliveryId});

  @override
  ConsumerState<DeliveryConfirmScreen> createState() => _DeliveryConfirmScreenState();
}

class _DeliveryConfirmScreenState extends ConsumerState<DeliveryConfirmScreen> {
  final _notesController = TextEditingController();
  Position? _currentPosition;
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) setState(() => _currentPosition = position);
    } catch (_) {}
  }

  Future<void> _confirmDelivery() async {
    setState(() => _isConfirming = true);
    try {
      final repo = ref.read(deliveryRepositoryProvider);
      await repo.confirmDelivery(widget.deliveryId, {
        'latitude': _currentPosition?.latitude,
        'longitude': _currentPosition?.longitude,
        'notes': _notesController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delivery confirmed')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isConfirming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deliveryAsync = ref.watch(deliveryDetailProvider(widget.deliveryId));

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Delivery')),
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

          if (delivery.isDelivered) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  Text('Already delivered', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Delivery info card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(delivery.deliveryNumber, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
                      const SizedBox(height: 12),
                      if (delivery.customerName != null)
                        _InfoRow(icon: Icons.person, label: 'Customer', value: delivery.customerName!),
                      if (delivery.customerPhone != null)
                        _InfoRow(icon: Icons.phone, label: 'Phone', value: delivery.customerPhone!),
                      if (delivery.address != null)
                        _InfoRow(icon: Icons.location_on, label: 'Address', value: delivery.address!),
                      if (delivery.orderNumber != null)
                        _InfoRow(icon: Icons.receipt, label: 'Order', value: delivery.orderNumber!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Location
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Location', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
                      const SizedBox(height: 8),
                      if (_currentPosition != null)
                        _InfoRow(
                          icon: Icons.gps_fixed,
                          label: 'GPS',
                          value: '${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}',
                        )
                      else
                        Row(
                          children: [
                            const SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 8),
                            Text('Acquiring GPS...', style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Delivery Notes (optional)',
                  hintText: 'Any comments about the delivery...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Confirm button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isConfirming ? null : _confirmDelivery,
                  icon: _isConfirming
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.check_circle),
                  label: Text(_isConfirming ? 'Confirming...' : 'Confirm Delivery'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: Colors.green,
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(color: Colors.grey[600])),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
