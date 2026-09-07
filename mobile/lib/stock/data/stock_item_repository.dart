import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/stock_item.dart';

class StockItemRepository {
  final _client = Supabase.instance.client;

  Future<List<StockItem>> fetchAll() async{
    final rows = await _client.from('stock_items').select().order('name');
    return rows.map((row) => StockItem.fromJson(row)).toList();
  }

  Future<StockItem> add({
    required String sku,
    required String name,
    required String categoryId,
    required String supplierId,
    required double costPrice,
    required double sellPrice,
    required int quantityOnHand,
    required int reorderLevel, 
  }) async {
    final row = await _client
      .from('stock_items')
      .insert({
        'sku': sku,
        'name': name,
        'category_id': categoryId,
        'supplier_id':supplierId,
        'cost_price': costPrice,
        'sell_price': sellPrice,
        'quantity_on_hand': quantityOnHand,
        'reorder_level': reorderLevel,
      })
      .select()
      .single();
      return StockItem.fromJson(row);
  }

  Future<void> remove (String id) async {
    await _client.from('stock_items').delete().eq('id', id);
  }

  Future<StockItem> updateQuantityAndCost(
    String id, 
    int newQuantity,{
    double? newCostPrice
    }) async {
      final updateMap = <String, dynamic>{'quantity_on_hand': newQuantity};
      if (newCostPrice != null) updateMap['cost_price'] = newCostPrice;

    final row = await _client
      .from('stock_items')
      .update(updateMap)
      .eq('id', id)
      .select()
      .single();
      return StockItem.fromJson(row);
  }
}