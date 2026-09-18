import '../database/database.dart';

extension ItemPricing on Item {
  /// Price after applying discount (discount is a percentage, 0–100).
  double get finalPrice {
    if (discount <= 0) return price;
    return price * (1 - discount / 100);
  }
}