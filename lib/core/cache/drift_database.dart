import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'tables/cached_products.dart';
import 'tables/cached_customers.dart';
import 'tables/cached_orders.dart';

part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    CachedProducts,
    CachedCustomers,
    CachedOrders,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
  );
}

DatabaseConnection _openConnection() {
  return DatabaseConnection(NativeDatabase.memory());
}
