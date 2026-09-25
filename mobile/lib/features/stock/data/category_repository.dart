import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

class CategoryRepository {
  final _client = Supabase.instance.client;

  Future<List<Category>> fetchAll() async{
    final rows = await _client.from('categories').select().order('name');
    return rows.map((row) => Category.fromJson(row)).toList();
  }

  Future<Category> add(String name) async{
    final row = await _client
      .from('categories')
      .insert({'name': name})
      .select()
      .single();
    return Category.fromJson(row);
  }

  Future<void> remove(String id) async {
    await _client.from('categories').delete().eq('id', id);
  }
}