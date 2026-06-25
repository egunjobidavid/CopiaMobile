// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $CachedProductsTable extends CachedProducts
    with TableInfo<$CachedProductsTable, CachedProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
      'sku', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _productTypeMeta =
      const VerificationMeta('productType');
  @override
  late final GeneratedColumn<String> productType = GeneratedColumn<String>(
      'product_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uomMeta = const VerificationMeta('uom');
  @override
  late final GeneratedColumn<String> uom = GeneratedColumn<String>(
      'uom', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _stockQuantityMeta =
      const VerificationMeta('stockQuantity');
  @override
  late final GeneratedColumn<double> stockQuantity = GeneratedColumn<double>(
      'stock_quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _jsonDataMeta =
      const VerificationMeta('jsonData');
  @override
  late final GeneratedColumn<String> jsonData = GeneratedColumn<String>(
      'json_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sku,
        name,
        description,
        unitPrice,
        productType,
        uom,
        isActive,
        stockQuantity,
        jsonData,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_products';
  @override
  VerificationContext validateIntegrity(Insertable<CachedProduct> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
          _skuMeta, sku.isAcceptableOrUnknown(data['sku']!, _skuMeta));
    } else if (isInserting) {
      context.missing(_skuMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('product_type')) {
      context.handle(
          _productTypeMeta,
          productType.isAcceptableOrUnknown(
              data['product_type']!, _productTypeMeta));
    } else if (isInserting) {
      context.missing(_productTypeMeta);
    }
    if (data.containsKey('uom')) {
      context.handle(
          _uomMeta, uom.isAcceptableOrUnknown(data['uom']!, _uomMeta));
    } else if (isInserting) {
      context.missing(_uomMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('stock_quantity')) {
      context.handle(
          _stockQuantityMeta,
          stockQuantity.isAcceptableOrUnknown(
              data['stock_quantity']!, _stockQuantityMeta));
    }
    if (data.containsKey('json_data')) {
      context.handle(_jsonDataMeta,
          jsonData.isAcceptableOrUnknown(data['json_data']!, _jsonDataMeta));
    } else if (isInserting) {
      context.missing(_jsonDataMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    } else if (isInserting) {
      context.missing(_syncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedProduct(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sku: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sku'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      productType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_type'])!,
      uom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uom'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      stockQuantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock_quantity'])!,
      jsonData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json_data'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at'])!,
    );
  }

  @override
  $CachedProductsTable createAlias(String alias) {
    return $CachedProductsTable(attachedDatabase, alias);
  }
}

class CachedProduct extends DataClass implements Insertable<CachedProduct> {
  final String id;
  final String sku;
  final String name;
  final String? description;
  final double unitPrice;
  final String productType;
  final String uom;
  final bool isActive;
  final double stockQuantity;
  final String jsonData;
  final DateTime syncedAt;
  const CachedProduct(
      {required this.id,
      required this.sku,
      required this.name,
      this.description,
      required this.unitPrice,
      required this.productType,
      required this.uom,
      required this.isActive,
      required this.stockQuantity,
      required this.jsonData,
      required this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sku'] = Variable<String>(sku);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['unit_price'] = Variable<double>(unitPrice);
    map['product_type'] = Variable<String>(productType);
    map['uom'] = Variable<String>(uom);
    map['is_active'] = Variable<bool>(isActive);
    map['stock_quantity'] = Variable<double>(stockQuantity);
    map['json_data'] = Variable<String>(jsonData);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  CachedProductsCompanion toCompanion(bool nullToAbsent) {
    return CachedProductsCompanion(
      id: Value(id),
      sku: Value(sku),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      unitPrice: Value(unitPrice),
      productType: Value(productType),
      uom: Value(uom),
      isActive: Value(isActive),
      stockQuantity: Value(stockQuantity),
      jsonData: Value(jsonData),
      syncedAt: Value(syncedAt),
    );
  }

  factory CachedProduct.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedProduct(
      id: serializer.fromJson<String>(json['id']),
      sku: serializer.fromJson<String>(json['sku']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      productType: serializer.fromJson<String>(json['productType']),
      uom: serializer.fromJson<String>(json['uom']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      stockQuantity: serializer.fromJson<double>(json['stockQuantity']),
      jsonData: serializer.fromJson<String>(json['jsonData']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sku': serializer.toJson<String>(sku),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'productType': serializer.toJson<String>(productType),
      'uom': serializer.toJson<String>(uom),
      'isActive': serializer.toJson<bool>(isActive),
      'stockQuantity': serializer.toJson<double>(stockQuantity),
      'jsonData': serializer.toJson<String>(jsonData),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  CachedProduct copyWith(
          {String? id,
          String? sku,
          String? name,
          Value<String?> description = const Value.absent(),
          double? unitPrice,
          String? productType,
          String? uom,
          bool? isActive,
          double? stockQuantity,
          String? jsonData,
          DateTime? syncedAt}) =>
      CachedProduct(
        id: id ?? this.id,
        sku: sku ?? this.sku,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        unitPrice: unitPrice ?? this.unitPrice,
        productType: productType ?? this.productType,
        uom: uom ?? this.uom,
        isActive: isActive ?? this.isActive,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        jsonData: jsonData ?? this.jsonData,
        syncedAt: syncedAt ?? this.syncedAt,
      );
  CachedProduct copyWithCompanion(CachedProductsCompanion data) {
    return CachedProduct(
      id: data.id.present ? data.id.value : this.id,
      sku: data.sku.present ? data.sku.value : this.sku,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      productType:
          data.productType.present ? data.productType.value : this.productType,
      uom: data.uom.present ? data.uom.value : this.uom,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      stockQuantity: data.stockQuantity.present
          ? data.stockQuantity.value
          : this.stockQuantity,
      jsonData: data.jsonData.present ? data.jsonData.value : this.jsonData,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedProduct(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('productType: $productType, ')
          ..write('uom: $uom, ')
          ..write('isActive: $isActive, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('jsonData: $jsonData, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sku, name, description, unitPrice,
      productType, uom, isActive, stockQuantity, jsonData, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedProduct &&
          other.id == this.id &&
          other.sku == this.sku &&
          other.name == this.name &&
          other.description == this.description &&
          other.unitPrice == this.unitPrice &&
          other.productType == this.productType &&
          other.uom == this.uom &&
          other.isActive == this.isActive &&
          other.stockQuantity == this.stockQuantity &&
          other.jsonData == this.jsonData &&
          other.syncedAt == this.syncedAt);
}

class CachedProductsCompanion extends UpdateCompanion<CachedProduct> {
  final Value<String> id;
  final Value<String> sku;
  final Value<String> name;
  final Value<String?> description;
  final Value<double> unitPrice;
  final Value<String> productType;
  final Value<String> uom;
  final Value<bool> isActive;
  final Value<double> stockQuantity;
  final Value<String> jsonData;
  final Value<DateTime> syncedAt;
  final Value<int> rowid;
  const CachedProductsCompanion({
    this.id = const Value.absent(),
    this.sku = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.productType = const Value.absent(),
    this.uom = const Value.absent(),
    this.isActive = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.jsonData = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedProductsCompanion.insert({
    required String id,
    required String sku,
    required String name,
    this.description = const Value.absent(),
    required double unitPrice,
    required String productType,
    required String uom,
    this.isActive = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    required String jsonData,
    required DateTime syncedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sku = Value(sku),
        name = Value(name),
        unitPrice = Value(unitPrice),
        productType = Value(productType),
        uom = Value(uom),
        jsonData = Value(jsonData),
        syncedAt = Value(syncedAt);
  static Insertable<CachedProduct> custom({
    Expression<String>? id,
    Expression<String>? sku,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? unitPrice,
    Expression<String>? productType,
    Expression<String>? uom,
    Expression<bool>? isActive,
    Expression<double>? stockQuantity,
    Expression<String>? jsonData,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sku != null) 'sku': sku,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (productType != null) 'product_type': productType,
      if (uom != null) 'uom': uom,
      if (isActive != null) 'is_active': isActive,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      if (jsonData != null) 'json_data': jsonData,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedProductsCompanion copyWith(
      {Value<String>? id,
      Value<String>? sku,
      Value<String>? name,
      Value<String?>? description,
      Value<double>? unitPrice,
      Value<String>? productType,
      Value<String>? uom,
      Value<bool>? isActive,
      Value<double>? stockQuantity,
      Value<String>? jsonData,
      Value<DateTime>? syncedAt,
      Value<int>? rowid}) {
    return CachedProductsCompanion(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      description: description ?? this.description,
      unitPrice: unitPrice ?? this.unitPrice,
      productType: productType ?? this.productType,
      uom: uom ?? this.uom,
      isActive: isActive ?? this.isActive,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      jsonData: jsonData ?? this.jsonData,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (productType.present) {
      map['product_type'] = Variable<String>(productType.value);
    }
    if (uom.present) {
      map['uom'] = Variable<String>(uom.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (stockQuantity.present) {
      map['stock_quantity'] = Variable<double>(stockQuantity.value);
    }
    if (jsonData.present) {
      map['json_data'] = Variable<String>(jsonData.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedProductsCompanion(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('productType: $productType, ')
          ..write('uom: $uom, ')
          ..write('isActive: $isActive, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('jsonData: $jsonData, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedCustomersTable extends CachedCustomers
    with TableInfo<$CachedCustomersTable, CachedCustomer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _jsonDataMeta =
      const VerificationMeta('jsonData');
  @override
  late final GeneratedColumn<String> jsonData = GeneratedColumn<String>(
      'json_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        firstName,
        lastName,
        email,
        phone,
        balance,
        isActive,
        jsonData,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_customers';
  @override
  VerificationContext validateIntegrity(Insertable<CachedCustomer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('json_data')) {
      context.handle(_jsonDataMeta,
          jsonData.isAcceptableOrUnknown(data['json_data']!, _jsonDataMeta));
    } else if (isInserting) {
      context.missing(_jsonDataMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    } else if (isInserting) {
      context.missing(_syncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCustomer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCustomer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      jsonData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json_data'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at'])!,
    );
  }

  @override
  $CachedCustomersTable createAlias(String alias) {
    return $CachedCustomersTable(attachedDatabase, alias);
  }
}

class CachedCustomer extends DataClass implements Insertable<CachedCustomer> {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final double balance;
  final bool isActive;
  final String jsonData;
  final DateTime syncedAt;
  const CachedCustomer(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.email,
      this.phone,
      required this.balance,
      required this.isActive,
      required this.jsonData,
      required this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['balance'] = Variable<double>(balance);
    map['is_active'] = Variable<bool>(isActive);
    map['json_data'] = Variable<String>(jsonData);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  CachedCustomersCompanion toCompanion(bool nullToAbsent) {
    return CachedCustomersCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      balance: Value(balance),
      isActive: Value(isActive),
      jsonData: Value(jsonData),
      syncedAt: Value(syncedAt),
    );
  }

  factory CachedCustomer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCustomer(
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      balance: serializer.fromJson<double>(json['balance']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      jsonData: serializer.fromJson<String>(json['jsonData']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'balance': serializer.toJson<double>(balance),
      'isActive': serializer.toJson<bool>(isActive),
      'jsonData': serializer.toJson<String>(jsonData),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  CachedCustomer copyWith(
          {String? id,
          String? firstName,
          String? lastName,
          Value<String?> email = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          double? balance,
          bool? isActive,
          String? jsonData,
          DateTime? syncedAt}) =>
      CachedCustomer(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email.present ? email.value : this.email,
        phone: phone.present ? phone.value : this.phone,
        balance: balance ?? this.balance,
        isActive: isActive ?? this.isActive,
        jsonData: jsonData ?? this.jsonData,
        syncedAt: syncedAt ?? this.syncedAt,
      );
  CachedCustomer copyWithCompanion(CachedCustomersCompanion data) {
    return CachedCustomer(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      balance: data.balance.present ? data.balance.value : this.balance,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      jsonData: data.jsonData.present ? data.jsonData.value : this.jsonData,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCustomer(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('balance: $balance, ')
          ..write('isActive: $isActive, ')
          ..write('jsonData: $jsonData, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, firstName, lastName, email, phone,
      balance, isActive, jsonData, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCustomer &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.balance == this.balance &&
          other.isActive == this.isActive &&
          other.jsonData == this.jsonData &&
          other.syncedAt == this.syncedAt);
}

class CachedCustomersCompanion extends UpdateCompanion<CachedCustomer> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<double> balance;
  final Value<bool> isActive;
  final Value<String> jsonData;
  final Value<DateTime> syncedAt;
  final Value<int> rowid;
  const CachedCustomersCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.balance = const Value.absent(),
    this.isActive = const Value.absent(),
    this.jsonData = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedCustomersCompanion.insert({
    required String id,
    required String firstName,
    required String lastName,
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.balance = const Value.absent(),
    this.isActive = const Value.absent(),
    required String jsonData,
    required DateTime syncedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        firstName = Value(firstName),
        lastName = Value(lastName),
        jsonData = Value(jsonData),
        syncedAt = Value(syncedAt);
  static Insertable<CachedCustomer> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<double>? balance,
    Expression<bool>? isActive,
    Expression<String>? jsonData,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (balance != null) 'balance': balance,
      if (isActive != null) 'is_active': isActive,
      if (jsonData != null) 'json_data': jsonData,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedCustomersCompanion copyWith(
      {Value<String>? id,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<String?>? email,
      Value<String?>? phone,
      Value<double>? balance,
      Value<bool>? isActive,
      Value<String>? jsonData,
      Value<DateTime>? syncedAt,
      Value<int>? rowid}) {
    return CachedCustomersCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      balance: balance ?? this.balance,
      isActive: isActive ?? this.isActive,
      jsonData: jsonData ?? this.jsonData,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (jsonData.present) {
      map['json_data'] = Variable<String>(jsonData.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCustomersCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('balance: $balance, ')
          ..write('isActive: $isActive, ')
          ..write('jsonData: $jsonData, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedOrdersTable extends CachedOrders
    with TableInfo<$CachedOrdersTable, CachedOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderNumberMeta =
      const VerificationMeta('orderNumber');
  @override
  late final GeneratedColumn<String> orderNumber = GeneratedColumn<String>(
      'order_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _jsonDataMeta =
      const VerificationMeta('jsonData');
  @override
  late final GeneratedColumn<String> jsonData = GeneratedColumn<String>(
      'json_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderNumber,
        customerName,
        status,
        total,
        jsonData,
        isSynced,
        createdAt,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_orders';
  @override
  VerificationContext validateIntegrity(Insertable<CachedOrder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('order_number')) {
      context.handle(
          _orderNumberMeta,
          orderNumber.isAcceptableOrUnknown(
              data['order_number']!, _orderNumberMeta));
    } else if (isInserting) {
      context.missing(_orderNumberMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('json_data')) {
      context.handle(_jsonDataMeta,
          jsonData.isAcceptableOrUnknown(data['json_data']!, _jsonDataMeta));
    } else if (isInserting) {
      context.missing(_jsonDataMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    } else if (isInserting) {
      context.missing(_syncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedOrder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      orderNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_number'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      jsonData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json_data'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at'])!,
    );
  }

  @override
  $CachedOrdersTable createAlias(String alias) {
    return $CachedOrdersTable(attachedDatabase, alias);
  }
}

class CachedOrder extends DataClass implements Insertable<CachedOrder> {
  final String id;
  final String orderNumber;
  final String? customerName;
  final String status;
  final double total;
  final String jsonData;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime syncedAt;
  const CachedOrder(
      {required this.id,
      required this.orderNumber,
      this.customerName,
      required this.status,
      required this.total,
      required this.jsonData,
      required this.isSynced,
      required this.createdAt,
      required this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_number'] = Variable<String>(orderNumber);
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    map['status'] = Variable<String>(status);
    map['total'] = Variable<double>(total);
    map['json_data'] = Variable<String>(jsonData);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  CachedOrdersCompanion toCompanion(bool nullToAbsent) {
    return CachedOrdersCompanion(
      id: Value(id),
      orderNumber: Value(orderNumber),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      status: Value(status),
      total: Value(total),
      jsonData: Value(jsonData),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      syncedAt: Value(syncedAt),
    );
  }

  factory CachedOrder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedOrder(
      id: serializer.fromJson<String>(json['id']),
      orderNumber: serializer.fromJson<String>(json['orderNumber']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      status: serializer.fromJson<String>(json['status']),
      total: serializer.fromJson<double>(json['total']),
      jsonData: serializer.fromJson<String>(json['jsonData']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderNumber': serializer.toJson<String>(orderNumber),
      'customerName': serializer.toJson<String?>(customerName),
      'status': serializer.toJson<String>(status),
      'total': serializer.toJson<double>(total),
      'jsonData': serializer.toJson<String>(jsonData),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  CachedOrder copyWith(
          {String? id,
          String? orderNumber,
          Value<String?> customerName = const Value.absent(),
          String? status,
          double? total,
          String? jsonData,
          bool? isSynced,
          DateTime? createdAt,
          DateTime? syncedAt}) =>
      CachedOrder(
        id: id ?? this.id,
        orderNumber: orderNumber ?? this.orderNumber,
        customerName:
            customerName.present ? customerName.value : this.customerName,
        status: status ?? this.status,
        total: total ?? this.total,
        jsonData: jsonData ?? this.jsonData,
        isSynced: isSynced ?? this.isSynced,
        createdAt: createdAt ?? this.createdAt,
        syncedAt: syncedAt ?? this.syncedAt,
      );
  CachedOrder copyWithCompanion(CachedOrdersCompanion data) {
    return CachedOrder(
      id: data.id.present ? data.id.value : this.id,
      orderNumber:
          data.orderNumber.present ? data.orderNumber.value : this.orderNumber,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      status: data.status.present ? data.status.value : this.status,
      total: data.total.present ? data.total.value : this.total,
      jsonData: data.jsonData.present ? data.jsonData.value : this.jsonData,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedOrder(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('customerName: $customerName, ')
          ..write('status: $status, ')
          ..write('total: $total, ')
          ..write('jsonData: $jsonData, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderNumber, customerName, status, total,
      jsonData, isSynced, createdAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedOrder &&
          other.id == this.id &&
          other.orderNumber == this.orderNumber &&
          other.customerName == this.customerName &&
          other.status == this.status &&
          other.total == this.total &&
          other.jsonData == this.jsonData &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt);
}

class CachedOrdersCompanion extends UpdateCompanion<CachedOrder> {
  final Value<String> id;
  final Value<String> orderNumber;
  final Value<String?> customerName;
  final Value<String> status;
  final Value<double> total;
  final Value<String> jsonData;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<DateTime> syncedAt;
  final Value<int> rowid;
  const CachedOrdersCompanion({
    this.id = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.customerName = const Value.absent(),
    this.status = const Value.absent(),
    this.total = const Value.absent(),
    this.jsonData = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedOrdersCompanion.insert({
    required String id,
    required String orderNumber,
    this.customerName = const Value.absent(),
    required String status,
    required double total,
    required String jsonData,
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    required DateTime syncedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        orderNumber = Value(orderNumber),
        status = Value(status),
        total = Value(total),
        jsonData = Value(jsonData),
        createdAt = Value(createdAt),
        syncedAt = Value(syncedAt);
  static Insertable<CachedOrder> custom({
    Expression<String>? id,
    Expression<String>? orderNumber,
    Expression<String>? customerName,
    Expression<String>? status,
    Expression<double>? total,
    Expression<String>? jsonData,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderNumber != null) 'order_number': orderNumber,
      if (customerName != null) 'customer_name': customerName,
      if (status != null) 'status': status,
      if (total != null) 'total': total,
      if (jsonData != null) 'json_data': jsonData,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedOrdersCompanion copyWith(
      {Value<String>? id,
      Value<String>? orderNumber,
      Value<String?>? customerName,
      Value<String>? status,
      Value<double>? total,
      Value<String>? jsonData,
      Value<bool>? isSynced,
      Value<DateTime>? createdAt,
      Value<DateTime>? syncedAt,
      Value<int>? rowid}) {
    return CachedOrdersCompanion(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerName: customerName ?? this.customerName,
      status: status ?? this.status,
      total: total ?? this.total,
      jsonData: jsonData ?? this.jsonData,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderNumber.present) {
      map['order_number'] = Variable<String>(orderNumber.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (jsonData.present) {
      map['json_data'] = Variable<String>(jsonData.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedOrdersCompanion(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('customerName: $customerName, ')
          ..write('status: $status, ')
          ..write('total: $total, ')
          ..write('jsonData: $jsonData, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedProductsTable cachedProducts = $CachedProductsTable(this);
  late final $CachedCustomersTable cachedCustomers =
      $CachedCustomersTable(this);
  late final $CachedOrdersTable cachedOrders = $CachedOrdersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [cachedProducts, cachedCustomers, cachedOrders];
}

typedef $$CachedProductsTableCreateCompanionBuilder = CachedProductsCompanion
    Function({
  required String id,
  required String sku,
  required String name,
  Value<String?> description,
  required double unitPrice,
  required String productType,
  required String uom,
  Value<bool> isActive,
  Value<double> stockQuantity,
  required String jsonData,
  required DateTime syncedAt,
  Value<int> rowid,
});
typedef $$CachedProductsTableUpdateCompanionBuilder = CachedProductsCompanion
    Function({
  Value<String> id,
  Value<String> sku,
  Value<String> name,
  Value<String?> description,
  Value<double> unitPrice,
  Value<String> productType,
  Value<String> uom,
  Value<bool> isActive,
  Value<double> stockQuantity,
  Value<String> jsonData,
  Value<DateTime> syncedAt,
  Value<int> rowid,
});

class $$CachedProductsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sku => $composableBuilder(
      column: $table.sku, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productType => $composableBuilder(
      column: $table.productType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uom => $composableBuilder(
      column: $table.uom, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stockQuantity => $composableBuilder(
      column: $table.stockQuantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jsonData => $composableBuilder(
      column: $table.jsonData, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$CachedProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sku => $composableBuilder(
      column: $table.sku, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productType => $composableBuilder(
      column: $table.productType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uom => $composableBuilder(
      column: $table.uom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stockQuantity => $composableBuilder(
      column: $table.stockQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jsonData => $composableBuilder(
      column: $table.jsonData, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$CachedProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<String> get productType => $composableBuilder(
      column: $table.productType, builder: (column) => column);

  GeneratedColumn<String> get uom =>
      $composableBuilder(column: $table.uom, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<double> get stockQuantity => $composableBuilder(
      column: $table.stockQuantity, builder: (column) => column);

  GeneratedColumn<String> get jsonData =>
      $composableBuilder(column: $table.jsonData, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedProductsTable,
    CachedProduct,
    $$CachedProductsTableFilterComposer,
    $$CachedProductsTableOrderingComposer,
    $$CachedProductsTableAnnotationComposer,
    $$CachedProductsTableCreateCompanionBuilder,
    $$CachedProductsTableUpdateCompanionBuilder,
    (
      CachedProduct,
      BaseReferences<_$AppDatabase, $CachedProductsTable, CachedProduct>
    ),
    CachedProduct,
    PrefetchHooks Function()> {
  $$CachedProductsTableTableManager(
      _$AppDatabase db, $CachedProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sku = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<String> productType = const Value.absent(),
            Value<String> uom = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<double> stockQuantity = const Value.absent(),
            Value<String> jsonData = const Value.absent(),
            Value<DateTime> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedProductsCompanion(
            id: id,
            sku: sku,
            name: name,
            description: description,
            unitPrice: unitPrice,
            productType: productType,
            uom: uom,
            isActive: isActive,
            stockQuantity: stockQuantity,
            jsonData: jsonData,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sku,
            required String name,
            Value<String?> description = const Value.absent(),
            required double unitPrice,
            required String productType,
            required String uom,
            Value<bool> isActive = const Value.absent(),
            Value<double> stockQuantity = const Value.absent(),
            required String jsonData,
            required DateTime syncedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedProductsCompanion.insert(
            id: id,
            sku: sku,
            name: name,
            description: description,
            unitPrice: unitPrice,
            productType: productType,
            uom: uom,
            isActive: isActive,
            stockQuantity: stockQuantity,
            jsonData: jsonData,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedProductsTable,
    CachedProduct,
    $$CachedProductsTableFilterComposer,
    $$CachedProductsTableOrderingComposer,
    $$CachedProductsTableAnnotationComposer,
    $$CachedProductsTableCreateCompanionBuilder,
    $$CachedProductsTableUpdateCompanionBuilder,
    (
      CachedProduct,
      BaseReferences<_$AppDatabase, $CachedProductsTable, CachedProduct>
    ),
    CachedProduct,
    PrefetchHooks Function()>;
typedef $$CachedCustomersTableCreateCompanionBuilder = CachedCustomersCompanion
    Function({
  required String id,
  required String firstName,
  required String lastName,
  Value<String?> email,
  Value<String?> phone,
  Value<double> balance,
  Value<bool> isActive,
  required String jsonData,
  required DateTime syncedAt,
  Value<int> rowid,
});
typedef $$CachedCustomersTableUpdateCompanionBuilder = CachedCustomersCompanion
    Function({
  Value<String> id,
  Value<String> firstName,
  Value<String> lastName,
  Value<String?> email,
  Value<String?> phone,
  Value<double> balance,
  Value<bool> isActive,
  Value<String> jsonData,
  Value<DateTime> syncedAt,
  Value<int> rowid,
});

class $$CachedCustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CachedCustomersTable> {
  $$CachedCustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jsonData => $composableBuilder(
      column: $table.jsonData, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$CachedCustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedCustomersTable> {
  $$CachedCustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jsonData => $composableBuilder(
      column: $table.jsonData, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$CachedCustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedCustomersTable> {
  $$CachedCustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get jsonData =>
      $composableBuilder(column: $table.jsonData, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedCustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedCustomersTable,
    CachedCustomer,
    $$CachedCustomersTableFilterComposer,
    $$CachedCustomersTableOrderingComposer,
    $$CachedCustomersTableAnnotationComposer,
    $$CachedCustomersTableCreateCompanionBuilder,
    $$CachedCustomersTableUpdateCompanionBuilder,
    (
      CachedCustomer,
      BaseReferences<_$AppDatabase, $CachedCustomersTable, CachedCustomer>
    ),
    CachedCustomer,
    PrefetchHooks Function()> {
  $$CachedCustomersTableTableManager(
      _$AppDatabase db, $CachedCustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedCustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedCustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> jsonData = const Value.absent(),
            Value<DateTime> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedCustomersCompanion(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            balance: balance,
            isActive: isActive,
            jsonData: jsonData,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String firstName,
            required String lastName,
            Value<String?> email = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required String jsonData,
            required DateTime syncedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedCustomersCompanion.insert(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            balance: balance,
            isActive: isActive,
            jsonData: jsonData,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedCustomersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedCustomersTable,
    CachedCustomer,
    $$CachedCustomersTableFilterComposer,
    $$CachedCustomersTableOrderingComposer,
    $$CachedCustomersTableAnnotationComposer,
    $$CachedCustomersTableCreateCompanionBuilder,
    $$CachedCustomersTableUpdateCompanionBuilder,
    (
      CachedCustomer,
      BaseReferences<_$AppDatabase, $CachedCustomersTable, CachedCustomer>
    ),
    CachedCustomer,
    PrefetchHooks Function()>;
typedef $$CachedOrdersTableCreateCompanionBuilder = CachedOrdersCompanion
    Function({
  required String id,
  required String orderNumber,
  Value<String?> customerName,
  required String status,
  required double total,
  required String jsonData,
  Value<bool> isSynced,
  required DateTime createdAt,
  required DateTime syncedAt,
  Value<int> rowid,
});
typedef $$CachedOrdersTableUpdateCompanionBuilder = CachedOrdersCompanion
    Function({
  Value<String> id,
  Value<String> orderNumber,
  Value<String?> customerName,
  Value<String> status,
  Value<double> total,
  Value<String> jsonData,
  Value<bool> isSynced,
  Value<DateTime> createdAt,
  Value<DateTime> syncedAt,
  Value<int> rowid,
});

class $$CachedOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $CachedOrdersTable> {
  $$CachedOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jsonData => $composableBuilder(
      column: $table.jsonData, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$CachedOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedOrdersTable> {
  $$CachedOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jsonData => $composableBuilder(
      column: $table.jsonData, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$CachedOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedOrdersTable> {
  $$CachedOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get jsonData =>
      $composableBuilder(column: $table.jsonData, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedOrdersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedOrdersTable,
    CachedOrder,
    $$CachedOrdersTableFilterComposer,
    $$CachedOrdersTableOrderingComposer,
    $$CachedOrdersTableAnnotationComposer,
    $$CachedOrdersTableCreateCompanionBuilder,
    $$CachedOrdersTableUpdateCompanionBuilder,
    (
      CachedOrder,
      BaseReferences<_$AppDatabase, $CachedOrdersTable, CachedOrder>
    ),
    CachedOrder,
    PrefetchHooks Function()> {
  $$CachedOrdersTableTableManager(_$AppDatabase db, $CachedOrdersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> orderNumber = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String> jsonData = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedOrdersCompanion(
            id: id,
            orderNumber: orderNumber,
            customerName: customerName,
            status: status,
            total: total,
            jsonData: jsonData,
            isSynced: isSynced,
            createdAt: createdAt,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String orderNumber,
            Value<String?> customerName = const Value.absent(),
            required String status,
            required double total,
            required String jsonData,
            Value<bool> isSynced = const Value.absent(),
            required DateTime createdAt,
            required DateTime syncedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedOrdersCompanion.insert(
            id: id,
            orderNumber: orderNumber,
            customerName: customerName,
            status: status,
            total: total,
            jsonData: jsonData,
            isSynced: isSynced,
            createdAt: createdAt,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedOrdersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedOrdersTable,
    CachedOrder,
    $$CachedOrdersTableFilterComposer,
    $$CachedOrdersTableOrderingComposer,
    $$CachedOrdersTableAnnotationComposer,
    $$CachedOrdersTableCreateCompanionBuilder,
    $$CachedOrdersTableUpdateCompanionBuilder,
    (
      CachedOrder,
      BaseReferences<_$AppDatabase, $CachedOrdersTable, CachedOrder>
    ),
    CachedOrder,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedProductsTableTableManager get cachedProducts =>
      $$CachedProductsTableTableManager(_db, _db.cachedProducts);
  $$CachedCustomersTableTableManager get cachedCustomers =>
      $$CachedCustomersTableTableManager(_db, _db.cachedCustomers);
  $$CachedOrdersTableTableManager get cachedOrders =>
      $$CachedOrdersTableTableManager(_db, _db.cachedOrders);
}
