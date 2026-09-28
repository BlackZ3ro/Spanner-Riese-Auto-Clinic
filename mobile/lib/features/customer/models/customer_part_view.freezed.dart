// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_part_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerPartView {

 String get name; int get quantity;
/// Create a copy of CustomerPartView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerPartViewCopyWith<CustomerPartView> get copyWith => _$CustomerPartViewCopyWithImpl<CustomerPartView>(this as CustomerPartView, _$identity);

  /// Serializes this CustomerPartView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerPartView&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,quantity);

@override
String toString() {
  return 'CustomerPartView(name: $name, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $CustomerPartViewCopyWith<$Res>  {
  factory $CustomerPartViewCopyWith(CustomerPartView value, $Res Function(CustomerPartView) _then) = _$CustomerPartViewCopyWithImpl;
@useResult
$Res call({
 String name, int quantity
});




}
/// @nodoc
class _$CustomerPartViewCopyWithImpl<$Res>
    implements $CustomerPartViewCopyWith<$Res> {
  _$CustomerPartViewCopyWithImpl(this._self, this._then);

  final CustomerPartView _self;
  final $Res Function(CustomerPartView) _then;

/// Create a copy of CustomerPartView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerPartView].
extension CustomerPartViewPatterns on CustomerPartView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerPartView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerPartView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerPartView value)  $default,){
final _that = this;
switch (_that) {
case _CustomerPartView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerPartView value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerPartView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerPartView() when $default != null:
return $default(_that.name,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _CustomerPartView():
return $default(_that.name,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _CustomerPartView() when $default != null:
return $default(_that.name,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerPartView implements CustomerPartView {
  const _CustomerPartView({required this.name, required this.quantity});
  factory _CustomerPartView.fromJson(Map<String, dynamic> json) => _$CustomerPartViewFromJson(json);

@override final  String name;
@override final  int quantity;

/// Create a copy of CustomerPartView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerPartViewCopyWith<_CustomerPartView> get copyWith => __$CustomerPartViewCopyWithImpl<_CustomerPartView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerPartViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerPartView&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,quantity);

@override
String toString() {
  return 'CustomerPartView(name: $name, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$CustomerPartViewCopyWith<$Res> implements $CustomerPartViewCopyWith<$Res> {
  factory _$CustomerPartViewCopyWith(_CustomerPartView value, $Res Function(_CustomerPartView) _then) = __$CustomerPartViewCopyWithImpl;
@override @useResult
$Res call({
 String name, int quantity
});




}
/// @nodoc
class __$CustomerPartViewCopyWithImpl<$Res>
    implements _$CustomerPartViewCopyWith<$Res> {
  __$CustomerPartViewCopyWithImpl(this._self, this._then);

  final _CustomerPartView _self;
  final $Res Function(_CustomerPartView) _then;

/// Create a copy of CustomerPartView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? quantity = null,}) {
  return _then(_CustomerPartView(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
