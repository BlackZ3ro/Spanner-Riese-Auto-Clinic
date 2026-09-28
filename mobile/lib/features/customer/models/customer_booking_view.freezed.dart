// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_booking_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerBookingView {

 String get referenceCode; String get invoiceNumber; String get brand; String get model; int get year; String get registration; String? get imageUrl; BookingPhase get phase; BookingStatus get status; DateTime? get createdAt; DateTime? get closedAt; List<CustomerPartView> get parts; List<CustomerLaborView> get labor;
/// Create a copy of CustomerBookingView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerBookingViewCopyWith<CustomerBookingView> get copyWith => _$CustomerBookingViewCopyWithImpl<CustomerBookingView>(this as CustomerBookingView, _$identity);

  /// Serializes this CustomerBookingView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerBookingView&&(identical(other.referenceCode, referenceCode) || other.referenceCode == referenceCode)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year)&&(identical(other.registration, registration) || other.registration == registration)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&const DeepCollectionEquality().equals(other.parts, parts)&&const DeepCollectionEquality().equals(other.labor, labor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,referenceCode,invoiceNumber,brand,model,year,registration,imageUrl,phase,status,createdAt,closedAt,const DeepCollectionEquality().hash(parts),const DeepCollectionEquality().hash(labor));

@override
String toString() {
  return 'CustomerBookingView(referenceCode: $referenceCode, invoiceNumber: $invoiceNumber, brand: $brand, model: $model, year: $year, registration: $registration, imageUrl: $imageUrl, phase: $phase, status: $status, createdAt: $createdAt, closedAt: $closedAt, parts: $parts, labor: $labor)';
}


}

/// @nodoc
abstract mixin class $CustomerBookingViewCopyWith<$Res>  {
  factory $CustomerBookingViewCopyWith(CustomerBookingView value, $Res Function(CustomerBookingView) _then) = _$CustomerBookingViewCopyWithImpl;
@useResult
$Res call({
 String referenceCode, String invoiceNumber, String brand, String model, int year, String registration, String? imageUrl, BookingPhase phase, BookingStatus status, DateTime? createdAt, DateTime? closedAt, List<CustomerPartView> parts, List<CustomerLaborView> labor
});




}
/// @nodoc
class _$CustomerBookingViewCopyWithImpl<$Res>
    implements $CustomerBookingViewCopyWith<$Res> {
  _$CustomerBookingViewCopyWithImpl(this._self, this._then);

  final CustomerBookingView _self;
  final $Res Function(CustomerBookingView) _then;

/// Create a copy of CustomerBookingView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? referenceCode = null,Object? invoiceNumber = null,Object? brand = null,Object? model = null,Object? year = null,Object? registration = null,Object? imageUrl = freezed,Object? phase = null,Object? status = null,Object? createdAt = freezed,Object? closedAt = freezed,Object? parts = null,Object? labor = null,}) {
  return _then(_self.copyWith(
referenceCode: null == referenceCode ? _self.referenceCode : referenceCode // ignore: cast_nullable_to_non_nullable
as String,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,registration: null == registration ? _self.registration : registration // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as BookingPhase,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<CustomerPartView>,labor: null == labor ? _self.labor : labor // ignore: cast_nullable_to_non_nullable
as List<CustomerLaborView>,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerBookingView].
extension CustomerBookingViewPatterns on CustomerBookingView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerBookingView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerBookingView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerBookingView value)  $default,){
final _that = this;
switch (_that) {
case _CustomerBookingView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerBookingView value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerBookingView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String referenceCode,  String invoiceNumber,  String brand,  String model,  int year,  String registration,  String? imageUrl,  BookingPhase phase,  BookingStatus status,  DateTime? createdAt,  DateTime? closedAt,  List<CustomerPartView> parts,  List<CustomerLaborView> labor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerBookingView() when $default != null:
return $default(_that.referenceCode,_that.invoiceNumber,_that.brand,_that.model,_that.year,_that.registration,_that.imageUrl,_that.phase,_that.status,_that.createdAt,_that.closedAt,_that.parts,_that.labor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String referenceCode,  String invoiceNumber,  String brand,  String model,  int year,  String registration,  String? imageUrl,  BookingPhase phase,  BookingStatus status,  DateTime? createdAt,  DateTime? closedAt,  List<CustomerPartView> parts,  List<CustomerLaborView> labor)  $default,) {final _that = this;
switch (_that) {
case _CustomerBookingView():
return $default(_that.referenceCode,_that.invoiceNumber,_that.brand,_that.model,_that.year,_that.registration,_that.imageUrl,_that.phase,_that.status,_that.createdAt,_that.closedAt,_that.parts,_that.labor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String referenceCode,  String invoiceNumber,  String brand,  String model,  int year,  String registration,  String? imageUrl,  BookingPhase phase,  BookingStatus status,  DateTime? createdAt,  DateTime? closedAt,  List<CustomerPartView> parts,  List<CustomerLaborView> labor)?  $default,) {final _that = this;
switch (_that) {
case _CustomerBookingView() when $default != null:
return $default(_that.referenceCode,_that.invoiceNumber,_that.brand,_that.model,_that.year,_that.registration,_that.imageUrl,_that.phase,_that.status,_that.createdAt,_that.closedAt,_that.parts,_that.labor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerBookingView implements CustomerBookingView {
  const _CustomerBookingView({required this.referenceCode, required this.invoiceNumber, required this.brand, required this.model, required this.year, required this.registration, this.imageUrl, required this.phase, required this.status, this.createdAt, this.closedAt, required this.parts, required this.labor});
  factory _CustomerBookingView.fromJson(Map<String, dynamic> json) => _$CustomerBookingViewFromJson(json);

@override final  String referenceCode;
@override final  String invoiceNumber;
@override final  String brand;
@override final  String model;
@override final  int year;
@override final  String registration;
@override final  String? imageUrl;
@override final  BookingPhase phase;
@override final  BookingStatus status;
@override final  DateTime? createdAt;
@override final  DateTime? closedAt;
@override final  List<CustomerPartView> parts;
@override final  List<CustomerLaborView> labor;

/// Create a copy of CustomerBookingView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerBookingViewCopyWith<_CustomerBookingView> get copyWith => __$CustomerBookingViewCopyWithImpl<_CustomerBookingView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerBookingViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerBookingView&&(identical(other.referenceCode, referenceCode) || other.referenceCode == referenceCode)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year)&&(identical(other.registration, registration) || other.registration == registration)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&const DeepCollectionEquality().equals(other.parts, parts)&&const DeepCollectionEquality().equals(other.labor, labor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,referenceCode,invoiceNumber,brand,model,year,registration,imageUrl,phase,status,createdAt,closedAt,const DeepCollectionEquality().hash(parts),const DeepCollectionEquality().hash(labor));

@override
String toString() {
  return 'CustomerBookingView(referenceCode: $referenceCode, invoiceNumber: $invoiceNumber, brand: $brand, model: $model, year: $year, registration: $registration, imageUrl: $imageUrl, phase: $phase, status: $status, createdAt: $createdAt, closedAt: $closedAt, parts: $parts, labor: $labor)';
}


}

/// @nodoc
abstract mixin class _$CustomerBookingViewCopyWith<$Res> implements $CustomerBookingViewCopyWith<$Res> {
  factory _$CustomerBookingViewCopyWith(_CustomerBookingView value, $Res Function(_CustomerBookingView) _then) = __$CustomerBookingViewCopyWithImpl;
@override @useResult
$Res call({
 String referenceCode, String invoiceNumber, String brand, String model, int year, String registration, String? imageUrl, BookingPhase phase, BookingStatus status, DateTime? createdAt, DateTime? closedAt, List<CustomerPartView> parts, List<CustomerLaborView> labor
});




}
/// @nodoc
class __$CustomerBookingViewCopyWithImpl<$Res>
    implements _$CustomerBookingViewCopyWith<$Res> {
  __$CustomerBookingViewCopyWithImpl(this._self, this._then);

  final _CustomerBookingView _self;
  final $Res Function(_CustomerBookingView) _then;

/// Create a copy of CustomerBookingView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? referenceCode = null,Object? invoiceNumber = null,Object? brand = null,Object? model = null,Object? year = null,Object? registration = null,Object? imageUrl = freezed,Object? phase = null,Object? status = null,Object? createdAt = freezed,Object? closedAt = freezed,Object? parts = null,Object? labor = null,}) {
  return _then(_CustomerBookingView(
referenceCode: null == referenceCode ? _self.referenceCode : referenceCode // ignore: cast_nullable_to_non_nullable
as String,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,registration: null == registration ? _self.registration : registration // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as BookingPhase,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<CustomerPartView>,labor: null == labor ? _self.labor : labor // ignore: cast_nullable_to_non_nullable
as List<CustomerLaborView>,
  ));
}


}

// dart format on
