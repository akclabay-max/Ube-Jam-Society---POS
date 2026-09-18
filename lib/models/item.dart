class Item {
  const Item({
    this.id,
    required this.name,
    required this.price,
    this.stock = 0,
    this.contributor,
    this.fandom,
    this.category,
    this.picturePath,
    this.discount = 0,
    this.paymentMethod,
  });

  final int? id;              
  final String name;
  final double price;
  final int stock;
  final String? contributor;
  final String? fandom;
  final String? category;
  final String? picturePath;  
  final double discount;    
  final String? paymentMethod; 

  Item copyWith({
    int? id,
    String? name,
    double? price,
    int? stock,
    String? contributor,
    String? fandom,
    String? category,
    String? picturePath,
    double? discount,
    String? paymentMethod,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      contributor: contributor ?? this.contributor,
      fandom: fandom ?? this.fandom,
      category: category ?? this.category,
      picturePath: picturePath ?? this.picturePath,
      discount: discount ?? this.discount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  /// Price after applying discount (treats discount as a percentage). The 4 for 100 type stuff. Come back to this lmao
  double get finalPrice => price * (1 - discount / 100);
}