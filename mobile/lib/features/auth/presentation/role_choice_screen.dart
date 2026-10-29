import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../customer/presentation/customer_lookup_screen.dart';
import 'login_screen.dart';

class RoleChoiceScreen extends StatelessWidget {
  const RoleChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.overlayStyle,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 48),
            child: Column(
              children: [
                const Spacer(flex: 11),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.build_outlined, size: 30, color: AppColors.onGold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Riese Auto Clinic',
                  textAlign: TextAlign.center,
                  style: AppText.heading(26, letterSpacing: -0.3),
                ),
                const SizedBox(height: 6),
                Text(
                  'Workshop management',
                  textAlign: TextAlign.center,
                  style: AppText.body(14, color: AppColors.textMuted),
                ),
                const Spacer(flex: 14),
                FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const CustomerLookupScreen())),
                  child: const Text("I'm a customer"),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const LoginScreen())),
                  child: const Text('I work here'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
