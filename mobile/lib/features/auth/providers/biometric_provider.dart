import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/biometric_auth_service.dart';

final biometricAuthServiceProvider = Provider((ref) => BiometricAuthService());
