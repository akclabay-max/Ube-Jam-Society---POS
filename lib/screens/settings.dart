import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;
import '../widgets/grid-background.dart';
import '../widgets/settings-card.dart';
import '../database/database.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      body: GridBackground(
        cellSize: 20,
        lineColor: const Color(0x33d1d628),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF602e9e),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _SettingsList(
                    db: db,
                    listType: 'contributor',
                    title: 'Contributors',
                    subtitle: 'People who share profits',
                    icon: Icons.people_outline,
                  ),
                  _SettingsList(
                    db: db,
                    listType: 'fandom',
                    title: 'Fandoms',
                    subtitle: 'Series and universes',
                    icon: Icons.auto_stories_outlined,
                    color: const Color(0xFF1E88E5),
                  ),
                  _SettingsList(
                    db: db,
                    listType: 'category',
                    title: 'Categories',
                    subtitle: 'Product groupings',
                    icon: Icons.category_outlined,
                    color: const Color(0xFF1B8E3D),
                  ),
                  _BulkDealsList(db: db),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One editable settings list, backed by the database.
class _SettingsList extends StatelessWidget {
  const _SettingsList({
    required this.db,
    required this.listType,
    required this.title,
    this.subtitle,
    this.icon,
    this.color = const Color(0xFF602e9e),
  });

  final AppDatabase db;
  final String listType;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color color;

  Future<void> _add(BuildContext context) async {
    final name = await _promptForValue(context, title: 'Add to $title');
    if (name == null || name.isEmpty) return;
    await db.addEntry(listType, name);
  }

  Future<void> _edit(BuildContext context, int id, String current) async {
    final name = await _promptForValue(
      context,
      title: 'Edit entry',
      initial: current,
    );
    if (name == null || name.isEmpty) return;
    await db.updateEntry(id, name);
  }

  Future<void> _delete(BuildContext context, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await db.deleteEntry(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SettingsEntry>>(
      stream: db.watchEntriesFor(listType),
      builder: (context, snapshot) {
        final entries = snapshot.data ?? [];
        return SettingsCard(
          title: title,
          subtitle: subtitle,
          icon: icon,
          color: color,
          entries: entries.map((e) => e.value).toList(),
          onAdd: () => _add(context),
          onEdit: (index, _) =>
              _edit(context, entries[index].id, entries[index].value),
          onDelete: (index, _) => _delete(context, entries[index].id),
        );
      },
    );
  }
}

class _BulkDealsList extends StatelessWidget {
  const _BulkDealsList({required this.db});

  final AppDatabase db;

  Future<void> _edit(BuildContext context, {BulkDeal? deal}) async {
    final values = await _promptForDeal(context, deal: deal);
    if (values == null) return;

    final entry = BulkDealsCompanion(
      id: deal == null ? const Value.absent() : Value(deal.id),
      name: Value(values.name),
      qty: Value(values.qty),
      price: Value(values.price),
    );
    if (deal == null) {
      await db.addBulkDeal(entry);
    } else {
      await db.updateBulkDeal(entry, deal.id);
    }
  }

  Future<void> _delete(BuildContext context, BulkDeal deal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete bulk deal?'),
        content: Text('Items using "${deal.name}" will become regular items.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) await db.deleteBulkDeal(deal.id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BulkDeal>>(
      stream: db.watchAllBulkDeals(),
      builder: (context, snapshot) {
        final deals = snapshot.data ?? [];
        return SettingsCard(
          title: 'Bulk Deals',
          subtitle: 'Mix-and-match bundle groups',
          icon: Icons.local_offer_outlined,
          color: const Color(0xFFE67E22),
          entries: deals
              .map(
                (deal) =>
                    '${deal.name}: ${deal.qty} for ₱${deal.price.toStringAsFixed(2)}',
              )
              .toList(),
          onAdd: () => _edit(context),
          onEdit: (index, _) => _edit(context, deal: deals[index]),
          onDelete: (index, _) => _delete(context, deals[index]),
        );
      },
    );
  }
}

class _BulkDealValues {
  const _BulkDealValues(this.name, this.qty, this.price);
  final String name;
  final int qty;
  final double price;
}

Future<_BulkDealValues?> _promptForDeal(
  BuildContext context, {
  BulkDeal? deal,
}) {
  final name = TextEditingController(text: deal?.name ?? '');
  final qty = TextEditingController(text: deal?.qty.toString() ?? '');
  final price = TextEditingController(text: deal?.price.toString() ?? '');

  return showDialog<_BulkDealValues>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(deal == null ? 'Add bulk deal' : 'Edit bulk deal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Deal name'),
          ),
          TextField(
            controller: qty,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity in bundle'),
          ),
          TextField(
            controller: price,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Bundle price (₱)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final parsedQty = int.tryParse(qty.text.trim());
            final parsedPrice = double.tryParse(price.text.trim());
            if (name.text.trim().isEmpty ||
                parsedQty == null ||
                parsedQty < 2 ||
                parsedPrice == null ||
                parsedPrice < 0) {
              return;
            }
            Navigator.pop(
              context,
              _BulkDealValues(name.text.trim(), parsedQty, parsedPrice),
            );
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

/// Simple text-input dialog used for add + edit.
Future<String?> _promptForValue(
  BuildContext context, {
  required String title,
  String? initial,
}) {
  final controller = TextEditingController(text: initial ?? '');
  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Enter value'),
        onSubmitted: (v) => Navigator.pop(context, v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
