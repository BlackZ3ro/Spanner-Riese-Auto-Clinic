// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingPart _$BookingPartFromJson(Map<String, dynamic> json) => _BookingPart(
  id: json['id'] as String,
  bookingId: json['booking_id'] as String,
  stockItemId: json['stock_item_id'] as String,
  quantity: (json['quantity'] as num).toInt(),
  unitPrice: (json['unit_price'] as num).toDouble(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$BookingPartToJson(_BookingPart instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_id': instance.bookingId,
      'stock_item_id': instance.stockItemId,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'created_at': instance.createdAt?.toIso8601String(),
    };
