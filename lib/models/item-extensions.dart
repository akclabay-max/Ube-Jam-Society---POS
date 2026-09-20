import '../database/database.dart';

extension ItemPricing on Item {
  /// Price after applying the item's regular percentage discount.
  double get finalPrice {
    if (discount <= 0) return price;
    return price * (1 - discount / 100);
  }
}

/// Calculates a cart total using mix-and-match bulk deals.
///
/// Items in the same deal are combined before bundles are calculated. Any
/// remainder is charged using the cheapest items first, maximizing savings.
double totalForCart(
  List<Item> items,
  List<BulkDeal> deals,
  Map<int, int> cart,
) {
  final itemsById = {for (final item in items) item.id: item};
  final dealsById = {for (final deal in deals) deal.id: deal};
  final grouped = <int, List<MapEntry<Item, int>>>{};
  var total = 0.0;

  for (final entry in cart.entries) {
    final item = itemsById[entry.key];
    if (item == null || entry.value <= 0) continue;

    final dealId = item.bulkDealId;
    final deal = dealId == null ? null : dealsById[dealId];
    if (deal == null || deal.qty < 2 || deal.price < 0) {
      total += item.finalPrice * entry.value;
      continue;
    }

    grouped.putIfAbsent(deal.id, () => []).add(MapEntry(item, entry.value));
  }

  for (final entry in grouped.entries) {
    final deal = dealsById[entry.key]!;
    final groupedItems = [...entry.value]
      ..sort((a, b) => a.key.finalPrice.compareTo(b.key.finalPrice));
    final totalQuantity = groupedItems.fold(0, (sum, item) => sum + item.value);
    final bundles = totalQuantity ~/ deal.qty;
    var remainder = totalQuantity % deal.qty;

    total += bundles * deal.price;
    for (final item in groupedItems) {
      if (remainder == 0) break;
      final quantity = remainder < item.value ? remainder : item.value;
      total += quantity * item.key.finalPrice;
      remainder -= quantity;
    }
  }

  return total;
}

double fullTotalForCart(List<Item> items, Map<int, int> cart) {
  final itemsById = {for (final item in items) item.id: item};
  return cart.entries.fold(0, (total, entry) {
    final item = itemsById[entry.key];
    return total + (item?.finalPrice ?? 0) * entry.value;
  });
}

double savingsForCart(
  List<Item> items,
  List<BulkDeal> deals,
  Map<int, int> cart,
) {
  final savings =
      fullTotalForCart(items, cart) - totalForCart(items, deals, cart);
  return savings > 0 ? savings : 0;
}
