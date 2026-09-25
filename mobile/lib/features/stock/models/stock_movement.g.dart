// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockMovement _$StockMovementFromJson(Map<String, dynamic> json) =>
    _StockMovement(
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      type: $enumDecode(_$MovementTypeEnumMap, json['type']),
      quantity: (json['quantity'] as num).toInt(),
      costAtTime: (json['cost_at_time'] as num).toDouble(),
      reference: json['reference'] as String?,
      userId: json['user_id'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$StockMovementToJson(_StockMovement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_id': instance.itemId,
      'type': _$MovementTypeEnumMap[instance.type]!,
      'quantity': instance.quantity,
      'cost_at_time': instance.costAtTime,
      'reference': instance.reference,
      'user_id': instance.userId,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$MovementTypeEnumMap = {
  MovementType.stockIn: 'in',
  MovementType.stockOut: 'out',
};
