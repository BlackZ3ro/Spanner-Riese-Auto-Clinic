import 'package:flutter_riverpod/legacy.dart';
import '../models/user_role.dart';

final currentRoleProvider = StateProvider<UserRole?>((ref) => null);