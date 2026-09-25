import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/customer.dart';

class CustomerRepository {
  final _client =  Supabase.instance.client;

  Future<List<Customer>> search(String query) async {
    if (query.trim().isEmpty) return [];
    final rows = await _client
      .from('customers')
      .select()
      .or('name.ilike.%$query%,phone.ilike.%$query%')
      .order('name')
      .limit(5);
    return rows.map((row) => Customer.fromJson(row)).toList();
  }

  Future<Customer> add({
    required String name,
    required String phone,
    String? email,
    String? company,
  }) async {
    final row = await _client
      .from('customers')
      .insert({
        'name' : name,
        'phone' : phone,
        if (email != null) 'email' : email,
        if (company != null) 'company' : company,
      })
      .select()
      .single();
    return Customer.fromJson(row);
  }
}


