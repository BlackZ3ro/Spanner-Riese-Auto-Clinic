// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_part_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerPartView _$CustomerPartViewFromJson(Map<String, dynamic> json) =>
    _CustomerPartView(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CustomerPartViewToJson(_CustomerPartView instance) =>
    <String, dynamic>{'name': instance.name, 'quantity': instance.quantity};
