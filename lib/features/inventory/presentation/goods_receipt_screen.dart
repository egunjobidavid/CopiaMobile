import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'inventory_provider.dart';

class GoodsReceiptScreen extends ConsumerStatefulWidget {
  final String? purchaseOrderId;

  const GoodsReceiptScreen({super.key, this.purchaseOrderId});

  @override
  ConsumerState<GoodsReceiptScreen> createState() => _GoodsReceiptScreenState();
}

class _GoodsReceiptScreenState extends ConsumerState<GoodsReceiptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _items = <GoodsReceiptItem>[];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.purchaseOrderId != null) {
      // Load PO items for receiving
    }
  }

  void _addItem() {
    setState(() => _items.add(GoodsReceiptItem()));
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  Future<void> _scanBarcode(int index) async {
    final barcode = await Navigator.pushNamed(context, '/products/scan');
    if (barcode != null) {
      setState(() => _items[index].sku = barcode as String);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(inventoryRepositoryProvider);
      await repo.createGoodsReceipt({
        'purchaseOrderId': widget.purchaseOrderId,
        'items': _items.map((i) => {
          'sku': i.sku,
          'productName': i.productName,
          'quantity': i.quantity,
          'warehouseId': i.warehouseId,
        }).toList(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Goods receipt created')),
        );
        Navigator.pop(context);
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
        title: Text(widget.purchaseOrderId != null ? 'Receive PO' : 'Goods Receipt'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            if (widget.purchaseOrderId != null)
              Container(
                width: double.infinity,
                color: Colors.blue.shade50,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Receiving for PO: ${widget.purchaseOrderId}',
                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue.shade800)),
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'PO Reference (optional)',
                      hintText: 'PO-001',
                    ),
                    initialValue: widget.purchaseOrderId,
                    readOnly: widget.purchaseOrderId != null,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Items', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
                      FilledButton.tonalIcon(
                        onPressed: _addItem,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Item'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (_items.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.inventory_2, size: 48, color: Colors.grey[300]),
                          const SizedBox(height: 8),
                          Text('No items yet', style: TextStyle(color: Colors.grey[500])),
                          const SizedBox(height: 16),
                          FilledButton.tonal(
                            onPressed: _addItem,
                            child: const Text('Add First Item'),
                          ),
                        ],
                      ),
                    ),

                  ..._items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'SKU / Barcode',
                                      isDense: true,
                                    ),
                                    initialValue: item.sku,
                                    onChanged: (v) => item.sku = v,
                                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.qr_code_scanner),
                                  onPressed: () => _scanBarcode(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => _removeItem(index),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Product Name',
                                isDense: true,
                              ),
                              initialValue: item.productName,
                              onChanged: (v) => item.productName = v,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Quantity',
                                      isDense: true,
                                    ),
                                    initialValue: item.quantity.toString(),
                                    keyboardType: TextInputType.number,
                                    onChanged: (v) => item.quantity = double.tryParse(v) ?? 0,
                                    validator: (v) {
                                      final qty = double.tryParse(v ?? '');
                                      if (qty == null || qty <= 0) return '> 0';
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Warehouse ID',
                                      isDense: true,
                                    ),
                                    initialValue: item.warehouseId,
                                    onChanged: (v) => item.warehouseId = v,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            if (_items.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
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
                      label: Text(_isSubmitting ? 'Submitting...' : 'Submit Receipt'),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class GoodsReceiptItem {
  String sku;
  String productName;
  double quantity;
  String warehouseId;

  GoodsReceiptItem({
    this.sku = '',
    this.productName = '',
    this.quantity = 1,
    this.warehouseId = '',
  });
}
