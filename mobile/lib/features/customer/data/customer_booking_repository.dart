import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/customer_booking_view.dart';

class CustomerBookingRepository {
  final _client = Supabase.instance.client;

  Future<CustomerBookingView?> lookupByReferenceCode(String code) async {
    final result = await  _client.rpc('get_booking_by_reference_code', params: {
      'p_code': code.trim(),
    });
    if (result == null) return null;
    return CustomerBookingView.fromJson(result as Map<String, dynamic>);
  }
}