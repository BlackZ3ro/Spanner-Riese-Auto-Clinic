import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/phone_number.dart';
import '../models/vehicle_booking.dart';

/// Builds the "here is your reference code" message and opens WhatsApp or the
/// SMS app with it ready to go. Nothing is sent automatically: the staff
/// member always taps Send themselves.
class ReferenceCodeMessenger {
  ReferenceCodeMessenger._();

  /// The name customers will see for the app on their phone.
  static const appName = 'Riese Auto Clinic';

  /// Optional link for downloading the app. Leave empty until you have one.
  static const appDownloadLink = '';

  static String _greeting(VehicleBooking b) {
    final name = b.customerName.trim();
    if (name.isEmpty) return 'Hi,';
    return 'Hi ${name.split(RegExp(r'\s+')).first},';
  }

  static String _vehicle(VehicleBooking b) => '${b.brand} ${b.model} (${b.registration})';

  /// WhatsApp version. The code sits on its own line in monospace so it is easy to spot.
  static String whatsappMessage(VehicleBooking b) {
    return [
      _greeting(b),
      '',
      'Your ${_vehicle(b)} has been booked in at $appName.',
      '',
      'Your reference code:',
      '```${b.referenceCode}```',
      '',
      'Open the $appName app, tap "I\'m a customer" and enter this code to follow your vehicle\'s progress.',
      if (appDownloadLink.isNotEmpty) ...['', 'Get the app: $appDownloadLink'],
    ].join('\n');
  }

  /// Shorter plain-text version for SMS.
  static String smsMessage(VehicleBooking b) {
    final link = appDownloadLink.isEmpty ? '' : ' $appDownloadLink';
    return '$appName: your ${_vehicle(b)} is booked in. '
        'Reference code: ${b.referenceCode}. '
        'In the app tap "I\'m a customer" and enter it to follow progress.$link';
  }

  /// Opens WhatsApp (the app, or WhatsApp Web on a computer) with the customer's
  /// number and the message filled in. False if the number is unusable or
  /// WhatsApp could not be opened.
  static Future<bool> openWhatsApp(VehicleBooking b) async {
    final digits = PhoneNumber.international(b.customerPhone);
    if (digits == null) return false;
    final text = Uri.encodeComponent(whatsappMessage(b));
    return _launch(Uri.parse('https://wa.me/$digits?text=$text'));
  }

  /// Opens the phone's SMS app with the number and message filled in.
  static Future<bool> openSms(VehicleBooking b) async {
    final number = PhoneNumber.e164(b.customerPhone);
    if (number == null) return false;
    final body = Uri.encodeComponent(smsMessage(b));
    // iOS expects "&body=", Android expects "?body=".
    final separator = defaultTargetPlatform == TargetPlatform.iOS ? '&' : '?';
    return _launch(Uri.parse('sms:$number${separator}body=$body'));
  }

  static Future<bool> _launch(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
