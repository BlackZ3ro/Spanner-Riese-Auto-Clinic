import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../features/customer/presentation/customer_status_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> openStatusFromMessage(RemoteMessage message) async {
  final code = message.data['reference_code'];
  if (code is! String || code.isEmpty) return;

  for (var i = 0; i < 30 && navigatorKey.currentState == null; i++) {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (_) => CustomerStatusScreen(referenceCode: code))
  );
}

void showForegroundNotification(RemoteMessage message) {
  final notification = message.notification;
  if (notification == null) return;

  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text('${notification.title}: ${notification.body}'),
      action: SnackBarAction(
        label: 'View', 
        onPressed: () => openStatusFromMessage(message),
        ),
      )
  );
}