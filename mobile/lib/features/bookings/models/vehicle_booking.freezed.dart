// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VehicleBooking {

 String get id; String get invoiceNumber; String? get customerId; String get customerName; String get customerPhone; String? get customerEmail; String? get customerCompany; String get brand; String get model; int get year; String? get engineSize; TransmissionType get transmissionType; String get registration; int get kilometers; String? get engineCode; String? get imageUrl; BookingStatus get status; DateTime? get closedAt; DateTime? get createdAt;
/// Create a copy of VehicleBooking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleBookingCopyWith<VehicleBooking> get copyWith => _$VehicleBookingCopyWithImpl<VehicleBooking>(this as VehicleBooking, _$identity);

  /// Serializes this VehicleBooking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleBooking&&(identical(other.id, id) || other.id == id)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.customerEmail, customerEmail) || other.customerEmail == customerEmail)&&(identical(other.customerCompany, customerCompany) || other.customerCompany == customerCompany)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year)&&(identical(other.engineSize, engineSize) || other.engineSize == engineSize)&&(identical(other.transmissionType, transmissionType) || other.transmissionType == transmissionType)&&(identical(other.registration, registration) || other.registration == registration)&&(identical(other.kilometers, kilometers) || other.kilometers == kilometers)&&(identical(other.engineCode, engineCode) || other.engineCode == engineCode)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,invoiceNumber,customerId,customerName,customerPhone,customerEmail,customerCompany,brand,model,year,engineSize,transmissionType,registration,kilometers,engineCode,imageUrl,status,closedAt,createdAt]);

@override
String toString() {
  return 'VehicleBooking(id: $id, invoiceNumber: $invoiceNumber, customerId: $customerId, customerName: $customerName, customerPhone: $customerPhone, customerEmail: $customerEmail, customerCompany: $customerCompany, brand: $brand, model: $model, year: $year, engineSize: $engineSize, transmissionType: $transmissionType, registration: $registration, kilometers: $kilometers, engineCode: $engineCode, imageUrl: $imageUrl, status: $status, closedAt: $closedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $VehicleBookingCopyWith<$Res>  {
  factory $VehicleBookingCopyWith(VehicleBooking value, $Res Function(VehicleBooking) _then) = _$VehicleBookingCopyWithImpl;
@useResult
$Res call({
 String id, String invoiceNumber, String? customerId, String customerName, String customerPhone, String? customerEmail, String? customerCompany, String brand, String model, int year, String? engineSize, TransmissionType transmissionType, String registration, int kilometers, String? engineCode, String? imageUrl, BookingStatus status, DateTime? closedAt, DateTime? createdAt
});




}
/// @nodoc
class _$VehicleBookingCopyWithImpl<$Res>
    implements $VehicleBookingCopyWith<$Res> {
  _$VehicleBookingCopyWithImpl(this._self, this._then);

  final VehicleBooking _self;
  final $Res Function(VehicleBooking) _then;

/// Create a copy of VehicleBooking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? invoiceNumber = null,Object? customerId = freezed,Object? customerName = null,Object? customerPhone = null,Object? customerEmail = freezed,Object? customerCompany = freezed,Object? brand = null,Object? model = null,Object? year = null,Object? engineSize = freezed,Object? transmissionType = null,Object? registration = null,Object? kilometers = null,Object? engineCode = freezed,Object? imageUrl = freezed,Object? status = null,Object? closedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,customerPhone: null == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String,customerEmail: freezed == customerEmail ? _self.customerEmail : customerEmail // ignore: cast_nullable_to_non_nullable
as String?,customerCompany: freezed == customerCompany ? _self.customerCompany : customerCompany // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,engineSize: freezed == engineSize ? _self.engineSize : engineSize // ignore: cast_nullable_to_non_nullable
as String?,transmissionType: null == transmissionType ? _self.transmissionType : transmissionType // ignore: cast_nullable_to_non_nullable
as TransmissionType,registration: null == registration ? _self.registration : registration // ignore: cast_nullable_to_non_nullable
as String,kilometers: null == kilometers ? _self.kilometers : kilometers // ignore: cast_nullable_to_non_nullable
as int,engineCode: freezed == engineCode ? _self.engineCode : engineCode // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleBooking].
extension VehicleBookingPatterns on VehicleBooking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleBooking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleBooking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleBooking value)  $default,){
final _that = this;
switch (_that) {
case _VehicleBooking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleBooking value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleBooking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String invoiceNumber,  String? customerId,  String customerName,  String customerPhone,  String? customerEmail,  String? customerCompany,  String brand,  String model,  int year,  String? engineSize,  TransmissionType transmissionType,  String registration,  int kilometers,  String? engineCode,  String? imageUrl,  BookingStatus status,  DateTime? closedAt,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleBooking() when $default != null:
return $default(_that.id,_that.invoiceNumber,_that.customerId,_that.customerName,_that.customerPhone,_that.customerEmail,_that.customerCompany,_that.brand,_that.model,_that.year,_that.engineSize,_that.transmissionType,_that.registration,_that.kilometers,_that.engineCode,_that.imageUrl,_that.status,_that.closedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String invoiceNumber,  String? customerId,  String customerName,  String customerPhone,  String? customerEmail,  String? customerCompany,  String brand,  String model,  int year,  String? engineSize,  TransmissionType transmissionType,  String registration,  int kilometers,  String? engineCode,  String? imageUrl,  BookingStatus status,  DateTime? closedAt,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _VehicleBooking():
return $default(_that.id,_that.invoiceNumber,_that.customerId,_that.customerName,_that.customerPhone,_that.customerEmail,_that.customerCompany,_that.brand,_that.model,_that.year,_that.engineSize,_that.transmissionType,_that.registration,_that.kilometers,_that.engineCode,_that.imageUrl,_that.status,_that.closedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String invoiceNumber,  String? customerId,  String customerName,  String customerPhone,  String? customerEmail,  String? customerCompany,  String brand,  String model,  int year,  String? engineSize,  TransmissionType transmissionType,  String registration,  int kilometers,  String? engineCode,  String? imageUrl,  BookingStatus status,  DateTime? closedAt,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _VehicleBooking() when $default != null:
return $default(_that.id,_that.invoiceNumber,_that.customerId,_that.customerName,_that.customerPhone,_that.customerEmail,_that.customerCompany,_that.brand,_that.model,_that.year,_that.engineSize,_that.transmissionType,_that.registration,_that.kilometers,_that.engineCode,_that.imageUrl,_that.status,_that.closedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VehicleBooking implements VehicleBooking {
  const _VehicleBooking({required this.id, required this.invoiceNumber, this.customerId, required this.customerName, required this.customerPhone, this.customerEmail, this.customerCompany, required this.brand, required this.model, required this.year, this.engineSize, required this.transmissionType, required this.registration, required this.kilometers, this.engineCode, this.imageUrl, this.status = BookingStatus.checkedIn, this.closedAt, this.createdAt});
  factory _VehicleBooking.fromJson(Map<String, dynamic> json) => _$VehicleBookingFromJson(json);

@override final  String id;
@override final  String invoiceNumber;
@override final  String? customerId;
@override final  String customerName;
@override final  String customerPhone;
@override final  String? customerEmail;
@override final  String? customerCompany;
@override final  String brand;
@override final  String model;
@override final  int year;
@override final  String? engineSize;
@override final  TransmissionType transmissionType;
@override final  String registration;
@override final  int kilometers;
@override final  String? engineCode;
@override final  String? imageUrl;
@override@JsonKey() final  BookingStatus status;
@override final  DateTime? closedAt;
@override final  DateTime? createdAt;

/// Create a copy of VehicleBooking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleBookingCopyWith<_VehicleBooking> get copyWith => __$VehicleBookingCopyWithImpl<_VehicleBooking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleBookingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleBooking&&(identical(other.id, id) || other.id == id)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.customerEmail, customerEmail) || other.customerEmail == customerEmail)&&(identical(other.customerCompany, customerCompany) || other.customerCompany == customerCompany)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year)&&(identical(other.engineSize, engineSize) || other.engineSize == engineSize)&&(identical(other.transmissionType, transmissionType) || other.transmissionType == transmissionType)&&(identical(other.registration, registration) || other.registration == registration)&&(identical(other.kilometers, kilometers) || other.kilometers == kilometers)&&(identical(other.engineCode, engineCode) || other.engineCode == engineCode)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,invoiceNumber,customerId,customerName,customerPhone,customerEmail,customerCompany,brand,model,year,engineSize,transmissionType,registration,kilometers,engineCode,imageUrl,status,closedAt,createdAt]);

@override
String toString() {
  return 'VehicleBooking(id: $id, invoiceNumber: $invoiceNumber, customerId: $customerId, customerName: $customerName, customerPhone: $customerPhone, customerEmail: $customerEmail, customerCompany: $customerCompany, brand: $brand, model: $model, year: $year, engineSize: $engineSize, transmissionType: $transmissionType, registration: $registration, kilometers: $kilometers, engineCode: $engineCode, imageUrl: $imageUrl, status: $status, closedAt: $closedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$VehicleBookingCopyWith<$Res> implements $VehicleBookingCopyWith<$Res> {
  factory _$VehicleBookingCopyWith(_VehicleBooking value, $Res Function(_VehicleBooking) _then) = __$VehicleBookingCopyWithImpl;
@override @useResult
$Res call({
 String id, String invoiceNumber, String? customerId, String customerName, String customerPhone, String? customerEmail, String? customerCompany, String brand, String model, int year, String? engineSize, TransmissionType transmissionType, String registration, int kilometers, String? engineCode, String? imageUrl, BookingStatus status, DateTime? closedAt, DateTime? createdAt
});




}
/// @nodoc
class __$VehicleBookingCopyWithImpl<$Res>
    implements _$VehicleBookingCopyWith<$Res> {
  __$VehicleBookingCopyWithImpl(this._self, this._then);

  final _VehicleBooking _self;
  final $Res Function(_VehicleBooking) _then;

/// Create a copy of VehicleBooking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? invoiceNumber = null,Object? customerId = freezed,Object? customerName = null,Object? customerPhone = null,Object? customerEmail = freezed,Object? customerCompany = freezed,Object? brand = null,Object? model = null,Object? year = null,Object? engineSize = freezed,Object? transmissionType = null,Object? registration = null,Object? kilometers = null,Object? engineCode = freezed,Object? imageUrl = freezed,Object? status = null,Object? closedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_VehicleBooking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,customerPhone: null == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String,customerEmail: freezed == customerEmail ? _self.customerEmail : customerEmail // ignore: cast_nullable_to_non_nullable
as String?,customerCompany: freezed == customerCompany ? _self.customerCompany : customerCompany // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,engineSize: freezed == engineSize ? _self.engineSize : engineSize // ignore: cast_nullable_to_non_nullable
as String?,transmissionType: null == transmissionType ? _self.transmissionType : transmissionType // ignore: cast_nullable_to_non_nullable
as TransmissionType,registration: null == registration ? _self.registration : registration // ignore: cast_nullable_to_non_nullable
as String,kilometers: null == kilometers ? _self.kilometers : kilometers // ignore: cast_nullable_to_non_nullable
as int,engineCode: freezed == engineCode ? _self.engineCode : engineCode // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
