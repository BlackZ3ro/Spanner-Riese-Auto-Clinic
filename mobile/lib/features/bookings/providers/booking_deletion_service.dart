import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../stock/providers/stock_item_provider.dart';
import '../models/vehicle_booking.dart';
import 'vehicle_booking_provider.dart';

class BookingDeletionService {
  BookingDeletionService(this.ref);
  final Ref ref;

  // One database call (supabase/migrations/0007) restocks every part, removes
  // labour and parts, then deletes the booking in a single transaction - the
  // same function the web app uses. The old version did this in several
  // separate calls, so a failure halfway left stock and bookings out of sync.
  // The function also refuses anyone who isn't an admin.
  Future<void> deleteBooking(VehicleBooking booking) async {
    final client = Supabase.instance.client;
    await client.rpc('delete_booking_and_restock', params: {
      'p_booking_id': booking.id,
      'p_user_id': client.auth.currentUser?.id,
    });

    // The row is already gone; this just drops it from the local list.
    await ref.read(vehicleBookingProvider.notifier).removeBooking(booking.id);
    ref.invalidate(stockItemProvider);
  }
}

final bookingDeletionServiceProvider = Provider((ref) => BookingDeletionService(ref));
