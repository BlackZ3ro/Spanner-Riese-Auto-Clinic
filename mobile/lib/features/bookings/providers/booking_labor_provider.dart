import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/booking_labor_repository.dart';
import '../models/booking_labor.dart';

final bookingLaborRepositoryProvider = Provider((ref) => BookingLaborRepository());

class BookingLaborNotifier extends AsyncNotifier<List<BookingLabor>> {

  BookingLaborNotifier(this.bookingId);
  final String bookingId;
  @override
  Future<List<BookingLabor>> build() {
    return ref.read(bookingLaborRepositoryProvider).fetchForBooking(bookingId);
  }

  Future<void> addLabor ({
    required String description, 
    required double hours,
    required double rate,
    }) async{
    final repo = ref.read(bookingLaborRepositoryProvider);
    final newItem = await repo.add(
      bookingId: bookingId, 
      description: description, 
      hours: hours,
      rate: rate
      );
    final current = state.value ?? [];
    state = AsyncData([...current, newItem]);
  }

  Future<void> removeLabor(String id) async{
    final repo = ref.read(bookingLaborRepositoryProvider);
    await repo.remove(id);
    final current = state.value ?? [];
    state = AsyncData(current.where((l) => l.id != id).toList()); 
  }
}

final bookingLaborProvider = 
  AsyncNotifierProvider.family<BookingLaborNotifier, List<BookingLabor>, String>(
    BookingLaborNotifier.new);
  