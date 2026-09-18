import 'package:flutter/material.dart';
import '/widgets/grid-background.dart';
import '/widgets/item-card.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _filterController = TextEditingController();
  final FocusNode _filterFocus = FocusNode();

  static const List<String> _keywords = [
    'Sticker', 'Pin', 'Project Hail Mary', 'Love and Deepspace',
    'Aster', 'Miisomaru', 'Stickersheet', 'Magnet', 'Bookmark',
  ];

  // Hardcoded items for now. Replace with a real list later.
  static const List<_Item> _items = [
    _Item('Sticker Pack', 19.99),
    _Item('Enamel Pin', 49.99),
    _Item('Project Hail Mary', 249.00),
    _Item('Love and Deepspace Keychain', 129.00),
    _Item('Aster Postcard', 25.00),
    _Item('Miisomaru Sticker', 15.00),
    _Item('Stickersheet Set', 89.00),
    _Item('Fridge Magnet', 55.00),
    _Item('Bookmark', 35.00),
  ];

  final List<String> _activeFilters = [];

  // ── Selection mode ─────────────────────────────
  bool _isSelectionMode = false;
  final Map<String, int> _cart = {};   // item title → quantity

  double get _total {
    double sum = 0;
    _cart.forEach((title, qty) {
      final item = _items.firstWhere((i) => i.title == title);
      sum += item.price * qty;
    });
    return sum;
  }

  int get _totalItems => _cart.values.fold(0, (a, b) => a + b);

  void _enterSelection() => setState(() => _isSelectionMode = true);

  void _exitSelection() {
    setState(() {
      _isSelectionMode = false;
      _cart.clear();
    });
  }

  void _increment(String title) {
    setState(() => _cart[title] = (_cart[title] ?? 0) + 1);
  }

  void _decrement(String title) {
    setState(() {
      final q = (_cart[title] ?? 0) - 1;
      if (q <= 0) {
        _cart.remove(title);
      } else {
        _cart[title] = q;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filterController.dispose();
    _filterFocus.dispose();
    super.dispose();
  }

  List<_Item> get _visibleItems {
    final query = _searchController.text.trim().toLowerCase();
    return _items.where((item) {
      final matchesSearch =
          query.isEmpty || item.title.toLowerCase().contains(query);
      final matchesFilters = _activeFilters.isEmpty ||
          _activeFilters.any(
            (f) => item.title.toLowerCase().contains(f.toLowerCase()),
          );
      return matchesSearch && matchesFilters;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _visibleItems;

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
                'Items',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF602e9e),
                ),
              ),
              const SizedBox(height: 16),

              // Search
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 12),

              // Filter
              RawAutocomplete<String>(
                textEditingController: _filterController,
                focusNode: _filterFocus,
                optionsBuilder: (value) {
                  final q = value.text.trim().toLowerCase();
                  if (q.isEmpty) return const Iterable<String>.empty();
                  return _keywords.where((k) => k.toLowerCase().contains(q));
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
                            horizontal: 16, vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (text) {
                        final match = _keywords.firstWhere(
                          (k) => k.toLowerCase() == text.trim().toLowerCase(),
                          orElse: () => text.trim(),
                        );
                        if (match.isNotEmpty && !_activeFilters.contains(match)) {
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

              // Active filter chips
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

              // Items grid
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final item in items)
                    ItemCard(
                      title: item.title,
                      price: item.price,
                      quantity: _isSelectionMode ? (_cart[item.title] ?? 0) : null,
                      onIncrement: _isSelectionMode
                          ? () => _increment(item.title)
                          : null,
                      onDecrement: _isSelectionMode
                          ? () => _decrement(item.title)
                          : null,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),

      // ── Bottom bar (FAB ↔ Total card) ─────────────
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,
      floatingActionButton: _isSelectionMode
          ? _TotalBar(
              total: _total,
              itemCount: _totalItems,
              color: const Color(0xFF602e9e),
              onCancel: _exitSelection,
              onCheckout: () {
                // TODO: navigate to checkout / receipt
                _exitSelection();
              },
            )
          : FloatingActionButton.extended(
              onPressed: _enterSelection,
              backgroundColor: const Color(0xFF602e9e),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Sale'),
            ),
    );
  }
}

class _Item {
  const _Item(this.title, this.price);
  final String title;
  final double price;
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

/// The expanded total bar that replaces the FAB.
class _TotalBar extends StatelessWidget {
  const _TotalBar({
    required this.total,
    required this.itemCount,
    required this.color,
    required this.onCancel,
    required this.onCheckout,
  });

  final double total;
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
        width: MediaQuery.of(context).size.width - 32,   // full-width minus margins
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Cancel button
            IconButton(
              onPressed: onCancel,
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: 'Cancel',
            ),
            const SizedBox(width: 4),

            // Total text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '₱${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Item count
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

            // Checkout
            FilledButton(
              onPressed: itemCount > 0 ? onCheckout : null,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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