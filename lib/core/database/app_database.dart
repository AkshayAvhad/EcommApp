import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('ProductLocal')
class Products extends Table {
  IntColumn get id => integer()();

  TextColumn get title => text()();

  RealColumn get price => real()();

  TextColumn get description => text()();

  TextColumn get category => text()();

  TextColumn get thumbnail => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<ProductLocal>> getAllProducts() => select(products).get();

  Future insertProducts(List<ProductLocal> items) => batch((batch) {
    batch.insertAll(products, items);
  });

  Future deleteAllProducts() => delete(products).go();

  Future<void> clearAllData() async {
    // Run this inside a transaction so if one table clear fails, everything rolls back safely
    await transaction(() async {
      // Deleting in reverse topological order protects against foreign key violations
      for (final table in allTables.toList().reversed) {
        await delete(table).go();
      }
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
