import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../database/database.dart';

Future<String> saveImagePermanently(String originalPath) async {
  final Directory appDir = await getApplicationDocumentsDirectory();
  final String fileName =
      '${DateTime.now().millisecondsSinceEpoch}_${p.basename(originalPath)}';
  final String newPath = p.join(appDir.path, 'item_pictures', fileName);
  await Directory(p.dirname(newPath)).create(recursive: true);
  await File(originalPath).copy(newPath);
  return newPath;
}

class ItemFormSheet extends StatefulWidget {
  const ItemFormSheet({super.key, this.item});
  final Item? item;

  @override
  State<ItemFormSheet> createState() => _ItemFormSheetState();
}

class _ItemFormSheetState extends State<ItemFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _stock;
  late final TextEditingController _contributor;
  late final TextEditingController _fandom;
  late final TextEditingController _category;
  late final TextEditingController _discount;

  bool _saving = false;
  String? _pickedImagePath;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _name = TextEditingController(text: item?.name ?? '');
    _price = TextEditingController(text: item?.price.toStringAsFixed(2) ?? '');
    _stock = TextEditingController(text: item?.stock.toString() ?? '0');
    _contributor = TextEditingController(text: item?.contributor ?? '');
    _fandom = TextEditingController(text: item?.fandom ?? '');
    _category = TextEditingController(text: item?.category ?? '');
    _discount = TextEditingController(text: item?.discount.toString() ?? '0');
    _pickedImagePath = item?.picturePath;
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _stock.dispose();
    _contributor.dispose();
    _fandom.dispose();
    _category.dispose();
    _discount.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
    context: context,                             // ✅ named, required
    builder: (ctx) => SafeArea(                   // ✅ named, required
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a photo'),
            onTap: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from gallery'),
            onTap: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
        ],
      ),
    ),
  );

    if (source == null) return;

    final XFile? image = await picker.pickImage(source: source);
    debugPrint('pickImage returned: $image');
    if (image == null) return;

    final String permanentPath = await saveImagePermanently(image.path);

    if (!mounted) return;
    setState(() => _pickedImagePath = permanentPath);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final db = Provider.of<AppDatabase>(context, listen: false);

    final entry = ItemsCompanion(
      id: widget.item?.id != null
          ? Value(widget.item!.id!)
          : const Value.absent(),
      name: Value(_name.text.trim()),
      price: Value(double.parse(_price.text.trim())),
      stock: Value(int.parse(_stock.text.trim())),
      contributor: Value(
        _contributor.text.trim().isEmpty ? null : _contributor.text.trim(),
      ),
      fandom: Value(_fandom.text.trim().isEmpty ? null : _fandom.text.trim()),
      category:
          Value(_category.text.trim().isEmpty ? null : _category.text.trim()),
      discount: Value(double.tryParse(_discount.text.trim()) ?? 0),
      picturePath: Value(_pickedImagePath),
    );

    if (widget.item == null) {
      await db.into(db.items).insert(entry);
    } else {
      await (db.update(db.items)
            ..where((t) => t.id.equals(widget.item!.id!)))
          .write(entry);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final isEditing = widget.item != null;
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFfffeec),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isEditing ? 'Edit Item' : 'New Item',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF602e9e),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Fields
                  _field(_name, 'Name', required: true),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _field(
                          _price,
                          'Price (₱)',
                          required: true,
                          keyboard: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Required';
                            if (double.tryParse(v.trim()) == null) {
                              return 'Enter a number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _field(
                          _stock,
                          'Stock',
                          keyboard: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return null;
                            if (int.tryParse(v.trim()) == null) {
                              return 'Whole number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _field(
                    _discount,
                    'Discount (%)',
                    keyboard: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final d = double.tryParse(v.trim());
                      if (d == null) return 'Enter a number';
                      if (d < 0 || d > 100) return '0–100 only';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  _SettingsDropdown(
                    db: db,
                    listType: 'contributor',
                    label: 'Contributor',
                    value: _contributor.text.isEmpty ? null : _contributor.text,
                    onChanged: (v) =>
                        setState(() => _contributor.text = v ?? ''),
                  ),
                  const SizedBox(height: 12),
                  _SettingsDropdown(
                    db: db,
                    listType: 'fandom',
                    label: 'Fandom',
                    value: _fandom.text.isEmpty ? null : _fandom.text,
                    onChanged: (v) => setState(() => _fandom.text = v ?? ''),
                  ),
                  const SizedBox(height: 12),
                  _SettingsDropdown(
                    db: db,
                    listType: 'category',
                    label: 'Category',
                    value: _category.text.isEmpty ? null : _category.text,
                    onChanged: (v) => setState(() => _category.text = v ?? ''),
                  ),
                  const SizedBox(height: 12),

                  // Picture
                  OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image_outlined),
                    label: Text(
                      _pickedImagePath == null
                          ? 'Add Picture (optional)'
                          : 'Change Picture',
                    ),
                  ),

                  if (_pickedImagePath != null) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_pickedImagePath!),
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 120,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          setState(() => _pickedImagePath = null),
                      child: const Text(
                        'Remove Picture',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Save
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF602e9e),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isEditing ? 'Save Changes' : 'Add Item',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool required = false,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator ??
          (required
              ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
              : null),
    );
  }
}

class _SettingsDropdown extends StatelessWidget {
  const _SettingsDropdown({
    required this.db,
    required this.listType,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final AppDatabase db;
  final String listType;
  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SettingsEntry>>(
      stream: db.watchEntriesFor(listType),
      builder: (context, snapshot) {
        final entries = snapshot.data ?? [];
        final values = entries.map((e) => e.value).toList();

        final options =
            (value != null && value!.isNotEmpty && !values.contains(value))
                ? [value!, ...values]
                : values;

        return DropdownButtonFormField<String>(
          value: (value?.isEmpty ?? true) ? null : value,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('— none —'),
            ),
            for (final v in options)
              DropdownMenuItem<String>(value: v, child: Text(v)),
          ],
          onChanged: onChanged,
        );
      },
    );
  }
}