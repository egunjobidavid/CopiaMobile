import 'dart:ui' show Color;
import 'package:flutter/material.dart' show Colors;

class StockMovement {
  final String id;
  final String productId;
  final String productName;
  final String type;
  final double quantity;
  final double unitCost;
  final String? reference;
  final String warehouseName;
  final String createdAt;

  StockMovement({
    required this.id,
    required this.productId,
    required this.productName,
    required this.type,
    required this.quantity,
    this.unitCost = 0,
    this.reference,
    this.warehouseName = '',
    this.createdAt = '',
  });

  factory StockMovement.fromJson(Map<String, dynamic> json) {
    return StockMovement(
      id: json['id'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      type: json['type'] as String? ?? json['movementType'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      unitCost: (json['unitCost'] as num?)?.toDouble() ?? 0,
      reference: json['reference'] as String?,
      warehouseName: json['warehouseName'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? json['created_at'] as String? ?? '',
    );
  }

  String get typeLabel => type.replaceAll('_', ' ');
  bool get isInbound => type == 'in' || type == 'IN' || type == 'receipt';
  bool get isOutbound => type == 'out' || type == 'OUT' || type == 'issue';
  Color get typeColor => isInbound ? Colors.green : Colors.red;
}
