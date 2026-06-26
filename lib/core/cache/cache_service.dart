import 'dart:convert';
import 'package:drift/drift.dart';
import 'drift_database.dart';


class CacheService {
  final AppDatabase _db;

  CacheService(this._db);

  // Products
  Future<void> cacheProducts(List<Map<String, dynamic>> products) async {
    await _db.batch((b) {
      for (final p in products) {
        b.insert(
          _db.cachedProducts,
          CachedProductsCompanion.insert(
            id: p['id'] as String,
            sku: p['sku'] as String? ?? '',
            name: p['name'] as String? ?? '',
            description: Value(p['description'] as String?),
            unitPrice: (p['unitPrice'] as num?)?.toDouble() ?? 0,
            productType: p['productType'] as String? ?? 'finished_good',
            uom: p['uom'] as String? ?? 'pcs',
            isActive: Value(p['isActive'] as bool? ?? true),
            stockQuantity: Value((p['stockQuantity'] as num?)?.toDouble() ?? 0),
            jsonData: jsonEncode(p),
            syncedAt: DateTime.now(),
          ),
          mode: InsertMode.replace,
        );
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCachedProducts({String? query}) async {
    final products = await _db.select(_db.cachedProducts).get();
    final result = products.map((p) => jsonDecode(p.jsonData) as Map<String, dynamic>).toList();
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      return result.where((p) =>
        (p['name'] as String? ?? '').toLowerCase().contains(q) ||
        (p['sku'] as String? ?? '').toLowerCase().contains(q)
      ).toList();
    }
    return result;
  }

  Future<Map<String, dynamic>?> getCachedProduct(String id) async {
    final product = await (_db.select(_db.cachedProducts)..where((p) => p.id.equals(id))).getSingleOrNull();
    if (product == null) return null;
    return jsonDecode(product.jsonData) as Map<String, dynamic>;
  }

  // Customers
  Future<void> cacheCustomers(List<Map<String, dynamic>> customers) async {
    await _db.batch((b) {
      for (final c in customers) {
        b.insert(
          _db.cachedCustomers,
          CachedCustomersCompanion.insert(
            id: c['id'] as String,
            firstName: c['firstName'] as String? ?? '',
            lastName: c['lastName'] as String? ?? '',
            email: Value(c['email'] as String?),
            phone: Value(c['phone'] as String?),
            balance: Value((c['balance'] as num?)?.toDouble() ?? 0),
            isActive: Value(c['isActive'] as bool? ?? true),
            jsonData: jsonEncode(c),
            syncedAt: DateTime.now(),
          ),
          mode: InsertMode.replace,
        );
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCachedCustomers({String? query}) async {
    final customers = await _db.select(_db.cachedCustomers).get();
    final result = customers.map((c) => jsonDecode(c.jsonData) as Map<String, dynamic>).toList();
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      return result.where((c) =>
        ('${c['firstName'] ?? ''} ${c['lastName'] ?? ''}').toLowerCase().contains(q) ||
        (c['email'] as String? ?? '').toLowerCase().contains(q)
      ).toList();
    }
    return result;
  }

  // Orders
  Future<void> cacheOrders(List<Map<String, dynamic>> orders) async {
    await _db.batch((b) {
      for (final o in orders) {
        b.insert(
          _db.cachedOrders,
          CachedOrdersCompanion.insert(
            id: o['id'] as String,
            orderNumber: o['orderNumber'] as String? ?? o['reference'] as String? ?? '',
            customerName: Value(o['customerName'] as String?),
            status: o['status'] as String? ?? 'draft',
            total: (o['total'] as num?)?.toDouble() ?? 0,
            jsonData: jsonEncode(o),
            isSynced: Value(true),
            createdAt: DateTime.now(),
            syncedAt: DateTime.now(),
          ),
          mode: InsertMode.replace,
        );
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCachedOrders() async {
    final orders = await _db.select(_db.cachedOrders).get();
    return orders.map((o) => jsonDecode(o.jsonData) as Map<String, dynamic>).toList();
  }

  // General
  Future<void> clearAll() async {
    await _db.delete(_db.cachedProducts).go();
    await _db.delete(_db.cachedCustomers).go();
    await _db.delete(_db.cachedOrders).go();
  }
}
