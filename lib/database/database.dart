// lib/database/database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// ── Tables ──────────────────────────────────────
class SettingsEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get listType => text()();
  TextColumn get value => text()();
}

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  RealColumn get price => real()();
  IntColumn get stock => integer().withDefault(const Constant(0))();
  TextColumn get contributor => text().nullable()();
  TextColumn get fandom => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get picturePath => text().nullable()();
  RealColumn get discount => real().withDefault(const Constant(0))();
}

// ── Database ────────────────────────────────────
@DriftDatabase(tables: [SettingsEntries, Items])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  // ── Items ─────────────────────────────────────
  Stream<List<Item>> watchAllItems() => select(items).watch();

  Future<int> addItem(ItemsCompanion entry) => into(items).insert(entry);

  Future<bool> updateItem(ItemsCompanion entry, int id) async {
    final rows = await (update(items)..where((t) => t.id.equals(id))).write(entry);
    return rows > 0;
  }

  Future<int> deleteItem(int id) =>
      (delete(items)..where((t) => t.id.equals(id))).go();

  // ── Settings ──────────────────────────────────
  Stream<List<SettingsEntry>> watchEntriesFor(String listType) {
    return (select(settingsEntries)
          ..where((t) => t.listType.equals(listType))
          ..orderBy([(t) => OrderingTerm(expression: t.value)]))
        .watch();
  }

  Future<int> addEntry(String listType, String value) {
    return into(settingsEntries).insert(
      SettingsEntriesCompanion.insert(listType: listType, value: value),
    );
  }

  Future<int> updateEntry(int id, String newValue) {
    return (update(settingsEntries)..where((t) => t.id.equals(id)))
        .write(SettingsEntriesCompanion(value: Value(newValue)));
  }

  Future<int> deleteEntry(int id) {
    return (delete(settingsEntries)..where((t) => t.id.equals(id))).go();
  }
}

// ── Connection ──────────────────────────────────
QueryExecutor _openConnection() {
  return driftDatabase(name: 'my_settings_database');
}