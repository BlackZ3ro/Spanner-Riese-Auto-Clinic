import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking_part.dart';

class BookingPartRepository {
  final _client = Supabase.instance.client;

  Future<List<BookingPart>> fetchForBooking(String bookingId) async {
    final rows = await _client
        .from('booking_parts')
        .select()
        .eq('booking_id', bookingId)
        .order('created_at');
    return rows.map((row) => BookingPart.fromJson(row)).toList();
  }

  Future<BookingPart> add({
    required String bookingId,
    required String stockItemId,
    required int quantity,
    required double unitPrice,
  }) async {
    final row = await _client
        .from('booking_parts')
        .insert({
          'booking_id': bookingId,
          'stock_item_id': stockItemId,
          'quantity': quantity,
          'unit_price': unitPrice,
        })
        .select()
        .single();
    return BookingPart.fromJson(row);
  }


  Future<void> removeAllForBooking(String bookingId) async {
    await _client.from('booking_parts').delete().eq('booking_id', bookingId);
  }

  Future<void> remove(String id) async {
    await _client.from('booking_parts').delete().eq('id', id);
  }

  
}