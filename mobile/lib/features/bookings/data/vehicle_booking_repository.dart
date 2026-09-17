import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transmission_type.dart';
import '../models/vehicle_booking.dart';

class VehicleBookingRepository {
  final _client = Supabase.instance.client;

  Future<List<VehicleBooking>> fetchAll() async{
    final rows =
    await _client.from('bookings').select().order('created_at', ascending: false);
    return rows.map((row) => VehicleBooking.fromJson(row)).toList();
  }

  Future<VehicleBooking> add({
    String? customerId,
    required String customerName,
    required String customerPhone,
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
    final row = await _client
      .from('bookings')
      .insert({
        if (customerId != null) 'customer_id' : customerId,
        'customer_name' : customerName,
        'customer_phone' : customerPhone,
        if (customerEmail != null) 'customer_email' : customerEmail,
        if (customerCompany != null) 'customer_company' : customerCompany,
        'brand' : brand,
        'model' : model,
        'year' : year,
        if (engineSize != null) 'engine_size' : engineSize,
        'transmission_type' : _transmissionToDb(transmissionType),
        'registration' : registration,
        'kilometers' : kilometers,
        if (engineCode != null) 'engine_code' : engineCode,
        if (imageUrl != null) 'image_url' : imageUrl,
      })
      .select()
      .single();
    return VehicleBooking.fromJson(row);
  }

  Future<void> remove(String id) async {
    await _client.from('bookings').delete().eq('id', id);
  }

  String _transmissionToDb(TransmissionType type) {
    switch (type) {
       case TransmissionType.manual:
        return 'manual';
      case TransmissionType.automatic:
        return 'automatic';
      case TransmissionType.cvt:
        return 'cvt';
      case TransmissionType.semiAutomatic:
        return 'semi_automatic';
    }
  }

  Future<VehicleBooking> close(String id) async {
    final row = await _client
      .from('bookings')
      .update({
        'status': 'closed',
        'closed_at' : DateTime.now().toIso8601String(),
      })
      .eq('id', id)
      .select()
      .single();
    return VehicleBooking.fromJson(row);
  }
}