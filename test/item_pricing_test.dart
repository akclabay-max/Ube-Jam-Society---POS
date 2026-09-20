import 'package:flutter_test/flutter_test.dart';
import 'package:pos/database/database.dart';
import 'package:pos/models/item-extensions.dart';

Item item({
  required int id,
  required double price,
  int? bulkDealId,
  double discount = 0,
}) {
  return Item(
    id: id,
    name: 'Test item $id',
    price: price,
    stock: 100,
    discount: discount,
    bulkDealId: bulkDealId,
  );
}

BulkDeal deal({
  int id = 1,
  String name = 'Sticker Deal',
  int qty = 4,
  double price = 100,
}) {
  return BulkDeal(id: id, name: name, qty: qty, price: price);
}

void main() {
  test('applies a 4 for 100 deal and charges regular remainder', () {
    final stickers = item(id: 1, price: 30, bulkDealId: 1);

    expect(totalForCart([stickers], [deal()], {1: 4}), 100);
    expect(totalForCart([stickers], [deal()], {1: 5}), 130);
  });

  test('combines different items in the same deal group', () {
    final blueSticker = item(id: 1, price: 30, bulkDealId: 1);
    final pinkSticker = item(id: 2, price: 25, bulkDealId: 1);

    expect(
      totalForCart([blueSticker, pinkSticker], [deal()], {1: 2, 2: 2}),
      100,
    );
  });

  test('charges the cheapest items first for a mixed remainder', () {
    final expensive = item(id: 1, price: 120, bulkDealId: 1);
    final cheap = item(id: 2, price: 30, bulkDealId: 1);

    expect(totalForCart([expensive, cheap], [deal()], {1: 1, 2: 4}), 130);
  });

  test('supports separate reusable deal groups', () {
    final wristlet = item(id: 1, price: 100, bulkDealId: 1);
    final lanyard = item(id: 2, price: 120, bulkDealId: 2);

    expect(
      totalForCart(
        [wristlet, lanyard],
        [
          deal(price: 170, qty: 2),
          deal(id: 2, name: 'Lanyard Deal', qty: 2, price: 200),
        ],
        {1: 2, 2: 2},
      ),
      370,
    );
  });

  test('applies the regular item discount to loose items', () {
    final discounted = item(id: 1, price: 100, discount: 10);

    expect(totalForCart([discounted], [], {1: 2}), 180);
  });
}
