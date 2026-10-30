import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PushNotificationService {
  final _client = Supabase.instance.client;
  static const _lastCodeKey = 'last_reference_code';

  Future<String?> getLastReferenceCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastCodeKey);
  }

  Future<void> saveLastReferenceCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastCodeKey, code.trim().toUpperCase());
  }

  Future<void> registerForNotifications(String referenceCode) async {
    if (kIsWeb) return; // push needs Firebase, which is only set up for Android
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    final token = await messaging.getToken();
    if (token == null) return;

    await _client.rpc('register_push_token', params: {
      'p_reference_code' : referenceCode,
      'p_token': token,
    });
  }
}