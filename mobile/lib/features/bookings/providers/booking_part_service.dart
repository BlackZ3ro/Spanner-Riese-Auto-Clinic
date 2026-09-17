import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../stock/models/stock_movement.dart';
import '../../stock/providers/stock_movement_service.dart';
import '../models/booking_part.dart';
import 'booking_parts_provider.dart';

class BookingPartService {
  BookingPartService(this.ref);
  final Ref ref;

  Future<BookingPart> allocatePart({
    required String bookingId,
    required String stockItemId,
    required int quantity,
    required double customerPrice,
    required double costPrice,
    required String registration,
  }) async {
    final repo = ref.read(bookingPartRepositoryProvider);

    final part = await repo.add(
      bookingId: bookingId, 
      stockItemId: stockItemId, 
      quantity: quantity, 
      unitPrice: customerPrice,
      );

      await ref.read(stockMovementServiceProvider).recordMovement(
        itemId: stockItemId, 
        type: MovementType.stockOut, 
        quantity: quantity, 
        costAtTime: costPrice,
        reference: 'Booking $registration',
        );

        return part;
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