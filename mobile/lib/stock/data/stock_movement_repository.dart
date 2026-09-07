import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/stock_movement.dart';

class StockMovementRepository {
  final _client = Supabase.instance.client;

  Future<StockMovement> add ({
    required String itemId,
    required MovementType type,
    required int quantity,
    required double costAtTime,
    String? reference,
    String? userId,
  }) async {
    final row = await _client
    .from('stock_movements')
    .insert({
      'item_id' : itemId,
      'type' : type == MovementType.stockIn ? 'in' : 'out',
      'quantity' : quantity,
      'cost_at_time' : costAtTime,
      if (reference != null) 'reference' : reference,
      if (userId != null) 'user_id' : userId,
    })
    .select()
    .single();
    return StockMovement.fromJson(row);
  }

  Future<List<StockMovement>> fetchForItem(String itemId) async {
    final rows = await _client
      .from('stock_movements')
      .select()
      .eq('item_id', itemId)
      .order('timestamp', ascending : false);
      return rows.map((row) => StockMovement.fromJson(row)).toList();
  }
}