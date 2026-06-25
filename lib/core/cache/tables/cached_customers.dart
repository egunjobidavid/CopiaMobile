import 'package:drift/drift.dart';

class CachedCustomers extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  RealColumn get balance => real().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get jsonData => text()();
  DateTimeColumn get syncedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
