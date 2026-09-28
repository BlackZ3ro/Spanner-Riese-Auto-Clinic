import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/push_notification_service.dart';

final pushNotificationServiceProvider = Provider((ref) => PushNotificationService());