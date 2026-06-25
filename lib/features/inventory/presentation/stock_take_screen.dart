import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/barcode_scanner.dart';
import '../data/inventory_repository.dart';
import 'inventory_provider.dart';
import '../models/stock_balance.dart';

class StockTakeScreen extends ConsumerStatefulWidget {
  const StockTakeScreen({super.key});

  @override
  ConsumerState<StockTakeScreen> createState() => _StockTakeScreenState();
}

class _StockTakeScreenState extends ConsumerState<StockTakeScreen> {
  final _items = <StockTakeItem>[];
  bool _isSubmitting = false;

  void _addItem(String barcode) {
    setState(() => _items.add(StockTakeItem(sku: barcode)));
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(inventoryRepositoryProvider);
      await repo.adjustStock({
        'items': _items.map((i) => {
          'sku': i.sku,
          'expectedQty': i.expectedQty,
          'actualQty': i.actualQty,
          'warehouseId': i.warehouseId,
        }).toList(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stock take submitted')),
        );
        setState(() => _items.clear());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Take'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () async {
              final barcode = await Navigator.pushNamed(context, '/products/scan');
              if (barcode != null) _addItem(barcode as String);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_items.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_scanner, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text('Scan products to start count', style: TextStyle(color: Colors.grey[500])),
                    const SizedBox(height: 16),
                    FilledButton.tonalIcon(
                      onPressed: () async {
                        final barcode = await Navigator.pushNamed(context, '/products/scan');
                        if (barcode != null) _addItem(barcode as String);
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Scan First Item'),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: _items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text('SKU: ${item.sku}', style: const TextStyle(fontWeight: FontWeight.w600))),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => _removeItem(index),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Expected Qty',
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(text: item.expectedQty.toString()),
                                  onChanged: (v) => item.expectedQty = double.tryParse(v) ?? 0,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Actual Qty',
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(text: item.actualQty.toString()),
                                  onChanged: (v) => item.actualQty = double.tryParse(v) ?? 0,
                                ),
                              ),
                            ],
                          ),
                          if (item.expectedQty > 0 && item.actualQty != item.expectedQty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Difference: ${(item.actualQty - item.expectedQty).toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          if (_items.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isSubmitting ? null : _submit,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.check),
                    label: Text(_isSubmitting ? 'Submitting...' : 'Submit Count (${_items.length} items)'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class StockTakeItem {
  String sku;
  double expectedQty;
  double actualQty;
  String warehouseId;

  StockTakeItem({
    this.sku = '',
    this.expectedQty = 0,
    this.actualQty = 0,
    this.warehouseId = '',
  });
}
