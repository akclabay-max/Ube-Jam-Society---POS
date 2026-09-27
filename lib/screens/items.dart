import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:provider/provider.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import '/widgets/grid-background.dart';
import '/widgets/item-card.dart';
import '/database/database.dart';
import '/models/item-extensions.dart';
import '/widgets/item-form.dart';
import '/widgets/item-details.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  // ── Controllers ─────────────────────────────────
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _filterController = TextEditingController();
  final FocusNode _filterFocus = FocusNode();
  Timer? _searchDebounce;

  // ── Stream subscriptions ────────────────────────
  StreamSubscription<List<Item>>? _itemsSub;
  StreamSubscription<List<BulkDeal>>? _dealsSub;
  StreamSubscription<List<SettingsEntry>>? _settingsSub;

  // ── Cached data ─────────────────────────────────
  List<Item> _currentItems = [];
  List<BulkDeal> _bulkDeals = [];
  List<SettingsEntry> _allSettings = [];
  bool _loading = true;

  final List<String> _activeFilters = [];

  // ── Selection mode ──────────────────────────────
  bool _isSelectionMode = false;
  final Map<int, int> _cart = {}; // item id → quantity

  // ── Computed values ─────────────────────────────
  double get _total => totalForCart(_currentItems, _bulkDeals, _cart);

  int get _totalItems => _cart.values.fold(0, (a, b) => a + b);

  double get _savings => savingsForCart(_currentItems, _bulkDeals, _cart);

  String? _dealLabelFor(Item item) {
    for (final deal in _bulkDeals) {
      if (deal.id == item.bulkDealId) {
        return '${deal.qty} for ₱${deal.price.toStringAsFixed(0)}';
      }
    }
    return null;
  }

  // ── Lifecycle ───────────────────────────────────
  @override
  void initState() {
    super.initState();
    final db = Provider.of<AppDatabase>(context, listen: false);

    _itemsSub = db.watchAllItems().listen((items) {
      if (!mounted) return;
      setState(() {
        _currentItems = items;
        _loading = false;
      });
    });

    _dealsSub = db.watchAllBulkDeals().listen((deals) {
      if (!mounted) return;
      setState(() => _bulkDeals = deals);
    });

    _settingsSub = db.watchAllEntries().listen((entries) {
      if (!mounted) return;
      setState(() => _allSettings = entries);
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _itemsSub?.cancel();
    _dealsSub?.cancel();
    _settingsSub?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    _filterController.dispose();
    _filterFocus.dispose();
    super.dispose();
  }

  // ── Selection mode actions ──────────────────────
  void _enterSelection() => setState(() => _isSelectionMode = true);

  void _exitSelection() {
    setState(() {
      _isSelectionMode = false;
      _cart.clear();
    });
  }

  void _increment(int id) {
    final item = _currentItems.where((i) => i.id == id).firstOrNull;
    if (item == null) return;

    final currentQty = _cart[id] ?? 0;
    if (currentQty >= item.stock) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Only ${item.stock} in stock'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF602e9e),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      return;
    }

    setState(() => _cart[id] = currentQty + 1);
  }

  void _decrement(int id) {
    setState(() {
      final q = (_cart[id] ?? 0) - 1;
      if (q <= 0) {
        _cart.remove(id);
      } else {
        _cart[id] = q;
      }
    });
  }

  Future<void> _checkout() async {
    final selected = _cart.entries
        .map((entry) {
          final item = _currentItems.where((item) => item.id == entry.key);
          return item.isEmpty ? null : MapEntry(item.first, entry.value);
        })
        .whereType<MapEntry<Item, int>>()
        .toList();
    if (selected.isEmpty) return;

    var paymentMethod = 'Cash';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Confirm checkout'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final entry in selected)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(child: Text(entry.key.name)),
                          Text('x${entry.value}'),
                          const SizedBox(width: 12),
                          Text(
                            '₱${(entry.key.finalPrice * entry.value).toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                  const Divider(),
                  for (final deal in _bulkDeals.where(
                    (deal) => selected.any(
                      (entry) => entry.key.bulkDealId == deal.id,
                    ),
                  ))
                    Text(
                      '${deal.name}: ${deal.qty} for ₱${deal.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: ₱${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: paymentMethod,
                    decoration: const InputDecoration(
                      labelText: 'Payment method',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                      DropdownMenuItem(value: 'Online', child: Text('Online')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => paymentMethod = value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Confirm payment'),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || !mounted) return;

    final now = DateTime.now();
    final receiptNumber = 'UJSR-${now.millisecondsSinceEpoch}';
    final checkoutTotal = _total;
    final receiptItems = selected
        .map(
          (entry) => {
            'name': entry.key.name,
            'qty': entry.value,
            'price': entry.key.finalPrice,
            'bulkDeal': _dealLabelFor(entry.key),
            'contributor': entry.key.contributor,
          },
        )
        .toList();
    final db = Provider.of<AppDatabase>(context, listen: false);
    try {
      await db.completeCheckout(
        receipt: ReceiptsCompanion.insert(
          receiptNumber: receiptNumber,
          createdAt: now,
          paymentMethod: paymentMethod,
          total: checkoutTotal,
          itemsJson: jsonEncode(receiptItems),
        ),
        earning: EarningsCompanion.insert(
          startDate: now,
          endDate: now,
          amount: checkoutTotal,
          source: const Value('Checkout'),
          receiptId: Value(receiptNumber),
        ),
        quantities: {for (final entry in selected) entry.key.id: entry.value},
      );
    } on StateError catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
      return;
    }
    _exitSelection();
  }

  Future<void> _importItems() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      withData: true,
    );
    if (result == null || result.files.single.bytes == null) return;

    final workbook = Excel.decodeBytes(result.files.single.bytes!);
    final sheet = workbook.tables.values.firstOrNull;
    if (sheet == null || sheet.rows.isEmpty) return;

    String cellValue(List<Data?> row, int index) =>
        index < row.length ? row[index]?.value?.toString().trim() ?? '' : '';
    final headers = sheet.rows.first
        .map((cell) => cell?.value?.toString().trim().toLowerCase() ?? '')
        .toList();
    int column(String name) => headers.indexOf(name);
    final nameColumn = column('name');
    final priceColumn = column('price');
    if (nameColumn < 0 || priceColumn < 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Excel must include name and price columns.'),
        ),
      );
      return;
    }

    final db = Provider.of<AppDatabase>(context, listen: false);
    var imported = 0;
    for (final row in sheet.rows.skip(1)) {
      final name = cellValue(row, nameColumn);
      final price = double.tryParse(cellValue(row, priceColumn));
      if (name.isEmpty || price == null) continue;

      int? optionalInt(String header) {
        final index = column(header);
        return index < 0 ? null : int.tryParse(cellValue(row, index));
      }

      double? optionalDouble(String header) {
        final index = column(header);
        return index < 0 ? null : double.tryParse(cellValue(row, index));
      }

      String? optionalText(String header) {
        final index = column(header);
        final value = index < 0 ? '' : cellValue(row, index);
        return value.isEmpty ? null : value;
      }

      await db.addItem(
        ItemsCompanion.insert(
          name: name,
          price: price,
          stock: Value(optionalInt('stock') ?? 0),
          contributor: Value(optionalText('contributor')),
          fandom: Value(optionalText('fandom')),
          category: Value(optionalText('category')),
          discount: Value(optionalDouble('discount') ?? 0),
          bulkDealId: Value(optionalInt('bulkdealid')),
        ),
      );
      imported++;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$imported item(s) imported.')));
  }

  // ── Filtering ───────────────────────────────────
  List<Item> _applyFilters(List<Item> allItems) {
    final query = _searchController.text.trim().toLowerCase();

    return allItems.where((item) {
      final matchesSearch =
          query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          (item.contributor?.toLowerCase().contains(query) ?? false) ||
          (item.fandom?.toLowerCase().contains(query) ?? false) ||
          (item.category?.toLowerCase().contains(query) ?? false);

      final matchesFilters =
          _activeFilters.isEmpty ||
          _activeFilters.any((f) {
            final lower = f.toLowerCase();
            return item.name.toLowerCase().contains(lower) ||
                (item.contributor?.toLowerCase().contains(lower) ?? false) ||
                (item.fandom?.toLowerCase().contains(lower) ?? false) ||
                (item.category?.toLowerCase().contains(lower) ?? false);
          });

      return matchesSearch && matchesFilters;
    }).toList();
  }

  // ── Build ───────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: GridBackground(
          cellSize: 20,
          lineColor: Color(0x33d1d628),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final items = _applyFilters(_currentItems);
    final keywords = _allSettings.map((e) => e.value).toList();

    return Scaffold(
      body: GridBackground(
        cellSize: 20,
        lineColor: const Color(0x33d1d628),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Items',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF602e9e),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: _importItems,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Import Excel'),
                ),
              ),
              const SizedBox(height: 12),

              _ShadowedField(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    _searchDebounce?.cancel();
                    _searchDebounce = Timer(
                      const Duration(milliseconds: 300),
                      () {
                        if (mounted) setState(() {});
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              RawAutocomplete<String>(
                textEditingController: _filterController,
                focusNode: _filterFocus,
                optionsBuilder: (value) {
                  final q = value.text.trim().toLowerCase();
                  if (q.isEmpty) return const Iterable<String>.empty();
                  return keywords.where((k) => k.toLowerCase().contains(q));
                },
                fieldViewBuilder: (context, controller, focusNode, _) {
                  return _ShadowedField(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: 'Filter by keyword...',
                        prefixIcon: const Icon(Icons.filter_alt_outlined),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (text) {
                        final match = keywords.firstWhere(
                          (k) =>
                              k.toLowerCase() == text.trim().toLowerCase(),
                          orElse: () => text.trim(),
                        );
                        if (match.isNotEmpty &&
                            !_activeFilters.contains(match)) {
                          setState(() => _activeFilters.add(match));
                        }
                        controller.clear();
                        focusNode.unfocus();
                      },
                    ),
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      color: Colors.white,
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 220),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              dense: true,
                              leading: const Icon(Icons.tag, size: 18),
                              title: Text(option),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                onSelected: (value) {
                  if (!_activeFilters.contains(value)) {
                    setState(() => _activeFilters.add(value));
                  }
                  _filterController.clear();
                  _filterFocus.unfocus();
                },
              ),
                if (_activeFilters.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final filter in _activeFilters)
                      Chip(
                        label: Text(filter),
                        labelStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF602e9e),
                        ),
                        backgroundColor:
                            const Color(0xFF602e9e).withOpacity(0.1),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () =>
                            setState(() => _activeFilters.remove(filter)),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              if (_currentItems.isEmpty)
                const _EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: 'No items yet',
                  message: 'Tap + to add your first item.',
                )
              else if (items.isEmpty)
                const _EmptyState(
                  icon: Icons.search_off,
                  title: 'No matches',
                  message: 'Try a different search or filter.',
                )
              else
              LayoutBuilder(
                builder: (context, constraints) {
                  final available = constraints.maxWidth;

                  const spacing = 16.0;
                  final columns = (available / 180).floor().clamp(2, 6);

                  final cardWidth =
                      (available - (columns - 1) * spacing) / columns;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      for (final item in items)
                        SizedBox(
                          width: cardWidth,
                          height: cardWidth * 1.5,   
                          child: ItemCard(
                            key: ValueKey(item.id),
                            title: item.name,
                            price: item.finalPrice,
                            imagePath: item.picturePath,
                            bulkDealLabel: _dealLabelFor(item),
                            quantity: _isSelectionMode
                                ? (_cart[item.id] ?? 0)
                                : null,
                            onIncrement: _isSelectionMode
                                ? () => _increment(item.id!)
                                : null,
                            onDecrement: _isSelectionMode
                                ? () => _decrement(item.id!)
                                : null,
                            onViewDetails: () => _viewItem(item),
                            onEdit: () => _editItem(item),
                            onDelete: () => _confirmDelete(item),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _isSelectionMode
          ? _TotalBar(
              total: _total,
              savings: _savings,
              itemCount: _totalItems,
              color: const Color(0xFF602e9e),
              onCancel: _exitSelection,
              onCheckout: _checkout,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.small(
                  heroTag: 'add-item',
                  onPressed: _addItem,
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF602e9e),
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 12),
                FloatingActionButton.extended(
                  heroTag: 'sale',
                  onPressed: _enterSelection,
                  backgroundColor: const Color(0xFF602e9e),
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.point_of_sale),
                  label: const Text('Sale'),
                ),
              ],
            ),
    );
  }

  // ── Item actions ────────────────────────────────
  Future<void> _addItem() async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ItemFormSheet(),
    );
  }

  Future<void> _editItem(Item item) async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ItemFormSheet(item: item),
    );
  }

  void _viewItem(Item item) {
    showItemDetails(context, item);
  }

  Future<void> _confirmDelete(Item item) async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text('"${item.name}" will be permanently removed.'),
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
      await db.deleteItem(item.id!);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: const Color(0xFF602e9e).withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF602e9e),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _ShadowedField extends StatelessWidget {
  const _ShadowedField({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _TotalBar extends StatelessWidget {
  const _TotalBar({
    required this.total,
    required this.savings,
    required this.itemCount,
    required this.color,
    required this.onCancel,
    required this.onCheckout,
  });

  final double total;
  final double savings;
  final int itemCount;
  final Color color;
  final VoidCallback onCancel;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      elevation: 6,
      child: Container(
        width: MediaQuery.of(context).size.width - 32,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            IconButton(
              onPressed: onCancel,
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: 'Cancel',
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '₱${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (savings > 0)
                    Text(
                      'Saved ₱${savings.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            if (itemCount > 0)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  '$itemCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            FilledButton(
              onPressed: itemCount > 0 ? onCheckout : null,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}