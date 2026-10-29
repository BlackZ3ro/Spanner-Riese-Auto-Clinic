import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// The email and password saved for fingerprint sign-in.
class BiometricCredentials {
  const BiometricCredentials({required this.email, required this.password});

  final String email;
  final String password;
}

/// Optional fingerprint sign-in.
///
/// After a normal password sign-in the person can choose "use fingerprint next
/// time". Their login is then kept in the phone's secure storage (Android
/// Keystore) and is only handed back after a successful fingerprint check.
/// Nothing is saved unless they opt in, and turning it off deletes it.
class BiometricAuthService {
  BiometricAuthService({LocalAuthentication? auth, FlutterSecureStorage? storage})
      : _auth = auth ?? LocalAuthentication(),
        _storage = storage ?? const FlutterSecureStorage();

  static const _emailKey = 'biometric_login_email';
  static const _passwordKey = 'biometric_login_password';

  final LocalAuthentication _auth;
  final FlutterSecureStorage _storage;

  /// True when this phone has a fingerprint (or face) enrolled. Always false on web.
  Future<bool> isAvailable() async {
    if (kIsWeb) return false;
    try {
      if (!await _auth.isDeviceSupported()) return false;
      final enrolled = await _auth.getAvailableBiometrics();
      return enrolled.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// True when a login has been saved for fingerprint sign-in.
  Future<bool> isEnabled() async {
    try {
      return await _storage.containsKey(key: _passwordKey);
    } catch (_) {
      return false;
    }
  }

  /// Shows the fingerprint prompt. False if cancelled, locked out, or failed.
  Future<bool> _confirm(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason, biometricOnly: true);
    } catch (_) {
      return false;
    }
  }

  /// Confirms the fingerprint, then saves the login for next time.
  Future<bool> enable({required String email, required String password}) async {
    if (!await _confirm('Confirm your fingerprint to turn on fingerprint sign-in')) {
      return false;
    }
    try {
      await _storage.write(key: _emailKey, value: email);
      await _storage.write(key: _passwordKey, value: password);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Shows the fingerprint prompt and returns the saved login, or null if the
  /// prompt was cancelled or failed.
  Future<BiometricCredentials?> unlock() async {
    if (!await _confirm('Sign in to Riese Auto Clinic')) return null;
    try {
      final email = await _storage.read(key: _emailKey);
      final password = await _storage.read(key: _passwordKey);
      if (email == null || password == null) return null;
      return BiometricCredentials(email: email, password: password);
    } catch (_) {
      return null;
    }
  }

  /// Deletes the saved login.
  Future<void> disable() async {
    try {
      await _storage.delete(key: _emailKey);
      await _storage.delete(key: _passwordKey);
    } catch (_) {
      // Nothing useful to do if the phone's storage fails.
    }
  }
}
