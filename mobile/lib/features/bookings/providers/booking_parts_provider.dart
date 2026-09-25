import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/booking_part_repository.dart';
import '../models/booking_part.dart';

final bookingPartRepositoryProvider = Provider((ref) => BookingPartRepository());

class BookingPartsNotifier extends AsyncNotifier<List<BookingPart>> {
    BookingPartsNotifier(this.bookingId);
    final String bookingId;
    
     @override
     Future<List<BookingPart>> build() {
        return ref.read(bookingPartRepositoryProvider).fetchForBooking(bookingId);
     }

     Future<void> removePart(String id) async {
        final repo = ref.read(bookingPartRepositoryProvider);
        await repo.remove(id);
        final current = state.value ?? [];
        state = AsyncData(current.where((p) => p.id != id).toList());
     }
}

final bookingPartsProvider = 
    AsyncNotifierProvider.family<BookingPartsNotifier,  List<BookingPart>, String>(
        BookingPartsNotifier.new);