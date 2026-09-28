// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_labor_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerLaborView {

 String get description; double get hours;
/// Create a copy of CustomerLaborView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerLaborViewCopyWith<CustomerLaborView> get copyWith => _$CustomerLaborViewCopyWithImpl<CustomerLaborView>(this as CustomerLaborView, _$identity);

  /// Serializes this CustomerLaborView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerLaborView&&(identical(other.description, description) || other.description == description)&&(identical(other.hours, hours) || other.hours == hours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,description,hours);

@override
String toString() {
  return 'CustomerLaborView(description: $description, hours: $hours)';
}


}

/// @nodoc
abstract mixin class $CustomerLaborViewCopyWith<$Res>  {
  factory $CustomerLaborViewCopyWith(CustomerLaborView value, $Res Function(CustomerLaborView) _then) = _$CustomerLaborViewCopyWithImpl;
@useResult
$Res call({
 String description, double hours
});




}
/// @nodoc
class _$CustomerLaborViewCopyWithImpl<$Res>
    implements $CustomerLaborViewCopyWith<$Res> {
  _$CustomerLaborViewCopyWithImpl(this._self, this._then);

  final CustomerLaborView _self;
  final $Res Function(CustomerLaborView) _then;

/// Create a copy of CustomerLaborView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? description = null,Object? hours = null,}) {
  return _then(_self.copyWith(
description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerLaborView].
extension CustomerLaborViewPatterns on CustomerLaborView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerLaborView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerLaborView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerLaborView value)  $default,){
final _that = this;
switch (_that) {
case _CustomerLaborView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerLaborView value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerLaborView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String description,  double hours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerLaborView() when $default != null:
return $default(_that.description,_that.hours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String description,  double hours)  $default,) {final _that = this;
switch (_that) {
case _CustomerLaborView():
return $default(_that.description,_that.hours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String description,  double hours)?  $default,) {final _that = this;
switch (_that) {
case _CustomerLaborView() when $default != null:
return $default(_that.description,_that.hours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerLaborView implements CustomerLaborView {
  const _CustomerLaborView({required this.description, required this.hours});
  factory _CustomerLaborView.fromJson(Map<String, dynamic> json) => _$CustomerLaborViewFromJson(json);

@override final  String description;
@override final  double hours;

/// Create a copy of CustomerLaborView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerLaborViewCopyWith<_CustomerLaborView> get copyWith => __$CustomerLaborViewCopyWithImpl<_CustomerLaborView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerLaborViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerLaborView&&(identical(other.description, description) || other.description == description)&&(identical(other.hours, hours) || other.hours == hours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,description,hours);

@override
String toString() {
  return 'CustomerLaborView(description: $description, hours: $hours)';
}


}

/// @nodoc
abstract mixin class _$CustomerLaborViewCopyWith<$Res> implements $CustomerLaborViewCopyWith<$Res> {
  factory _$CustomerLaborViewCopyWith(_CustomerLaborView value, $Res Function(_CustomerLaborView) _then) = __$CustomerLaborViewCopyWithImpl;
@override @useResult
$Res call({
 String description, double hours
});




}
/// @nodoc
class __$CustomerLaborViewCopyWithImpl<$Res>
    implements _$CustomerLaborViewCopyWith<$Res> {
  __$CustomerLaborViewCopyWithImpl(this._self, this._then);

  final _CustomerLaborView _self;
  final $Res Function(_CustomerLaborView) _then;

/// Create a copy of CustomerLaborView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? description = null,Object? hours = null,}) {
  return _then(_CustomerLaborView(
description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
