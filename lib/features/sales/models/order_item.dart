class OrderItem {
  String? id;
  final String productId;
  final String productName;
  final String sku;
  final double quantity;
  final double unitPrice;
  double get totalPrice => quantity * unitPrice;

  OrderItem({
    this.id,
    required this.productId,
    required this.productName,
    required this.sku,
    this.quantity = 1,
    required this.unitPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String?,
      productId: json['productId'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      quantity: double.tryParse(json['quantity']?.toString() ?? '') ?? 1,
      unitPrice: double.tryParse(json['unitPrice']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'productId': productId,
    'productName': productName,
    'sku': sku,
    'quantity': quantity,
    'unitPrice': unitPrice,
  };

  OrderItem copyWith({double? quantity}) => OrderItem(
    id: id,
    productId: productId,
    productName: productName,
    sku: sku,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice,
  );
}
