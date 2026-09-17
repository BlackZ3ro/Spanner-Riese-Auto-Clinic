// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_part.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingPart {

 String get id; String get bookingId; String get stockItemId; int get quantity; double get unitPrice; DateTime? get createdAt;
/// Create a copy of BookingPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingPartCopyWith<BookingPart> get copyWith => _$BookingPartCopyWithImpl<BookingPart>(this as BookingPart, _$identity);

  /// Serializes this BookingPart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingPart&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.stockItemId, stockItemId) || other.stockItemId == stockItemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingId,stockItemId,quantity,unitPrice,createdAt);

@override
String toString() {
  return 'BookingPart(id: $id, bookingId: $bookingId, stockItemId: $stockItemId, quantity: $quantity, unitPrice: $unitPrice, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BookingPartCopyWith<$Res>  {
  factory $BookingPartCopyWith(BookingPart value, $Res Function(BookingPart) _then) = _$BookingPartCopyWithImpl;
@useResult
$Res call({
 String id, String bookingId, String stockItemId, int quantity, double unitPrice, DateTime? createdAt
});




}
/// @nodoc
class _$BookingPartCopyWithImpl<$Res>
    implements $BookingPartCopyWith<$Res> {
  _$BookingPartCopyWithImpl(this._self, this._then);

  final BookingPart _self;
  final $Res Function(BookingPart) _then;

/// Create a copy of BookingPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookingId = null,Object? stockItemId = null,Object? quantity = null,Object? unitPrice = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,stockItemId: null == stockItemId ? _self.stockItemId : stockItemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingPart].
extension BookingPartPatterns on BookingPart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingPart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingPart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingPart value)  $default,){
final _that = this;
switch (_that) {
case _BookingPart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingPart value)?  $default,){
final _that = this;
switch (_that) {
case _BookingPart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bookingId,  String stockItemId,  int quantity,  double unitPrice,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingPart() when $default != null:
return $default(_that.id,_that.bookingId,_that.stockItemId,_that.quantity,_that.unitPrice,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bookingId,  String stockItemId,  int quantity,  double unitPrice,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _BookingPart():
return $default(_that.id,_that.bookingId,_that.stockItemId,_that.quantity,_that.unitPrice,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bookingId,  String stockItemId,  int quantity,  double unitPrice,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BookingPart() when $default != null:
return $default(_that.id,_that.bookingId,_that.stockItemId,_that.quantity,_that.unitPrice,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingPart implements BookingPart {
  const _BookingPart({required this.id, required this.bookingId, required this.stockItemId, required this.quantity, required this.unitPrice, this.createdAt});
  factory _BookingPart.fromJson(Map<String, dynamic> json) => _$BookingPartFromJson(json);

@override final  String id;
@override final  String bookingId;
@override final  String stockItemId;
@override final  int quantity;
@override final  double unitPrice;
@override final  DateTime? createdAt;

/// Create a copy of BookingPart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingPartCopyWith<_BookingPart> get copyWith => __$BookingPartCopyWithImpl<_BookingPart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingPartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingPart&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.stockItemId, stockItemId) || other.stockItemId == stockItemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingId,stockItemId,quantity,unitPrice,createdAt);

@override
String toString() {
  return 'BookingPart(id: $id, bookingId: $bookingId, stockItemId: $stockItemId, quantity: $quantity, unitPrice: $unitPrice, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BookingPartCopyWith<$Res> implements $BookingPartCopyWith<$Res> {
  factory _$BookingPartCopyWith(_BookingPart value, $Res Function(_BookingPart) _then) = __$BookingPartCopyWithImpl;
@override @useResult
$Res call({
 String id, String bookingId, String stockItemId, int quantity, double unitPrice, DateTime? createdAt
});




}
/// @nodoc
class __$BookingPartCopyWithImpl<$Res>
    implements _$BookingPartCopyWith<$Res> {
  __$BookingPartCopyWithImpl(this._self, this._then);

  final _BookingPart _self;
  final $Res Function(_BookingPart) _then;

/// Create a copy of BookingPart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookingId = null,Object? stockItemId = null,Object? quantity = null,Object? unitPrice = null,Object? createdAt = freezed,}) {
  return _then(_BookingPart(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,stockItemId: null == stockItemId ? _self.stockItemId : stockItemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
