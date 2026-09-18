import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/database.dart';

class ItemFormSheet extends StatefulWidget {
  const ItemFormSheet({super.key, this.item});

  /// If null → adding. Otherwise → editing.
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
      fandom: Value(
        _fandom.text.trim().isEmpty ? null : _fandom.text.trim(),
      ),
      category: Value(
        _category.text.trim().isEmpty ? null : _category.text.trim(),
      ),
      discount: Value(double.tryParse(_discount.text.trim()) ?? 0),
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
    final isEditing = widget.item != null;
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),   // 👈 lift for keyboard
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
                  // ── Drag handle ─────────────────
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

                  // ── Header ──────────────────────
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

                  // ── Fields ──────────────────────
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

                  _field(_contributor, 'Contributor'),
                  const SizedBox(height: 12),
                  _field(_fandom, 'Fandom'),
                  const SizedBox(height: 12),
                  _field(_category, 'Category'),
                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: image_picker
                    },
                    icon: const Icon(Icons.image_outlined),
                    label: const Text('Add Picture (optional)'),
                  ),
                  const SizedBox(height: 20),

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