import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/presentation/role_choice_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/presentation/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb){
    await Firebase.initializeApp();
  }
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    if (!kIsWeb) {
      FirebaseMessaging.onMessage.listen((message) {
        final notification = message.notification;
        if (notification != null) {
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text('${notification.title}: ${notification.body}')),
          );
        }
      });
    }

    runApp(const ProviderScope(child: Stock_System_Riese_Auto_Clinic()));
}

class Stock_System_Riese_Auto_Clinic extends ConsumerWidget{
  const Stock_System_Riese_Auto_Clinic({super.key});

  @override 
  Widget build(BuildContext context, WidgetRef ref){
    final authState = ref.watch(authStateProvider);


    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'Stock System Riese Auto Clinic',
      home: authState.when(
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(),),),
        error: (e,_) => Scaffold(body: Center(child: Text('Auth error: $e'),),),
        data: (state) => state.session == null ? const RoleChoiceScreen() : const HomeScreen(),
      ),
    );
  }
}
