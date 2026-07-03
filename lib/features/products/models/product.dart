class Product {
  final String id;
  final String sku;
  final String name;
  final String? description;
  final double unitPrice;
  final String productType;
  final String uom;
  final bool isActive;
  final double stockQuantity;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    this.description,
    required this.unitPrice,
    required this.productType,
    required this.uom,
    this.isActive = true,
    this.stockQuantity = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      productType: json['productType'] as String? ?? 'finished_good',
      uom: json['uom'] as String? ?? 'pcs',
      isActive: json['isActive'] as bool? ?? true,
      stockQuantity: (json['stockQuantity'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sku': sku,
    'name': name,
    'description': description,
    'unitPrice': unitPrice,
    'productType': productType,
    'uom': uom,
    'isActive': isActive,
    'stockQuantity': stockQuantity,
  };

  String get formattedPrice => '₦${unitPrice.toStringAsFixed(2)}';
  String get productTypeLabel => productType.replaceAll('_', ' ');
}
