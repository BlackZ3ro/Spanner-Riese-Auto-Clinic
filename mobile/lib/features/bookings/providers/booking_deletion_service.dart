import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../stock/models/stock_movement.dart';
import '../../stock/providers/stock_item_provider.dart';
import '../../stock/providers/stock_movement_service.dart';
import '../models/vehicle_booking.dart';
import 'booking_labor_provider.dart';
import 'booking_parts_provider.dart';
import 'vehicle_booking_provider.dart';

class BookingDeletionService {
  BookingDeletionService(this.ref);
  final Ref ref;

  Future<void> deleteBooking(VehicleBooking booking) async {
    final partRepo = ref.read(bookingPartRepositoryProvider);
    final stockItems = ref.read(stockItemProvider).value ?? [];
    final parts = await partRepo.fetchForBooking(booking.id);

    for (final part in parts) {
      final item = stockItems.firstWhere(
        (i) => i.id == part.stockItemId,
        orElse: () => stockItems.first,
      );
      await ref.read(stockMovementServiceProvider).recordMovement(
            itemId: part.stockItemId,
            type: MovementType.stockIn,
            quantity: part.quantity,
            costAtTime: item.costPrice,
            reference: 'Booking ${booking.registration} deleted',
          );
    }

    await partRepo.removeAllForBooking(booking.id);
    await ref.read(bookingLaborRepositoryProvider).removeAllForBooking(booking.id);
    await ref.read(vehicleBookingProvider.notifier).removeBooking(booking.id);
  }
}

final bookingDeletionServiceProvider = Provider((ref) => BookingDeletionService(ref));