// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SettingsEntriesTable extends SettingsEntries
    with TableInfo<$SettingsEntriesTable, SettingsEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _listTypeMeta = const VerificationMeta(
    'listType',
  );
  @override
  late final GeneratedColumn<String> listType = GeneratedColumn<String>(
    'list_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, listType, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('list_type')) {
      context.handle(
        _listTypeMeta,
        listType.isAcceptableOrUnknown(data['list_type']!, _listTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_listTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      listType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsEntriesTable createAlias(String alias) {
    return $SettingsEntriesTable(attachedDatabase, alias);
  }
}

class SettingsEntry extends DataClass implements Insertable<SettingsEntry> {
  final int id;
  final String listType;
  final String value;
  const SettingsEntry({
    required this.id,
    required this.listType,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['list_type'] = Variable<String>(listType);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsEntriesCompanion toCompanion(bool nullToAbsent) {
    return SettingsEntriesCompanion(
      id: Value(id),
      listType: Value(listType),
      value: Value(value),
    );
  }

  factory SettingsEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsEntry(
      id: serializer.fromJson<int>(json['id']),
      listType: serializer.fromJson<String>(json['listType']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'listType': serializer.toJson<String>(listType),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingsEntry copyWith({int? id, String? listType, String? value}) =>
      SettingsEntry(
        id: id ?? this.id,
        listType: listType ?? this.listType,
        value: value ?? this.value,
      );
  SettingsEntry copyWithCompanion(SettingsEntriesCompanion data) {
    return SettingsEntry(
      id: data.id.present ? data.id.value : this.id,
      listType: data.listType.present ? data.listType.value : this.listType,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsEntry(')
          ..write('id: $id, ')
          ..write('listType: $listType, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, listType, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsEntry &&
          other.id == this.id &&
          other.listType == this.listType &&
          other.value == this.value);
}

class SettingsEntriesCompanion extends UpdateCompanion<SettingsEntry> {
  final Value<int> id;
  final Value<String> listType;
  final Value<String> value;
  const SettingsEntriesCompanion({
    this.id = const Value.absent(),
    this.listType = const Value.absent(),
    this.value = const Value.absent(),
  });
  SettingsEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String listType,
    required String value,
  }) : listType = Value(listType),
       value = Value(value);
  static Insertable<SettingsEntry> custom({
    Expression<int>? id,
    Expression<String>? listType,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listType != null) 'list_type': listType,
      if (value != null) 'value': value,
    });
  }

  SettingsEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? listType,
    Value<String>? value,
  }) {
    return SettingsEntriesCompanion(
      id: id ?? this.id,
      listType: listType ?? this.listType,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (listType.present) {
      map['list_type'] = Variable<String>(listType.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsEntriesCompanion(')
          ..write('id: $id, ')
          ..write('listType: $listType, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $BulkDealsTable extends BulkDeals
    with TableInfo<$BulkDealsTable, BulkDeal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BulkDealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, qty, price];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bulk_deals';
  @override
  VerificationContext validateIntegrity(
    Insertable<BulkDeal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BulkDeal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BulkDeal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
    );
  }

  @override
  $BulkDealsTable createAlias(String alias) {
    return $BulkDealsTable(attachedDatabase, alias);
  }
}

class BulkDeal extends DataClass implements Insertable<BulkDeal> {
  final int id;
  final String name;
  final int qty;
  final double price;
  const BulkDeal({
    required this.id,
    required this.name,
    required this.qty,
    required this.price,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['qty'] = Variable<int>(qty);
    map['price'] = Variable<double>(price);
    return map;
  }

  BulkDealsCompanion toCompanion(bool nullToAbsent) {
    return BulkDealsCompanion(
      id: Value(id),
      name: Value(name),
      qty: Value(qty),
      price: Value(price),
    );
  }

  factory BulkDeal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BulkDeal(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      qty: serializer.fromJson<int>(json['qty']),
      price: serializer.fromJson<double>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'qty': serializer.toJson<int>(qty),
      'price': serializer.toJson<double>(price),
    };
  }

  BulkDeal copyWith({int? id, String? name, int? qty, double? price}) =>
      BulkDeal(
        id: id ?? this.id,
        name: name ?? this.name,
        qty: qty ?? this.qty,
        price: price ?? this.price,
      );
  BulkDeal copyWithCompanion(BulkDealsCompanion data) {
    return BulkDeal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      qty: data.qty.present ? data.qty.value : this.qty,
      price: data.price.present ? data.price.value : this.price,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BulkDeal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('qty: $qty, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, qty, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BulkDeal &&
          other.id == this.id &&
          other.name == this.name &&
          other.qty == this.qty &&
          other.price == this.price);
}

class BulkDealsCompanion extends UpdateCompanion<BulkDeal> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> qty;
  final Value<double> price;
  const BulkDealsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.qty = const Value.absent(),
    this.price = const Value.absent(),
  });
  BulkDealsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int qty,
    required double price,
  }) : name = Value(name),
       qty = Value(qty),
       price = Value(price);
  static Insertable<BulkDeal> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? qty,
    Expression<double>? price,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (qty != null) 'qty': qty,
      if (price != null) 'price': price,
    });
  }

  BulkDealsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? qty,
    Value<double>? price,
  }) {
    return BulkDealsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      qty: qty ?? this.qty,
      price: price ?? this.price,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BulkDealsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('qty: $qty, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _contributorMeta = const VerificationMeta(
    'contributor',
  );
  @override
  late final GeneratedColumn<String> contributor = GeneratedColumn<String>(
    'contributor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fandomMeta = const VerificationMeta('fandom');
  @override
  late final GeneratedColumn<String> fandom = GeneratedColumn<String>(
    'fandom',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _picturePathMeta = const VerificationMeta(
    'picturePath',
  );
  @override
  late final GeneratedColumn<String> picturePath = GeneratedColumn<String>(
    'picture_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bulkDealIdMeta = const VerificationMeta(
    'bulkDealId',
  );
  @override
  late final GeneratedColumn<int> bulkDealId = GeneratedColumn<int>(
    'bulk_deal_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bulk_deals (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    price,
    stock,
    contributor,
    fandom,
    category,
    picturePath,
    discount,
    bulkDealId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(
    Insertable<Item> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    }
    if (data.containsKey('contributor')) {
      context.handle(
        _contributorMeta,
        contributor.isAcceptableOrUnknown(
          data['contributor']!,
          _contributorMeta,
        ),
      );
    }
    if (data.containsKey('fandom')) {
      context.handle(
        _fandomMeta,
        fandom.isAcceptableOrUnknown(data['fandom']!, _fandomMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('picture_path')) {
      context.handle(
        _picturePathMeta,
        picturePath.isAcceptableOrUnknown(
          data['picture_path']!,
          _picturePathMeta,
        ),
      );
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('bulk_deal_id')) {
      context.handle(
        _bulkDealIdMeta,
        bulkDealId.isAcceptableOrUnknown(
          data['bulk_deal_id']!,
          _bulkDealIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock'],
      )!,
      contributor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contributor'],
      ),
      fandom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fandom'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      picturePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}picture_path'],
      ),
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount'],
      )!,
      bulkDealId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bulk_deal_id'],
      ),
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class Item extends DataClass implements Insertable<Item> {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String? contributor;
  final String? fandom;
  final String? category;
  final String? picturePath;
  final double discount;
  final int? bulkDealId;
  const Item({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.contributor,
    this.fandom,
    this.category,
    this.picturePath,
    required this.discount,
    this.bulkDealId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['stock'] = Variable<int>(stock);
    if (!nullToAbsent || contributor != null) {
      map['contributor'] = Variable<String>(contributor);
    }
    if (!nullToAbsent || fandom != null) {
      map['fandom'] = Variable<String>(fandom);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || picturePath != null) {
      map['picture_path'] = Variable<String>(picturePath);
    }
    map['discount'] = Variable<double>(discount);
    if (!nullToAbsent || bulkDealId != null) {
      map['bulk_deal_id'] = Variable<int>(bulkDealId);
    }
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      name: Value(name),
      price: Value(price),
      stock: Value(stock),
      contributor: contributor == null && nullToAbsent
          ? const Value.absent()
          : Value(contributor),
      fandom: fandom == null && nullToAbsent
          ? const Value.absent()
          : Value(fandom),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      picturePath: picturePath == null && nullToAbsent
          ? const Value.absent()
          : Value(picturePath),
      discount: Value(discount),
      bulkDealId: bulkDealId == null && nullToAbsent
          ? const Value.absent()
          : Value(bulkDealId),
    );
  }

  factory Item.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      stock: serializer.fromJson<int>(json['stock']),
      contributor: serializer.fromJson<String?>(json['contributor']),
      fandom: serializer.fromJson<String?>(json['fandom']),
      category: serializer.fromJson<String?>(json['category']),
      picturePath: serializer.fromJson<String?>(json['picturePath']),
      discount: serializer.fromJson<double>(json['discount']),
      bulkDealId: serializer.fromJson<int?>(json['bulkDealId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'stock': serializer.toJson<int>(stock),
      'contributor': serializer.toJson<String?>(contributor),
      'fandom': serializer.toJson<String?>(fandom),
      'category': serializer.toJson<String?>(category),
      'picturePath': serializer.toJson<String?>(picturePath),
      'discount': serializer.toJson<double>(discount),
      'bulkDealId': serializer.toJson<int?>(bulkDealId),
    };
  }

  Item copyWith({
    int? id,
    String? name,
    double? price,
    int? stock,
    Value<String?> contributor = const Value.absent(),
    Value<String?> fandom = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<String?> picturePath = const Value.absent(),
    double? discount,
    Value<int?> bulkDealId = const Value.absent(),
  }) => Item(
    id: id ?? this.id,
    name: name ?? this.name,
    price: price ?? this.price,
    stock: stock ?? this.stock,
    contributor: contributor.present ? contributor.value : this.contributor,
    fandom: fandom.present ? fandom.value : this.fandom,
    category: category.present ? category.value : this.category,
    picturePath: picturePath.present ? picturePath.value : this.picturePath,
    discount: discount ?? this.discount,
    bulkDealId: bulkDealId.present ? bulkDealId.value : this.bulkDealId,
  );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      stock: data.stock.present ? data.stock.value : this.stock,
      contributor: data.contributor.present
          ? data.contributor.value
          : this.contributor,
      fandom: data.fandom.present ? data.fandom.value : this.fandom,
      category: data.category.present ? data.category.value : this.category,
      picturePath: data.picturePath.present
          ? data.picturePath.value
          : this.picturePath,
      discount: data.discount.present ? data.discount.value : this.discount,
      bulkDealId: data.bulkDealId.present
          ? data.bulkDealId.value
          : this.bulkDealId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('stock: $stock, ')
          ..write('contributor: $contributor, ')
          ..write('fandom: $fandom, ')
          ..write('category: $category, ')
          ..write('picturePath: $picturePath, ')
          ..write('discount: $discount, ')
          ..write('bulkDealId: $bulkDealId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    price,
    stock,
    contributor,
    fandom,
    category,
    picturePath,
    discount,
    bulkDealId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.name == this.name &&
          other.price == this.price &&
          other.stock == this.stock &&
          other.contributor == this.contributor &&
          other.fandom == this.fandom &&
          other.category == this.category &&
          other.picturePath == this.picturePath &&
          other.discount == this.discount &&
          other.bulkDealId == this.bulkDealId);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> price;
  final Value<int> stock;
  final Value<String?> contributor;
  final Value<String?> fandom;
  final Value<String?> category;
  final Value<String?> picturePath;
  final Value<double> discount;
  final Value<int?> bulkDealId;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.stock = const Value.absent(),
    this.contributor = const Value.absent(),
    this.fandom = const Value.absent(),
    this.category = const Value.absent(),
    this.picturePath = const Value.absent(),
    this.discount = const Value.absent(),
    this.bulkDealId = const Value.absent(),
  });
  ItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double price,
    this.stock = const Value.absent(),
    this.contributor = const Value.absent(),
    this.fandom = const Value.absent(),
    this.category = const Value.absent(),
    this.picturePath = const Value.absent(),
    this.discount = const Value.absent(),
    this.bulkDealId = const Value.absent(),
  }) : name = Value(name),
       price = Value(price);
  static Insertable<Item> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? price,
    Expression<int>? stock,
    Expression<String>? contributor,
    Expression<String>? fandom,
    Expression<String>? category,
    Expression<String>? picturePath,
    Expression<double>? discount,
    Expression<int>? bulkDealId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (stock != null) 'stock': stock,
      if (contributor != null) 'contributor': contributor,
      if (fandom != null) 'fandom': fandom,
      if (category != null) 'category': category,
      if (picturePath != null) 'picture_path': picturePath,
      if (discount != null) 'discount': discount,
      if (bulkDealId != null) 'bulk_deal_id': bulkDealId,
    });
  }

  ItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? price,
    Value<int>? stock,
    Value<String?>? contributor,
    Value<String?>? fandom,
    Value<String?>? category,
    Value<String?>? picturePath,
    Value<double>? discount,
    Value<int?>? bulkDealId,
  }) {
    return ItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      contributor: contributor ?? this.contributor,
      fandom: fandom ?? this.fandom,
      category: category ?? this.category,
      picturePath: picturePath ?? this.picturePath,
      discount: discount ?? this.discount,
      bulkDealId: bulkDealId ?? this.bulkDealId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    if (contributor.present) {
      map['contributor'] = Variable<String>(contributor.value);
    }
    if (fandom.present) {
      map['fandom'] = Variable<String>(fandom.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (picturePath.present) {
      map['picture_path'] = Variable<String>(picturePath.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (bulkDealId.present) {
      map['bulk_deal_id'] = Variable<int>(bulkDealId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('stock: $stock, ')
          ..write('contributor: $contributor, ')
          ..write('fandom: $fandom, ')
          ..write('category: $category, ')
          ..write('picturePath: $picturePath, ')
          ..write('discount: $discount, ')
          ..write('bulkDealId: $bulkDealId')
          ..write(')'))
        .toString();
  }
}

class $ProductionCostsTable extends ProductionCosts
    with TableInfo<$ProductionCostsTable, ProductionCost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductionCostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _particularMeta = const VerificationMeta(
    'particular',
  );
  @override
  late final GeneratedColumn<String> particular = GeneratedColumn<String>(
    'particular',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startDate,
    endDate,
    particular,
    qty,
    amount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'production_costs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductionCost> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('particular')) {
      context.handle(
        _particularMeta,
        particular.isAcceptableOrUnknown(data['particular']!, _particularMeta),
      );
    } else if (isInserting) {
      context.missing(_particularMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductionCost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductionCost(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      particular: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}particular'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
    );
  }

  @override
  $ProductionCostsTable createAlias(String alias) {
    return $ProductionCostsTable(attachedDatabase, alias);
  }
}

class ProductionCost extends DataClass implements Insertable<ProductionCost> {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final String particular;
  final int qty;
  final double amount;
  const ProductionCost({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.particular,
    required this.qty,
    required this.amount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['particular'] = Variable<String>(particular);
    map['qty'] = Variable<int>(qty);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  ProductionCostsCompanion toCompanion(bool nullToAbsent) {
    return ProductionCostsCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: Value(endDate),
      particular: Value(particular),
      qty: Value(qty),
      amount: Value(amount),
    );
  }

  factory ProductionCost.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductionCost(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      particular: serializer.fromJson<String>(json['particular']),
      qty: serializer.fromJson<int>(json['qty']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'particular': serializer.toJson<String>(particular),
      'qty': serializer.toJson<int>(qty),
      'amount': serializer.toJson<double>(amount),
    };
  }

  ProductionCost copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    String? particular,
    int? qty,
    double? amount,
  }) => ProductionCost(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    particular: particular ?? this.particular,
    qty: qty ?? this.qty,
    amount: amount ?? this.amount,
  );
  ProductionCost copyWithCompanion(ProductionCostsCompanion data) {
    return ProductionCost(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      particular: data.particular.present
          ? data.particular.value
          : this.particular,
      qty: data.qty.present ? data.qty.value : this.qty,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductionCost(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('particular: $particular, ')
          ..write('qty: $qty, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, startDate, endDate, particular, qty, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductionCost &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.particular == this.particular &&
          other.qty == this.qty &&
          other.amount == this.amount);
}

class ProductionCostsCompanion extends UpdateCompanion<ProductionCost> {
  final Value<int> id;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String> particular;
  final Value<int> qty;
  final Value<double> amount;
  const ProductionCostsCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.particular = const Value.absent(),
    this.qty = const Value.absent(),
    this.amount = const Value.absent(),
  });
  ProductionCostsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    required String particular,
    this.qty = const Value.absent(),
    required double amount,
  }) : startDate = Value(startDate),
       endDate = Value(endDate),
       particular = Value(particular),
       amount = Value(amount);
  static Insertable<ProductionCost> custom({
    Expression<int>? id,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? particular,
    Expression<int>? qty,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (particular != null) 'particular': particular,
      if (qty != null) 'qty': qty,
      if (amount != null) 'amount': amount,
    });
  }

  ProductionCostsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<String>? particular,
    Value<int>? qty,
    Value<double>? amount,
  }) {
    return ProductionCostsCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      particular: particular ?? this.particular,
      qty: qty ?? this.qty,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (particular.present) {
      map['particular'] = Variable<String>(particular.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductionCostsCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('particular: $particular, ')
          ..write('qty: $qty, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $EarningsTable extends Earnings with TableInfo<$EarningsTable, Earning> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EarningsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Manual'),
  );
  static const VerificationMeta _receiptIdMeta = const VerificationMeta(
    'receiptId',
  );
  @override
  late final GeneratedColumn<String> receiptId = GeneratedColumn<String>(
    'receipt_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startDate,
    endDate,
    amount,
    source,
    receiptId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'earnings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Earning> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('receipt_id')) {
      context.handle(
        _receiptIdMeta,
        receiptId.isAcceptableOrUnknown(data['receipt_id']!, _receiptIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Earning map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Earning(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      receiptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_id'],
      ),
    );
  }

  @override
  $EarningsTable createAlias(String alias) {
    return $EarningsTable(attachedDatabase, alias);
  }
}

class Earning extends DataClass implements Insertable<Earning> {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final double amount;
  final String source;
  final String? receiptId;
  const Earning({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.amount,
    required this.source,
    this.receiptId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['amount'] = Variable<double>(amount);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || receiptId != null) {
      map['receipt_id'] = Variable<String>(receiptId);
    }
    return map;
  }

  EarningsCompanion toCompanion(bool nullToAbsent) {
    return EarningsCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: Value(endDate),
      amount: Value(amount),
      source: Value(source),
      receiptId: receiptId == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptId),
    );
  }

  factory Earning.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Earning(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      amount: serializer.fromJson<double>(json['amount']),
      source: serializer.fromJson<String>(json['source']),
      receiptId: serializer.fromJson<String?>(json['receiptId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'amount': serializer.toJson<double>(amount),
      'source': serializer.toJson<String>(source),
      'receiptId': serializer.toJson<String?>(receiptId),
    };
  }

  Earning copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    double? amount,
    String? source,
    Value<String?> receiptId = const Value.absent(),
  }) => Earning(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    amount: amount ?? this.amount,
    source: source ?? this.source,
    receiptId: receiptId.present ? receiptId.value : this.receiptId,
  );
  Earning copyWithCompanion(EarningsCompanion data) {
    return Earning(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      amount: data.amount.present ? data.amount.value : this.amount,
      source: data.source.present ? data.source.value : this.source,
      receiptId: data.receiptId.present ? data.receiptId.value : this.receiptId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Earning(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('amount: $amount, ')
          ..write('source: $source, ')
          ..write('receiptId: $receiptId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, startDate, endDate, amount, source, receiptId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Earning &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.amount == this.amount &&
          other.source == this.source &&
          other.receiptId == this.receiptId);
}

class EarningsCompanion extends UpdateCompanion<Earning> {
  final Value<int> id;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<double> amount;
  final Value<String> source;
  final Value<String?> receiptId;
  const EarningsCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.amount = const Value.absent(),
    this.source = const Value.absent(),
    this.receiptId = const Value.absent(),
  });
  EarningsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    required double amount,
    this.source = const Value.absent(),
    this.receiptId = const Value.absent(),
  }) : startDate = Value(startDate),
       endDate = Value(endDate),
       amount = Value(amount);
  static Insertable<Earning> custom({
    Expression<int>? id,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<double>? amount,
    Expression<String>? source,
    Expression<String>? receiptId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (amount != null) 'amount': amount,
      if (source != null) 'source': source,
      if (receiptId != null) 'receipt_id': receiptId,
    });
  }

  EarningsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<double>? amount,
    Value<String>? source,
    Value<String?>? receiptId,
  }) {
    return EarningsCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      amount: amount ?? this.amount,
      source: source ?? this.source,
      receiptId: receiptId ?? this.receiptId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (receiptId.present) {
      map['receipt_id'] = Variable<String>(receiptId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EarningsCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('amount: $amount, ')
          ..write('source: $source, ')
          ..write('receiptId: $receiptId')
          ..write(')'))
        .toString();
  }
}

class $ReceiptsTable extends Receipts with TableInfo<$ReceiptsTable, Receipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _receiptNumberMeta = const VerificationMeta(
    'receiptNumber',
  );
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
    'receipt_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    receiptNumber,
    createdAt,
    paymentMethod,
    total,
    itemsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receipts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Receipt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
        _receiptNumberMeta,
        receiptNumber.isAcceptableOrUnknown(
          data['receipt_number']!,
          _receiptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiptNumberMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Receipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Receipt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      receiptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_number'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
    );
  }

  @override
  $ReceiptsTable createAlias(String alias) {
    return $ReceiptsTable(attachedDatabase, alias);
  }
}

class Receipt extends DataClass implements Insertable<Receipt> {
  final int id;
  final String receiptNumber;
  final DateTime createdAt;
  final String paymentMethod;
  final double total;
  final String itemsJson;
  const Receipt({
    required this.id,
    required this.receiptNumber,
    required this.createdAt,
    required this.paymentMethod,
    required this.total,
    required this.itemsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['receipt_number'] = Variable<String>(receiptNumber);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['total'] = Variable<double>(total);
    map['items_json'] = Variable<String>(itemsJson);
    return map;
  }

  ReceiptsCompanion toCompanion(bool nullToAbsent) {
    return ReceiptsCompanion(
      id: Value(id),
      receiptNumber: Value(receiptNumber),
      createdAt: Value(createdAt),
      paymentMethod: Value(paymentMethod),
      total: Value(total),
      itemsJson: Value(itemsJson),
    );
  }

  factory Receipt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Receipt(
      id: serializer.fromJson<int>(json['id']),
      receiptNumber: serializer.fromJson<String>(json['receiptNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      total: serializer.fromJson<double>(json['total']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'receiptNumber': serializer.toJson<String>(receiptNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'total': serializer.toJson<double>(total),
      'itemsJson': serializer.toJson<String>(itemsJson),
    };
  }

  Receipt copyWith({
    int? id,
    String? receiptNumber,
    DateTime? createdAt,
    String? paymentMethod,
    double? total,
    String? itemsJson,
  }) => Receipt(
    id: id ?? this.id,
    receiptNumber: receiptNumber ?? this.receiptNumber,
    createdAt: createdAt ?? this.createdAt,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    total: total ?? this.total,
    itemsJson: itemsJson ?? this.itemsJson,
  );
  Receipt copyWithCompanion(ReceiptsCompanion data) {
    return Receipt(
      id: data.id.present ? data.id.value : this.id,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      total: data.total.present ? data.total.value : this.total,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Receipt(')
          ..write('id: $id, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('total: $total, ')
          ..write('itemsJson: $itemsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    receiptNumber,
    createdAt,
    paymentMethod,
    total,
    itemsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Receipt &&
          other.id == this.id &&
          other.receiptNumber == this.receiptNumber &&
          other.createdAt == this.createdAt &&
          other.paymentMethod == this.paymentMethod &&
          other.total == this.total &&
          other.itemsJson == this.itemsJson);
}

class ReceiptsCompanion extends UpdateCompanion<Receipt> {
  final Value<int> id;
  final Value<String> receiptNumber;
  final Value<DateTime> createdAt;
  final Value<String> paymentMethod;
  final Value<double> total;
  final Value<String> itemsJson;
  const ReceiptsCompanion({
    this.id = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.total = const Value.absent(),
    this.itemsJson = const Value.absent(),
  });
  ReceiptsCompanion.insert({
    this.id = const Value.absent(),
    required String receiptNumber,
    required DateTime createdAt,
    required String paymentMethod,
    required double total,
    required String itemsJson,
  }) : receiptNumber = Value(receiptNumber),
       createdAt = Value(createdAt),
       paymentMethod = Value(paymentMethod),
       total = Value(total),
       itemsJson = Value(itemsJson);
  static Insertable<Receipt> custom({
    Expression<int>? id,
    Expression<String>? receiptNumber,
    Expression<DateTime>? createdAt,
    Expression<String>? paymentMethod,
    Expression<double>? total,
    Expression<String>? itemsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (createdAt != null) 'created_at': createdAt,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (total != null) 'total': total,
      if (itemsJson != null) 'items_json': itemsJson,
    });
  }

  ReceiptsCompanion copyWith({
    Value<int>? id,
    Value<String>? receiptNumber,
    Value<DateTime>? createdAt,
    Value<String>? paymentMethod,
    Value<double>? total,
    Value<String>? itemsJson,
  }) {
    return ReceiptsCompanion(
      id: id ?? this.id,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      createdAt: createdAt ?? this.createdAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      total: total ?? this.total,
      itemsJson: itemsJson ?? this.itemsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptsCompanion(')
          ..write('id: $id, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('total: $total, ')
          ..write('itemsJson: $itemsJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsEntriesTable settingsEntries = $SettingsEntriesTable(
    this,
  );
  late final $BulkDealsTable bulkDeals = $BulkDealsTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $ProductionCostsTable productionCosts = $ProductionCostsTable(
    this,
  );
  late final $EarningsTable earnings = $EarningsTable(this);
  late final $ReceiptsTable receipts = $ReceiptsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settingsEntries,
    bulkDeals,
    items,
    productionCosts,
    earnings,
    receipts,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bulk_deals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('items', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$SettingsEntriesTableCreateCompanionBuilder =
    SettingsEntriesCompanion Function({
      Value<int> id,
      required String listType,
      required String value,
    });
typedef $$SettingsEntriesTableUpdateCompanionBuilder =
    SettingsEntriesCompanion Function({
      Value<int> id,
      Value<String> listType,
      Value<String> value,
    });

class $$SettingsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get listType => $composableBuilder(
    column: $table.listType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get listType => $composableBuilder(
    column: $table.listType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get listType =>
      $composableBuilder(column: $table.listType, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsEntriesTable,
          SettingsEntry,
          $$SettingsEntriesTableFilterComposer,
          $$SettingsEntriesTableOrderingComposer,
          $$SettingsEntriesTableAnnotationComposer,
          $$SettingsEntriesTableCreateCompanionBuilder,
          $$SettingsEntriesTableUpdateCompanionBuilder,
          (
            SettingsEntry,
            BaseReferences<_$AppDatabase, $SettingsEntriesTable, SettingsEntry>,
          ),
          SettingsEntry,
          PrefetchHooks Function()
        > {
  $$SettingsEntriesTableTableManager(
    _$AppDatabase db,
    $SettingsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> listType = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => SettingsEntriesCompanion(
                id: id,
                listType: listType,
                value: value,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String listType,
                required String value,
              }) => SettingsEntriesCompanion.insert(
                id: id,
                listType: listType,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsEntriesTable, SettingsEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SettingsEntriesTable,
                    SettingsEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsEntriesTable,
      SettingsEntry,
      $$SettingsEntriesTableFilterComposer,
      $$SettingsEntriesTableOrderingComposer,
      $$SettingsEntriesTableAnnotationComposer,
      $$SettingsEntriesTableCreateCompanionBuilder,
      $$SettingsEntriesTableUpdateCompanionBuilder,
      (
        SettingsEntry,
        BaseReferences<_$AppDatabase, $SettingsEntriesTable, SettingsEntry>,
      ),
      SettingsEntry,
      PrefetchHooks Function()
    >;
typedef $$BulkDealsTableCreateCompanionBuilder = BulkDealsCompanion Function({
  Value<int> id,
  required String name,
  required int qty,
  required double price,
});
typedef $$BulkDealsTableUpdateCompanionBuilder = BulkDealsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> qty,
  Value<double> price,
});

final class $$BulkDealsTableReferences
    extends BaseReferences<_$AppDatabase, $BulkDealsTable, BulkDeal> {
  $$BulkDealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItemsTable, List<Item>> _itemsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.items,
    aliasName: 'bulk_deals__id__items__bulk_deal_id',
  );

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.bulkDealId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BulkDealsTableFilterComposer
    extends Composer<_$AppDatabase, $BulkDealsTable> {
  $$BulkDealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> itemsRefs(
    Expression<bool> Function($$ItemsTableFilterComposer f) f,
  ) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.bulkDealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BulkDealsTableOrderingComposer
    extends Composer<_$AppDatabase, $BulkDealsTable> {
  $$BulkDealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BulkDealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BulkDealsTable> {
  $$BulkDealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  Expression<T> itemsRefs<T extends Object>(
    Expression<T> Function($$ItemsTableAnnotationComposer a) f,
  ) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.bulkDealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BulkDealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BulkDealsTable,
          BulkDeal,
          $$BulkDealsTableFilterComposer,
          $$BulkDealsTableOrderingComposer,
          $$BulkDealsTableAnnotationComposer,
          $$BulkDealsTableCreateCompanionBuilder,
          $$BulkDealsTableUpdateCompanionBuilder,
          (BulkDeal, $$BulkDealsTableReferences),
          BulkDeal,
          PrefetchHooks Function({bool itemsRefs})
        > {
  $$BulkDealsTableTableManager(_$AppDatabase db, $BulkDealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BulkDealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BulkDealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BulkDealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> qty = const Value.absent(),
            Value<double> price = const Value.absent(),
          }) => BulkDealsCompanion(id: id, name: name, qty: qty, price: price),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int qty,
                required double price,
              }) => BulkDealsCompanion.insert(
                id: id,
                name: name,
                qty: qty,
                price: price,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BulkDealsTable, BulkDeal>(table),
                  $$BulkDealsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itemsRefs) db.items],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemsRefs)
                    await $_getPrefetchedData<BulkDeal, $BulkDealsTable, Item>(
                      currentTable: table,
                      referencedTable: $$BulkDealsTableReferences
                          ._itemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BulkDealsTableReferences(db, table, p0).itemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.bulkDealId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BulkDealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BulkDealsTable,
      BulkDeal,
      $$BulkDealsTableFilterComposer,
      $$BulkDealsTableOrderingComposer,
      $$BulkDealsTableAnnotationComposer,
      $$BulkDealsTableCreateCompanionBuilder,
      $$BulkDealsTableUpdateCompanionBuilder,
      (BulkDeal, $$BulkDealsTableReferences),
      BulkDeal,
      PrefetchHooks Function({bool itemsRefs})
    >;
typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  Value<int> id,
  required String name,
  required double price,
  Value<int> stock,
  Value<String?> contributor,
  Value<String?> fandom,
  Value<String?> category,
  Value<String?> picturePath,
  Value<double> discount,
  Value<int?> bulkDealId,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> price,
  Value<int> stock,
  Value<String?> contributor,
  Value<String?> fandom,
  Value<String?> category,
  Value<String?> picturePath,
  Value<double> discount,
  Value<int?> bulkDealId,
});

final class $$ItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsTable, Item> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BulkDealsTable _bulkDealIdTable(_$AppDatabase db) =>
      db.bulkDeals.createAlias('items__bulk_deal_id__bulk_deals__id');

  $$BulkDealsTableProcessedTableManager? get bulkDealId {
    final $_column = $_itemColumn<int>('bulk_deal_id');
    if ($_column == null) return null;
    final manager = $$BulkDealsTableTableManager(
      $_db,
      $_db.bulkDeals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bulkDealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contributor => $composableBuilder(
    column: $table.contributor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fandom => $composableBuilder(
    column: $table.fandom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get picturePath => $composableBuilder(
    column: $table.picturePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  $$BulkDealsTableFilterComposer get bulkDealId {
    final $$BulkDealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bulkDealId,
      referencedTable: $db.bulkDeals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BulkDealsTableFilterComposer(
            $db: $db,
            $table: $db.bulkDeals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contributor => $composableBuilder(
    column: $table.contributor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fandom => $composableBuilder(
    column: $table.fandom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get picturePath => $composableBuilder(
    column: $table.picturePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  $$BulkDealsTableOrderingComposer get bulkDealId {
    final $$BulkDealsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bulkDealId,
      referencedTable: $db.bulkDeals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BulkDealsTableOrderingComposer(
            $db: $db,
            $table: $db.bulkDeals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<String> get contributor => $composableBuilder(
    column: $table.contributor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fandom =>
      $composableBuilder(column: $table.fandom, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get picturePath => $composableBuilder(
    column: $table.picturePath,
    builder: (column) => column,
  );

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  $$BulkDealsTableAnnotationComposer get bulkDealId {
    final $$BulkDealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bulkDealId,
      referencedTable: $db.bulkDeals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BulkDealsTableAnnotationComposer(
            $db: $db,
            $table: $db.bulkDeals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemsTable,
          Item,
          $$ItemsTableFilterComposer,
          $$ItemsTableOrderingComposer,
          $$ItemsTableAnnotationComposer,
          $$ItemsTableCreateCompanionBuilder,
          $$ItemsTableUpdateCompanionBuilder,
          (Item, $$ItemsTableReferences),
          Item,
          PrefetchHooks Function({bool bulkDealId})
        > {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> stock = const Value.absent(),
                Value<String?> contributor = const Value.absent(),
                Value<String?> fandom = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> picturePath = const Value.absent(),
                Value<double> discount = const Value.absent(),
                Value<int?> bulkDealId = const Value.absent(),
              }) => ItemsCompanion(
                id: id,
                name: name,
                price: price,
                stock: stock,
                contributor: contributor,
                fandom: fandom,
                category: category,
                picturePath: picturePath,
                discount: discount,
                bulkDealId: bulkDealId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double price,
                Value<int> stock = const Value.absent(),
                Value<String?> contributor = const Value.absent(),
                Value<String?> fandom = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> picturePath = const Value.absent(),
                Value<double> discount = const Value.absent(),
                Value<int?> bulkDealId = const Value.absent(),
              }) => ItemsCompanion.insert(
                id: id,
                name: name,
                price: price,
                stock: stock,
                contributor: contributor,
                fandom: fandom,
                category: category,
                picturePath: picturePath,
                discount: discount,
                bulkDealId: bulkDealId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemsTable, Item>(table),
                  $$ItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bulkDealId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bulkDealId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.bulkDealId,
                        referencedTable: $$ItemsTableReferences
                            ._bulkDealIdTable(db),
                        referencedColumn: $$ItemsTableReferences
                            ._bulkDealIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemsTable,
      Item,
      $$ItemsTableFilterComposer,
      $$ItemsTableOrderingComposer,
      $$ItemsTableAnnotationComposer,
      $$ItemsTableCreateCompanionBuilder,
      $$ItemsTableUpdateCompanionBuilder,
      (Item, $$ItemsTableReferences),
      Item,
      PrefetchHooks Function({bool bulkDealId})
    >;
typedef $$ProductionCostsTableCreateCompanionBuilder =
    ProductionCostsCompanion Function({
      Value<int> id,
      required DateTime startDate,
      required DateTime endDate,
      required String particular,
      Value<int> qty,
      required double amount,
    });
typedef $$ProductionCostsTableUpdateCompanionBuilder =
    ProductionCostsCompanion Function({
      Value<int> id,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<String> particular,
      Value<int> qty,
      Value<double> amount,
    });

class $$ProductionCostsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductionCostsTable> {
  $$ProductionCostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get particular => $composableBuilder(
    column: $table.particular,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductionCostsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductionCostsTable> {
  $$ProductionCostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get particular => $composableBuilder(
    column: $table.particular,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductionCostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductionCostsTable> {
  $$ProductionCostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get particular => $composableBuilder(
    column: $table.particular,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);
}

class $$ProductionCostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductionCostsTable,
          ProductionCost,
          $$ProductionCostsTableFilterComposer,
          $$ProductionCostsTableOrderingComposer,
          $$ProductionCostsTableAnnotationComposer,
          $$ProductionCostsTableCreateCompanionBuilder,
          $$ProductionCostsTableUpdateCompanionBuilder,
          (
            ProductionCost,
            BaseReferences<
              _$AppDatabase,
              $ProductionCostsTable,
              ProductionCost
            >,
          ),
          ProductionCost,
          PrefetchHooks Function()
        > {
  $$ProductionCostsTableTableManager(
    _$AppDatabase db,
    $ProductionCostsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductionCostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductionCostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductionCostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String> particular = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<double> amount = const Value.absent(),
              }) => ProductionCostsCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
                particular: particular,
                qty: qty,
                amount: amount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                required String particular,
                Value<int> qty = const Value.absent(),
                required double amount,
              }) => ProductionCostsCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
                particular: particular,
                qty: qty,
                amount: amount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductionCostsTable, ProductionCost>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ProductionCostsTable,
                    ProductionCost
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductionCostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductionCostsTable,
      ProductionCost,
      $$ProductionCostsTableFilterComposer,
      $$ProductionCostsTableOrderingComposer,
      $$ProductionCostsTableAnnotationComposer,
      $$ProductionCostsTableCreateCompanionBuilder,
      $$ProductionCostsTableUpdateCompanionBuilder,
      (
        ProductionCost,
        BaseReferences<_$AppDatabase, $ProductionCostsTable, ProductionCost>,
      ),
      ProductionCost,
      PrefetchHooks Function()
    >;
typedef $$EarningsTableCreateCompanionBuilder = EarningsCompanion Function({
  Value<int> id,
  required DateTime startDate,
  required DateTime endDate,
  required double amount,
  Value<String> source,
  Value<String?> receiptId,
});
typedef $$EarningsTableUpdateCompanionBuilder = EarningsCompanion Function({
  Value<int> id,
  Value<DateTime> startDate,
  Value<DateTime> endDate,
  Value<double> amount,
  Value<String> source,
  Value<String?> receiptId,
});

class $$EarningsTableFilterComposer
    extends Composer<_$AppDatabase, $EarningsTable> {
  $$EarningsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptId => $composableBuilder(
    column: $table.receiptId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EarningsTableOrderingComposer
    extends Composer<_$AppDatabase, $EarningsTable> {
  $$EarningsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptId => $composableBuilder(
    column: $table.receiptId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EarningsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EarningsTable> {
  $$EarningsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get receiptId =>
      $composableBuilder(column: $table.receiptId, builder: (column) => column);
}

class $$EarningsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EarningsTable,
          Earning,
          $$EarningsTableFilterComposer,
          $$EarningsTableOrderingComposer,
          $$EarningsTableAnnotationComposer,
          $$EarningsTableCreateCompanionBuilder,
          $$EarningsTableUpdateCompanionBuilder,
          (Earning, BaseReferences<_$AppDatabase, $EarningsTable, Earning>),
          Earning,
          PrefetchHooks Function()
        > {
  $$EarningsTableTableManager(_$AppDatabase db, $EarningsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EarningsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EarningsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EarningsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> receiptId = const Value.absent(),
              }) => EarningsCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
                amount: amount,
                source: source,
                receiptId: receiptId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                required double amount,
                Value<String> source = const Value.absent(),
                Value<String?> receiptId = const Value.absent(),
              }) => EarningsCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
                amount: amount,
                source: source,
                receiptId: receiptId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EarningsTable, Earning>(table),
                  BaseReferences<_$AppDatabase, $EarningsTable, Earning>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EarningsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EarningsTable,
      Earning,
      $$EarningsTableFilterComposer,
      $$EarningsTableOrderingComposer,
      $$EarningsTableAnnotationComposer,
      $$EarningsTableCreateCompanionBuilder,
      $$EarningsTableUpdateCompanionBuilder,
      (Earning, BaseReferences<_$AppDatabase, $EarningsTable, Earning>),
      Earning,
      PrefetchHooks Function()
    >;
typedef $$ReceiptsTableCreateCompanionBuilder = ReceiptsCompanion Function({
  Value<int> id,
  required String receiptNumber,
  required DateTime createdAt,
  required String paymentMethod,
  required double total,
  required String itemsJson,
});
typedef $$ReceiptsTableUpdateCompanionBuilder = ReceiptsCompanion Function({
  Value<int> id,
  Value<String> receiptNumber,
  Value<DateTime> createdAt,
  Value<String> paymentMethod,
  Value<double> total,
  Value<String> itemsJson,
});

class $$ReceiptsTableFilterComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReceiptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReceiptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);
}

class $$ReceiptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReceiptsTable,
          Receipt,
          $$ReceiptsTableFilterComposer,
          $$ReceiptsTableOrderingComposer,
          $$ReceiptsTableAnnotationComposer,
          $$ReceiptsTableCreateCompanionBuilder,
          $$ReceiptsTableUpdateCompanionBuilder,
          (Receipt, BaseReferences<_$AppDatabase, $ReceiptsTable, Receipt>),
          Receipt,
          PrefetchHooks Function()
        > {
  $$ReceiptsTableTableManager(_$AppDatabase db, $ReceiptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceiptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceiptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceiptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> receiptNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
              }) => ReceiptsCompanion(
                id: id,
                receiptNumber: receiptNumber,
                createdAt: createdAt,
                paymentMethod: paymentMethod,
                total: total,
                itemsJson: itemsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String receiptNumber,
                required DateTime createdAt,
                required String paymentMethod,
                required double total,
                required String itemsJson,
              }) => ReceiptsCompanion.insert(
                id: id,
                receiptNumber: receiptNumber,
                createdAt: createdAt,
                paymentMethod: paymentMethod,
                total: total,
                itemsJson: itemsJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReceiptsTable, Receipt>(table),
                  BaseReferences<_$AppDatabase, $ReceiptsTable, Receipt>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReceiptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReceiptsTable,
      Receipt,
      $$ReceiptsTableFilterComposer,
      $$ReceiptsTableOrderingComposer,
      $$ReceiptsTableAnnotationComposer,
      $$ReceiptsTableCreateCompanionBuilder,
      $$ReceiptsTableUpdateCompanionBuilder,
      (Receipt, BaseReferences<_$AppDatabase, $ReceiptsTable, Receipt>),
      Receipt,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsEntriesTableTableManager get settingsEntries =>
      $$SettingsEntriesTableTableManager(_db, _db.settingsEntries);
  $$BulkDealsTableTableManager get bulkDeals =>
      $$BulkDealsTableTableManager(_db, _db.bulkDeals);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$ProductionCostsTableTableManager get productionCosts =>
      $$ProductionCostsTableTableManager(_db, _db.productionCosts);
  $$EarningsTableTableManager get earnings =>
      $$EarningsTableTableManager(_db, _db.earnings);
  $$ReceiptsTableTableManager get receipts =>
      $$ReceiptsTableTableManager(_db, _db.receipts);
}
