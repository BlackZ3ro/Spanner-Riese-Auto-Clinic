// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockItem _$StockItemFromJson(Map<String, dynamic> json) => _StockItem(
  id: json['id'] as String,
  sku: json['sku'] as String,
  name: json['name'] as String,
  categoryId: json['category_id'] as String,
  supplierId: json['supplier_id'] as String,
  costPrice: (json['cost_price'] as num).toDouble(),
  sellPrice: (json['sell_price'] as num).toDouble(),
  quantityOnHand: (json['quantity_on_hand'] as num).toInt(),
  reorderLevel: (json['reorder_level'] as num).toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$StockItemToJson(_StockItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'category_id': instance.categoryId,
      'supplier_id': instance.supplierId,
      'cost_price': instance.costPrice,
      'sell_price': instance.sellPrice,
      'quantity_on_hand': instance.quantityOnHand,
      'reorder_level': instance.reorderLevel,
      'created_at': instance.createdAt?.toIso8601String(),
    };
