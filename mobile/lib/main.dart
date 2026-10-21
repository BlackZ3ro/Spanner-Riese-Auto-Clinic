import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/notifications/notification_router.dart';
import 'features/auth/presentation/role_choice_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/presentation/home_screen.dart';
import 'core/theme/app_theme.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  if (!kIsWeb){
    await Firebase.initializeApp();
  }

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    if(!kIsWeb){
      FirebaseMessaging.onMessage.listen(showForegroundNotification);
      FirebaseMessaging.onMessageOpenedApp.listen(openStatusFromMessage);
    }

    runApp(const ProviderScope(child: Spanner()));

    if (!kIsWeb) {
      final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        openStatusFromMessage(initialMessage);
      }
    }
}

class Spanner extends ConsumerWidget{
  const Spanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'Spanner', 
      theme: AppTheme.dark(),
      home: authState.when(
        data: (state) => state.session == null ? const RoleChoiceScreen() : const HomeScreen(), 
        error: (e, _) => Scaffold(body: Center(child: Text('Auth error: $e'),)), 
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(),),)
        ),
    );
  }
}