import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_system_riese_auto_clinic/features/bookings/models/booking_phase.dart';
import '../data/vehicle_booking_repository.dart';
import '../models/transmission_type.dart';
import '../models/vehicle_booking.dart';

final vehicleBookingRepositoryProvider = Provider((ref) => VehicleBookingRepository());

class VehicleBookingNotifier extends AsyncNotifier<List<VehicleBooking>> {
  @override
  Future<List<VehicleBooking>> build(){
    return ref.read(vehicleBookingRepositoryProvider).fetchAll();
  }

  Future<void> addBooking({
    String? customerId,
    required customerName,
    required customerPhone,
    String? customerEmail,
    String? customerCompany,
    required String brand,
    required String model,
    required int year,
    String? engineSize,
    required TransmissionType transmissionType,
    required String registration,
    required int kilometers,
    String? engineCode,
    String? imageUrl,
  }) async {
    final repo = ref.read(vehicleBookingRepositoryProvider);
    final newBooking = await repo.add(
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      customerCompany: customerCompany,
      brand: brand, 
      model: model, 
      year: year, 
      engineSize: engineSize,
      transmissionType: transmissionType, 
      registration: registration, 
      kilometers: kilometers,
      engineCode: engineCode,
      imageUrl: imageUrl,
      );
      final current = state.value ?? [];
      state = AsyncData([newBooking, ...current]);
  }

  Future<void> removeBooking(String id) async{
    final repo = ref.read(vehicleBookingRepositoryProvider);
    await repo.remove(id);
    final current = state.value ?? [];
    state = AsyncData(current.where((b) => b.id != id).toList());
  }

  Future<void> closeBooking(String id) async {
    final repo = ref.read(vehicleBookingRepositoryProvider);
    final updated =  await repo.close(id);
    final current = state.value ?? [];
    state = AsyncData([
      for (final b in current)
        if (b.id == id) updated else b,
    ]);
  }

  Future<void> reopenBooking(String id) async {
    final repo = ref.read(vehicleBookingRepositoryProvider);
    final updated = await repo.reopen(id);
    final current = state.value ?? [];
    state = AsyncData([
      for(final b in current)
      if (b.id == id) updated else b,
    ]);
  }

  Future<void> updatePhase(String id, BookingPhase phase) async {
    final repo = ref.read(vehicleBookingRepositoryProvider);
    final updated = await repo.updatePhase(id, phase);
    final current = state.value ?? [];
    state = AsyncData([
      for(final b in current)
        if (b.id == id) updated else b,
    ]);
  }
}

final vehicleBookingProvider = 
  AsyncNotifierProvider<VehicleBookingNotifier, List<VehicleBooking>>(
    VehicleBookingNotifier.new);
  