import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _filterController = TextEditingController();
  final FocusNode _filterFocus = FocusNode();

  // ── Filter suggestions ──────────────────────────
  

  final List<String> _activeFilters = [];

  // ── Selection mode ──────────────────────────────
  bool _isSelectionMode = false;
  final Map<int, int> _cart = {};       // item id → quantity
  List<Item> _currentItems = [];        // latest DB snapshot

  // ── Computed values ─────────────────────────────
  double get _total {
    double sum = 0;
    _cart.forEach((id, qty) {
      final matches = _currentItems.where((i) => i.id == id);
      if (matches.isEmpty) return;
      sum += matches.first.finalPrice * qty;
    });
    return sum;
  }

  int get _totalItems => _cart.values.fold(0, (a, b) => a + b);

  // ── Selection mode actions ──────────────────────
  void _enterSelection() => setState(() => _isSelectionMode = true);

  void _exitSelection() {
    setState(() {
      _isSelectionMode = false;
      _cart.clear();
    });
  }

  void _increment(int id) {
    setState(() => _cart[id] = (_cart[id] ?? 0) + 1);
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

  // ── Filtering ───────────────────────────────────
  List<Item> _applyFilters(List<Item> allItems) {
    final query = _searchController.text.trim().toLowerCase();

    return allItems.where((item) {
      final matchesSearch = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          (item.contributor?.toLowerCase().contains(query) ?? false) ||
          (item.fandom?.toLowerCase().contains(query) ?? false) ||
          (item.category?.toLowerCase().contains(query) ?? false);

      final matchesFilters = _activeFilters.isEmpty ||
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

  // ── Lifecycle ───────────────────────────────────
  @override
  void dispose() {
    _searchController.dispose();
    _filterController.dispose();
    _filterFocus.dispose();
    super.dispose();
  }

    // ── Build ───────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    

    return Scaffold(
      body: GridBackground(
        cellSize: 20,
        lineColor: const Color(0x33d1d628),
        child: StreamBuilder<List<Item>>(
          stream: db.watchAllItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Failed to load items:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            final allItems = snapshot.data ?? [];
            _currentItems = allItems;
            final items = _applyFilters(allItems);

            return SingleChildScrollView(
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
                            horizontal: 16, vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 12),
                StreamBuilder<List<SettingsEntry>>(
                  stream: db.watchAllEntries(),
                  builder: (context, snapshot) {
                    final keywords = snapshot.data?.map((e) => e.value).toList() ?? const [];

                    return RawAutocomplete<String>(
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
                                  horizontal: 16, vertical: 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (text) {
                              final match = keywords.firstWhere(
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
                    );
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

                  if (allItems.isEmpty)
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
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        for (final item in items)
                          ItemCard(
                            title: item.name,
                            price: item.finalPrice,
                            imagePath: item.picturePath,        
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
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _isSelectionMode
          ? _TotalBar(
              total: _total,
              itemCount: _totalItems,
              color: const Color(0xFF602e9e),
              onCancel: _exitSelection,
              onCheckout: () {
                _exitSelection();
              },
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
// ─────────────────────────────────────────────────
// Helper widgets — all at file level, outside the class
// ─────────────────────────────────────────────────

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
          Icon(icon,
              size: 56,
              color: const Color(0xFF602e9e).withOpacity(0.4)),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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