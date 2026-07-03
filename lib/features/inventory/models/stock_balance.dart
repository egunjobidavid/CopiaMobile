class StockBalance {
  final String id;
  final String productId;
  final String productName;
  final String sku;
  final String warehouseId;
  final String warehouseName;
  final double quantity;
  final double reservedQuantity;
  final double availableQuantity;

  StockBalance({
    required this.id,
    required this.productId,
    required this.productName,
    required this.sku,
    required this.warehouseId,
    required this.warehouseName,
    this.quantity = 0,
    this.reservedQuantity = 0,
    this.availableQuantity = 0,
  });

  factory StockBalance.fromJson(Map<String, dynamic> json) {
    return StockBalance(
      id: json['id'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      productName: json['productName'] as String? ?? json['name'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      warehouseId: json['warehouseId'] as String? ?? '',
      warehouseName: json['warehouseName'] as String? ?? json['warehouse'] as String? ?? 'Main Warehouse',
      quantity: double.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      reservedQuantity: double.tryParse(json['reservedQuantity']?.toString() ?? '') ?? 0,
      availableQuantity: double.tryParse(json['availableQuantity']?.toString() ?? '') ??
          (double.tryParse(json['quantity']?.toString() ?? '') ?? 0) - (double.tryParse(json['reservedQuantity']?.toString() ?? '') ?? 0),
    );
  }

  bool get isLowStock => availableQuantity <= 5;
  bool get isOutOfStock => availableQuantity <= 0;
  String get statusLabel => isOutOfStock ? 'Out of Stock' : (isLowStock ? 'Low Stock' : 'In Stock');
}
