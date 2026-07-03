import 'order_item.dart';

class SalesOrder {
  final String id;
  final String orderNumber;
  final String? customerId;
  final String? customerName;
  final String status;
  final double subtotal;
  final double tax;
  final double total;
  final List<OrderItem> items;
  final String createdAt;

  SalesOrder({
    required this.id,
    required this.orderNumber,
    this.customerId,
    this.customerName,
    this.status = 'draft',
    this.subtotal = 0,
    this.tax = 0,
    this.total = 0,
    this.items = const [],
    this.createdAt = '',
  });

  factory SalesOrder.fromJson(Map<String, dynamic> json) {
    return SalesOrder(
      id: json['id'] as String? ?? '',
      orderNumber: json['orderNumber'] as String? ?? json['reference'] as String? ?? '',
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      status: json['status'] as String? ?? 'draft',
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '') ?? 0,
      tax: double.tryParse(json['tax']?.toString() ?? '') ?? 0,
      total: double.tryParse(json['total']?.toString() ?? '') ?? 0,
      items: (json['items'] as List?)?.map((i) => OrderItem.fromJson(i as Map<String, dynamic>)).toList() ?? [],
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  String get statusLabel => status.replaceAll('_', ' ');
  bool get isDraft => status == 'draft';
  bool get isConfirmed => status == 'confirmed';
  bool get isInvoiced => status == 'invoiced';
  String get formattedTotal => '₦${total.toStringAsFixed(2)}';
}
