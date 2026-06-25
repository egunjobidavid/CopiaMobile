import 'package:drift/drift.dart';

class CachedOrders extends Table {
  TextColumn get id => text()();
  TextColumn get orderNumber => text()();
  TextColumn get customerName => text().nullable()();
  TextColumn get status => text()();
  RealColumn get total => real()();
  TextColumn get jsonData => text()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
