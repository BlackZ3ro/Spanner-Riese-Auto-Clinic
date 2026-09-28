import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/auth_repository.dart';
import '../data/profile_repository.dart';
import '../models/user_profile.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());
final profileRepositoryProvider = Provider((ref) => ProfileRepository());

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final authState = ref.watch(authStateProvider).value;
  final userId = authState?.session?.user.id ?? Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return null;
  return ref.watch(profileRepositoryProvider).fetchProfile(userId);
});