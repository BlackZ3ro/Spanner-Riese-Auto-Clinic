// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_labor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingLabor {

 String get id; String get bookingId; String get description; double get hours; double get rate; double get price; DateTime? get createdAt;
/// Create a copy of BookingLabor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingLaborCopyWith<BookingLabor> get copyWith => _$BookingLaborCopyWithImpl<BookingLabor>(this as BookingLabor, _$identity);

  /// Serializes this BookingLabor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingLabor&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.description, description) || other.description == description)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.price, price) || other.price == price)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingId,description,hours,rate,price,createdAt);

@override
String toString() {
  return 'BookingLabor(id: $id, bookingId: $bookingId, description: $description, hours: $hours, rate: $rate, price: $price, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BookingLaborCopyWith<$Res>  {
  factory $BookingLaborCopyWith(BookingLabor value, $Res Function(BookingLabor) _then) = _$BookingLaborCopyWithImpl;
@useResult
$Res call({
 String id, String bookingId, String description, double hours, double rate, double price, DateTime? createdAt
});




}
/// @nodoc
class _$BookingLaborCopyWithImpl<$Res>
    implements $BookingLaborCopyWith<$Res> {
  _$BookingLaborCopyWithImpl(this._self, this._then);

  final BookingLabor _self;
  final $Res Function(BookingLabor) _then;

/// Create a copy of BookingLabor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookingId = null,Object? description = null,Object? hours = null,Object? rate = null,Object? price = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingLabor].
extension BookingLaborPatterns on BookingLabor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingLabor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingLabor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingLabor value)  $default,){
final _that = this;
switch (_that) {
case _BookingLabor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingLabor value)?  $default,){
final _that = this;
switch (_that) {
case _BookingLabor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bookingId,  String description,  double hours,  double rate,  double price,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingLabor() when $default != null:
return $default(_that.id,_that.bookingId,_that.description,_that.hours,_that.rate,_that.price,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bookingId,  String description,  double hours,  double rate,  double price,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _BookingLabor():
return $default(_that.id,_that.bookingId,_that.description,_that.hours,_that.rate,_that.price,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bookingId,  String description,  double hours,  double rate,  double price,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BookingLabor() when $default != null:
return $default(_that.id,_that.bookingId,_that.description,_that.hours,_that.rate,_that.price,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingLabor implements BookingLabor {
  const _BookingLabor({required this.id, required this.bookingId, required this.description, required this.hours, required this.rate, required this.price, this.createdAt});
  factory _BookingLabor.fromJson(Map<String, dynamic> json) => _$BookingLaborFromJson(json);

@override final  String id;
@override final  String bookingId;
@override final  String description;
@override final  double hours;
@override final  double rate;
@override final  double price;
@override final  DateTime? createdAt;

/// Create a copy of BookingLabor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingLaborCopyWith<_BookingLabor> get copyWith => __$BookingLaborCopyWithImpl<_BookingLabor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingLaborToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingLabor&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.description, description) || other.description == description)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.price, price) || other.price == price)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingId,description,hours,rate,price,createdAt);

@override
String toString() {
  return 'BookingLabor(id: $id, bookingId: $bookingId, description: $description, hours: $hours, rate: $rate, price: $price, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BookingLaborCopyWith<$Res> implements $BookingLaborCopyWith<$Res> {
  factory _$BookingLaborCopyWith(_BookingLabor value, $Res Function(_BookingLabor) _then) = __$BookingLaborCopyWithImpl;
@override @useResult
$Res call({
 String id, String bookingId, String description, double hours, double rate, double price, DateTime? createdAt
});




}
/// @nodoc
class __$BookingLaborCopyWithImpl<$Res>
    implements _$BookingLaborCopyWith<$Res> {
  __$BookingLaborCopyWithImpl(this._self, this._then);

  final _BookingLabor _self;
  final $Res Function(_BookingLabor) _then;

/// Create a copy of BookingLabor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookingId = null,Object? description = null,Object? hours = null,Object? rate = null,Object? price = null,Object? createdAt = freezed,}) {
  return _then(_BookingLabor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
