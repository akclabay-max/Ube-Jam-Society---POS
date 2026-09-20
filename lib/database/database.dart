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

class BulkDeals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  IntColumn get qty => integer()();
  RealColumn get price => real()();
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
  IntColumn get bulkDealId => integer().nullable().references(
    BulkDeals,
    #id,
    onDelete: KeyAction.setNull,
  )();
}

class ProductionCosts extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get particular => text()();
  IntColumn get qty => integer().withDefault(const Constant(1))();
  RealColumn get amount => real()();
}

class Earnings extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  RealColumn get amount => real()();
  TextColumn get source => text().withDefault(const Constant('Manual'))();
  TextColumn get receiptId => text().nullable()();
}

class Receipts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get receiptNumber => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get paymentMethod => text()();
  RealColumn get total => real()();
  TextColumn get itemsJson => text()();
}

// ── Database ────────────────────────────────────
@DriftDatabase(
  tables: [
    SettingsEntries,
    Items,
    BulkDeals,
    ProductionCosts,
    Earnings,
    Receipts,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      // Fresh installs — create everything at the latest version
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // v1 → v2 (if you ever had a v1 with bulk columns, add them here)
        // (Not needed unless you actually had a v1 database.)
      }
      if (from < 3) {
        // v2 → v3: introduced the BulkDeals table
        await m.createTable(bulkDeals);
        await m.alterTable(
          TableMigration(items, newColumns: [items.bulkDealId]),
        );
      }
      if (from < 4) {
        await m.createTable(productionCosts);
        await m.createTable(earnings);
      }
      if (from < 5) {
        await m.createTable(receipts);
        await m.alterTable(
          TableMigration(
            earnings,
            newColumns: [earnings.source, earnings.receiptId],
          ),
        );
      }
    },
  );

  // ── Items ─────────────────────────────────────
  Stream<List<Item>> watchAllItems() => select(items).watch();

  Future<int> addItem(ItemsCompanion entry) => into(items).insert(entry);

  Future<bool> updateItem(ItemsCompanion entry, int id) async {
    final rows = await (update(
      items,
    )..where((t) => t.id.equals(id))).write(entry);
    return rows > 0;
  }

  Future<int> deleteItem(int id) =>
      (delete(items)..where((t) => t.id.equals(id))).go();

  // ── Bulk Deals ────────────────────────────────
  Stream<List<BulkDeal>> watchAllBulkDeals() => (select(
    bulkDeals,
  )..orderBy([(t) => OrderingTerm(expression: t.name)])).watch();

  Future<int> addBulkDeal(BulkDealsCompanion entry) =>
      into(bulkDeals).insert(entry);

  Future<bool> updateBulkDeal(BulkDealsCompanion entry, int id) async {
    final rows = await (update(
      bulkDeals,
    )..where((t) => t.id.equals(id))).write(entry);
    return rows > 0;
  }

  Future<int> deleteBulkDeal(int id) =>
      (delete(bulkDeals)..where((t) => t.id.equals(id))).go();

  // ── Settings ──────────────────────────────────
  Stream<List<SettingsEntry>> watchAllEntries() =>
      select(settingsEntries).watch();

  Stream<List<SettingsEntry>> watchEntriesFor(String listType) {
    return (select(settingsEntries)
          ..where((t) => t.listType.equals(listType))
          ..orderBy([(t) => OrderingTerm(expression: t.value)]))
        .watch();
  }

  Future<int> addEntry(String listType, String value) {
    return into(
      settingsEntries,
    ).insert(SettingsEntriesCompanion.insert(listType: listType, value: value));
  }

  Future<int> updateEntry(int id, String newValue) {
    return (update(settingsEntries)..where((t) => t.id.equals(id))).write(
      SettingsEntriesCompanion(value: Value(newValue)),
    );
  }

  Future<int> deleteEntry(int id) {
    return (delete(settingsEntries)..where((t) => t.id.equals(id))).go();
  }

  // ── Production Costs ──────────────────────────
  Stream<List<ProductionCost>> watchCostsBetween(
    DateTime start,
    DateTime end,
  ) =>
      (select(productionCosts)..where(
            (t) =>
                t.startDate.isBiggerOrEqualValue(start) &
                t.endDate.isSmallerOrEqualValue(end),
          ))
          .watch();

  Future<int> addCost(ProductionCostsCompanion entry) =>
      into(productionCosts).insert(entry);

  Future<bool> updateCost(ProductionCostsCompanion entry, int id) async {
    final rows = await (update(
      productionCosts,
    )..where((t) => t.id.equals(id))).write(entry);
    return rows > 0;
  }

  Future<int> deleteCost(int id) =>
      (delete(productionCosts)..where((t) => t.id.equals(id))).go();

  // ── Earnings ──────────────────────────────────
  Stream<List<Earning>> watchAllEarnings() =>
      (select(earnings)..orderBy([
            (t) =>
                OrderingTerm(expression: t.startDate, mode: OrderingMode.desc),
          ]))
          .watch();

  Future<int> addEarning(EarningsCompanion entry) =>
      into(earnings).insert(entry);

  Future<bool> updateEarning(EarningsCompanion entry, int id) async {
    final rows = await (update(
      earnings,
    )..where((t) => t.id.equals(id))).write(entry);
    return rows > 0;
  }

  Future<int> deleteEarning(int id) =>
      (delete(earnings)..where((t) => t.id.equals(id))).go();

  // ── Receipts ──────────────────────────────────
  Stream<List<Receipt>> watchAllReceipts() =>
      (select(receipts)..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
          .watch();

  Future<int> addReceipt(ReceiptsCompanion entry) =>
      into(receipts).insert(entry);

  Future<void> completeCheckout({
    required ReceiptsCompanion receipt,
    required EarningsCompanion earning,
    required Map<int, int> quantities,
  }) async {
    await transaction(() async {
      for (final entry in quantities.entries) {
        final updated =
            await (update(items)..where(
                  (item) =>
                      item.id.equals(entry.key) &
                      item.stock.isBiggerOrEqualValue(entry.value),
                ))
                .write(
                  ItemsCompanion.custom(
                    stock: items.stock - Constant(entry.value),
                  ),
                );
        if (updated != 1) {
          throw StateError('Not enough stock for item ${entry.key}.');
        }
      }
      await into(receipts).insert(receipt);
      await into(earnings).insert(earning);
    });
  }
}

// ── Connection ──────────────────────────────────
QueryExecutor _openConnection() {
  return driftDatabase(name: 'my_settings_database');
}
