class Delivery {
  final String id;
  final String deliveryNumber;
  final String? orderId;
  final String? orderNumber;
  final String? customerName;
  final String? customerPhone;
  final String? address;
  final String status;
  final String? driverName;
  final String? driverPhone;
  final double? latitude;
  final double? longitude;
  final String? signatureUrl;
  final String? photoUrl;
  final String? notes;
  final String createdAt;

  Delivery({
    required this.id,
    required this.deliveryNumber,
    this.orderId,
    this.orderNumber,
    this.customerName,
    this.customerPhone,
    this.address,
    this.status = 'pending',
    this.driverName,
    this.driverPhone,
    this.latitude,
    this.longitude,
    this.signatureUrl,
    this.photoUrl,
    this.notes,
    this.createdAt = '',
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'] as String,
      deliveryNumber: json['deliveryNumber'] as String? ?? json['reference'] as String? ?? '',
      orderId: json['orderId'] as String?,
      orderNumber: json['orderNumber'] as String?,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      address: json['address'] as String?,
      status: json['status'] as String? ?? 'pending',
      driverName: json['driverName'] as String?,
      driverPhone: json['driverPhone'] as String?,
      latitude: double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: double.tryParse(json['longitude']?.toString() ?? ''),
      signatureUrl: json['signatureUrl'] as String?,
      photoUrl: json['photoUrl'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  String get statusLabel => status.replaceAll('_', ' ');
  bool get isPending => status == 'pending';
  bool get isInTransit => status == 'in_transit';
  bool get isDelivered => status == 'delivered';
  bool get isFailed => status == 'failed';
}
