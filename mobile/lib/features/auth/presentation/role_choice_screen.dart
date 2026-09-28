import 'package:flutter/material.dart';
import '../../customer/presentation/customer_lookup_screen.dart';
import 'login_screen.dart';

class RoleChoiceScreen extends StatelessWidget {
  const RoleChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Riese Auto Clinic',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const CustomerLookupScreen())),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("I'm a customer"),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const LoginScreen())),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('I work here'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}