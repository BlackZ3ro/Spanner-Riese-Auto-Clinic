import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/supplier.dart';

class SupplierRepository {
  final _client = Supabase.instance.client;

  Future<List<Supplier>> fetchAll() async{
    final rows = await _client.from('suppliers').select().order('name');
    return rows.map((row) => Supplier.fromJson(row)).toList();
  }

  Future<Supplier> add(String name, {String? contactInfo}) async{
    final row = await _client
      .from('suppliers')
      .insert({
        'name': name,
        if (contactInfo != null) 'contact_info' : contactInfo,
        })
      .select()
      .single();
    return Supplier.fromJson(row);
  }

  Future<void> remove(String id) async {
    await _client.from('suppliers').delete().eq('id', id);
  }
}