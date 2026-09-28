// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_labor_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerLaborView _$CustomerLaborViewFromJson(Map<String, dynamic> json) =>
    _CustomerLaborView(
      description: json['description'] as String,
      hours: (json['hours'] as num).toDouble(),
    );

Map<String, dynamic> _$CustomerLaborViewToJson(_CustomerLaborView instance) =>
    <String, dynamic>{
      'description': instance.description,
      'hours': instance.hours,
    };
