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
  bool _poLoaded = false;

  void _loadPOItems(List<dynamic> poItems) {
    _items.clear();
    for (final item in poItems) {
      final name = item['productName'] ?? item['name'] ?? '';
      final sku = item['sku'] ?? item['productSku'] ?? '';
      final ordered = (item['quantity'] ?? item['orderedQuantity'] ?? 0).toDouble();
      _items.add(GoodsReceiptItem(
        sku: sku.toString(),
        productName: name.toString(),
        quantity: ordered,
        orderedQuantity: ordered,
      ));
    }
    _poLoaded = true;
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
          'orderedQuantity': i.orderedQuantity,
          'receivedQuantity': i.quantity,
          'warehouseId': i.warehouseId,
          'notes': i.notes,
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
    final poAsync = widget.purchaseOrderId != null
        ? ref.watch(purchaseOrderProvider(widget.purchaseOrderId!))
        : null;

    if (poAsync != null && !_poLoaded) {
      poAsync.whenData((po) {
        final items = po['items'] as List<dynamic>? ?? [];
        if (items.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _loadPOItems(items));
          });
        } else {
          _poLoaded = true;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.purchaseOrderId != null ? 'Receive PO' : 'Goods Receipt'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            if (widget.purchaseOrderId != null)
              poAsync?.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Container(
                  width: double.infinity,
                  color: Colors.red.shade50,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Failed to load PO: $e',
                    style: TextStyle(color: Colors.red.shade700)),
                ),
                data: (po) => Container(
                  width: double.infinity,
                  color: Colors.blue.shade50,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Receiving for PO: ${po['poNumber'] ?? widget.purchaseOrderId}',
                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue.shade800),
                  ),
                ),
              ) ?? const SizedBox.shrink(),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.orderedQuantity > 0)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  'Ordered: ${item.orderedQuantity.toStringAsFixed(0)}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ),
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
                                      labelText: 'Received Qty',
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
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Notes (optional)',
                                isDense: true,
                              ),
                              initialValue: item.notes,
                              onChanged: (v) => item.notes = v,
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
  double orderedQuantity;
  String warehouseId;
  String notes;

  GoodsReceiptItem({
    this.sku = '',
    this.productName = '',
    this.quantity = 1,
    this.orderedQuantity = 0,
    this.warehouseId = '',
    this.notes = '',
  });
}
