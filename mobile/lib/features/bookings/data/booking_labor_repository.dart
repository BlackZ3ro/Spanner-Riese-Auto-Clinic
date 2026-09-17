import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking_labor.dart';

class BookingLaborRepository {
  final _client = Supabase.instance.client;

  Future<List<BookingLabor>> fetchForBooking(String bookingId) async {
    final rows = await _client
      .from('booking_labor')
      .select()
      .eq('booking_id', bookingId)
      .order('created_at');
    return rows.map((row) => BookingLabor.fromJson(row)).toList();
  }

  Future<BookingLabor> add({
    required String bookingId,
    required String description,
    required double hours,
    required double rate,
  }) async {
    final price = hours * rate;
    final row = await _client
      .from('booking_labor')
      .insert({
        'booking_id' : bookingId,
        'description' : description,
        'hours' : hours,
        'rate' : rate,
        'price' : price,
      })
      .select()
      .single();
    return BookingLabor.fromJson(row);
  }

  Future<void> remove(String id) async {
    await _client.from('booking_labor').delete().eq('id', id);
  }
}