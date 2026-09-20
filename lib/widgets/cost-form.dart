import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/database.dart';

Future<void> showCostForm(BuildContext context, {ProductionCost? cost}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CostFormSheet(cost: cost),
  );
}

class CostFormSheet extends StatefulWidget {
  const CostFormSheet({super.key, this.cost});
  final ProductionCost? cost;

  @override
  State<CostFormSheet> createState() => _CostFormSheetState();
}

class _CostFormSheetState extends State<CostFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _particular;
  late final TextEditingController _qty;
  late final TextEditingController _amount;

  DateTime? _startDate;
  DateTime? _endDate;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.cost;
    _particular = TextEditingController(text: c?.particular ?? '');
    _qty = TextEditingController(text: c?.qty.toString() ?? '1');
    _amount = TextEditingController(text: c?.amount.toStringAsFixed(2) ?? '');
    _startDate = c?.startDate;
    _endDate = c?.endDate;
  }

  @override
  void dispose() {
    _particular.dispose();
    _qty.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final initial = (isStart ? _startDate : _endDate) ?? DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked == null) return;
    setState(() {
      _startDate = picked.start;
      _endDate = picked.end;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date range')),
      );
      return;
    }
    setState(() => _saving = true);

    final db = Provider.of<AppDatabase>(context, listen: false);
    final entry = ProductionCostsCompanion(
      id: widget.cost?.id != null
          ? Value(widget.cost!.id)
          : const Value.absent(),
      startDate: Value(_startDate!),
      endDate: Value(_endDate!),
      particular: Value(_particular.text.trim()),
      qty: Value(int.parse(_qty.text.trim())),
      amount: Value(double.parse(_amount.text.trim())),
    );

    if (widget.cost == null) {
      await db.addCost(entry);
    } else {
      await db.updateCost(entry, widget.cost!.id);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.cost != null;
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isEditing ? 'Edit Cost' : 'New Production Cost',
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

                  // Date range picker
                  OutlinedButton.icon(
                    onPressed: () => _pickDate(true),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _startDate == null || _endDate == null
                          ? 'Select date range'
                          : '${_fmt(_startDate!)}  →  ${_fmt(_endDate!)}',
                    ),
                  ),
                  const SizedBox(height: 12),

                  _field(_particular, 'Particular (e.g. Sticker paper)',
                      required: true),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _field(
                          _qty,
                          'Qty',
                          required: true,
                          keyboard: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Required';
                            final n = int.tryParse(v.trim());
                            if (n == null || n < 1) return 'Whole number';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _field(
                          _amount,
                          'Amount (₱)',
                          required: true,
                          keyboard: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Required';
                            if (double.tryParse(v.trim()) == null) {
                              return 'Number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
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
                            isEditing ? 'Save Changes' : 'Add Cost',
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

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator ??
          (required
              ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
              : null),
    );
  }
}