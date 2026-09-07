// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockItem {

 String get id; String get sku; String get name; String get categoryId; String get supplierId; double get costPrice; double get sellPrice; int get quantityOnHand; int get reorderLevel; DateTime? get createdAt;
/// Create a copy of StockItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockItemCopyWith<StockItem> get copyWith => _$StockItemCopyWithImpl<StockItem>(this as StockItem, _$identity);

  /// Serializes this StockItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockItem&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.costPrice, costPrice) || other.costPrice == costPrice)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice)&&(identical(other.quantityOnHand, quantityOnHand) || other.quantityOnHand == quantityOnHand)&&(identical(other.reorderLevel, reorderLevel) || other.reorderLevel == reorderLevel)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sku,name,categoryId,supplierId,costPrice,sellPrice,quantityOnHand,reorderLevel,createdAt);

@override
String toString() {
  return 'StockItem(id: $id, sku: $sku, name: $name, categoryId: $categoryId, supplierId: $supplierId, costPrice: $costPrice, sellPrice: $sellPrice, quantityOnHand: $quantityOnHand, reorderLevel: $reorderLevel, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StockItemCopyWith<$Res>  {
  factory $StockItemCopyWith(StockItem value, $Res Function(StockItem) _then) = _$StockItemCopyWithImpl;
@useResult
$Res call({
 String id, String sku, String name, String categoryId, String supplierId, double costPrice, double sellPrice, int quantityOnHand, int reorderLevel, DateTime? createdAt
});




}
/// @nodoc
class _$StockItemCopyWithImpl<$Res>
    implements $StockItemCopyWith<$Res> {
  _$StockItemCopyWithImpl(this._self, this._then);

  final StockItem _self;
  final $Res Function(StockItem) _then;

/// Create a copy of StockItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? categoryId = null,Object? supplierId = null,Object? costPrice = null,Object? sellPrice = null,Object? quantityOnHand = null,Object? reorderLevel = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,costPrice: null == costPrice ? _self.costPrice : costPrice // ignore: cast_nullable_to_non_nullable
as double,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as double,quantityOnHand: null == quantityOnHand ? _self.quantityOnHand : quantityOnHand // ignore: cast_nullable_to_non_nullable
as int,reorderLevel: null == reorderLevel ? _self.reorderLevel : reorderLevel // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StockItem].
extension StockItemPatterns on StockItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockItem value)  $default,){
final _that = this;
switch (_that) {
case _StockItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockItem value)?  $default,){
final _that = this;
switch (_that) {
case _StockItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sku,  String name,  String categoryId,  String supplierId,  double costPrice,  double sellPrice,  int quantityOnHand,  int reorderLevel,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockItem() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.categoryId,_that.supplierId,_that.costPrice,_that.sellPrice,_that.quantityOnHand,_that.reorderLevel,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sku,  String name,  String categoryId,  String supplierId,  double costPrice,  double sellPrice,  int quantityOnHand,  int reorderLevel,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _StockItem():
return $default(_that.id,_that.sku,_that.name,_that.categoryId,_that.supplierId,_that.costPrice,_that.sellPrice,_that.quantityOnHand,_that.reorderLevel,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sku,  String name,  String categoryId,  String supplierId,  double costPrice,  double sellPrice,  int quantityOnHand,  int reorderLevel,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StockItem() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.categoryId,_that.supplierId,_that.costPrice,_that.sellPrice,_that.quantityOnHand,_that.reorderLevel,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockItem implements StockItem {
  const _StockItem({required this.id, required this.sku, required this.name, required this.categoryId, required this.supplierId, required this.costPrice, required this.sellPrice, required this.quantityOnHand, required this.reorderLevel, this.createdAt});
  factory _StockItem.fromJson(Map<String, dynamic> json) => _$StockItemFromJson(json);

@override final  String id;
@override final  String sku;
@override final  String name;
@override final  String categoryId;
@override final  String supplierId;
@override final  double costPrice;
@override final  double sellPrice;
@override final  int quantityOnHand;
@override final  int reorderLevel;
@override final  DateTime? createdAt;

/// Create a copy of StockItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockItemCopyWith<_StockItem> get copyWith => __$StockItemCopyWithImpl<_StockItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockItem&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.costPrice, costPrice) || other.costPrice == costPrice)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice)&&(identical(other.quantityOnHand, quantityOnHand) || other.quantityOnHand == quantityOnHand)&&(identical(other.reorderLevel, reorderLevel) || other.reorderLevel == reorderLevel)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sku,name,categoryId,supplierId,costPrice,sellPrice,quantityOnHand,reorderLevel,createdAt);

@override
String toString() {
  return 'StockItem(id: $id, sku: $sku, name: $name, categoryId: $categoryId, supplierId: $supplierId, costPrice: $costPrice, sellPrice: $sellPrice, quantityOnHand: $quantityOnHand, reorderLevel: $reorderLevel, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StockItemCopyWith<$Res> implements $StockItemCopyWith<$Res> {
  factory _$StockItemCopyWith(_StockItem value, $Res Function(_StockItem) _then) = __$StockItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String sku, String name, String categoryId, String supplierId, double costPrice, double sellPrice, int quantityOnHand, int reorderLevel, DateTime? createdAt
});




}
/// @nodoc
class __$StockItemCopyWithImpl<$Res>
    implements _$StockItemCopyWith<$Res> {
  __$StockItemCopyWithImpl(this._self, this._then);

  final _StockItem _self;
  final $Res Function(_StockItem) _then;

/// Create a copy of StockItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? categoryId = null,Object? supplierId = null,Object? costPrice = null,Object? sellPrice = null,Object? quantityOnHand = null,Object? reorderLevel = null,Object? createdAt = freezed,}) {
  return _then(_StockItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,costPrice: null == costPrice ? _self.costPrice : costPrice // ignore: cast_nullable_to_non_nullable
as double,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as double,quantityOnHand: null == quantityOnHand ? _self.quantityOnHand : quantityOnHand // ignore: cast_nullable_to_non_nullable
as int,reorderLevel: null == reorderLevel ? _self.reorderLevel : reorderLevel // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
