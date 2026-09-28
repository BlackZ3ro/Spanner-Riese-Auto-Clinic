import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

class ProfileRepository {
  final _client = Supabase.instance.client;

  Future<UserProfile> fetchProfile(String userId) async{
    final row = await _client.from('profiles').select().eq('id', userId).single();
    return UserProfile.fromJson(row);
  }
}