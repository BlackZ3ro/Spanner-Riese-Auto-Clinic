// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_labor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingLabor _$BookingLaborFromJson(Map<String, dynamic> json) =>
    _BookingLabor(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      description: json['description'] as String,
      hours: (json['hours'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BookingLaborToJson(_BookingLabor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_id': instance.bookingId,
      'description': instance.description,
      'hours': instance.hours,
      'rate': instance.rate,
      'price': instance.price,
      'created_at': instance.createdAt?.toIso8601String(),
    };
