import 'package:drift/drift.dart';

class CachedProducts extends Table {
  TextColumn get id => text()();
  TextColumn get sku => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get unitPrice => real()();
  TextColumn get productType => text()();
  TextColumn get uom => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  RealColumn get stockQuantity => real().withDefault(const Constant(0))();
  TextColumn get jsonData => text()();
  DateTimeColumn get syncedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
