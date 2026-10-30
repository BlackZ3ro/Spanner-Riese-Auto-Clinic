import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../stock/providers/stock_item_provider.dart';
import '../../stock/models/stock_movement.dart';
import '../../stock/providers/stock_movement_service.dart';
import 'booking_parts_provider.dart';

class BookingPartService {
  BookingPartService(this.ref);
  final Ref ref;

  // One database call (add_booking_part, migration 0004): it checks the stock,
  // lowers it, saves the part and writes the stock movement in a single
  // transaction, the same function the website uses. If anything fails, nothing
  // is saved, so stock can never end up out of step with the booking.
  Future<void> allocatePart({
    required String bookingId,
    required String stockItemId,
    required int quantity,
    required double customerPrice,
    required double costPrice,
    required String registration,
  }) async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('You are signed out. Sign in again to add a part.');
    }

    final rows = await client.rpc('add_booking_part', params: {
      'p_booking_id': bookingId,
      'p_stock_item_id': stockItemId,
      'p_qty': quantity,
      'p_unit_price': customerPrice,
      'p_user_id': userId,
      'p_reference': 'Booking $registration',
    });

    final result = (rows is List && rows.isNotEmpty) ? rows.first as Map : const {};
    if (result['ok'] != true) {
      throw Exception('Not enough stock (${result['quantity_on_hand'] ?? 0} left).');
    }
    ref.invalidate(bookingPartsProvider(bookingId));
    ref.invalidate(stockItemProvider);
  }

  Future<void> removePart({
    required String partId,
    required String stockItemId,
    required int quantity,
    required double costPrice,
    required String registration,
  }) async {
    final repo = ref.read(bookingPartRepositoryProvider);
    await repo.remove(partId);

    await ref.read(stockMovementServiceProvider).recordMovement(
      itemId: stockItemId, 
      type: MovementType.stockIn, 
      quantity: quantity, 
      costAtTime: costPrice,
      reference: 'Removed from booking $registration',
      );
  }
}

final bookingPartServiceProvider = Provider((ref) => BookingPartService(ref));