import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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