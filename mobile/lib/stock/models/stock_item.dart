import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_item.freezed.dart';
part 'stock_item.g.dart';

@freezed
abstract class StockItem with _$StockItem {
  const factory StockItem({
    required String id,
    required String sku,
    required String name,
    required String categoryId,
    required String supplierId,
    required double costPrice,
    required double sellPrice,
    required int quantityOnHand,
    required int reorderLevel,
    DateTime? createdAt,
  }) = _StockItem;

  factory StockItem.fromJson(Map<String, dynamic> json) =>
      _$StockItemFromJson(json);
}