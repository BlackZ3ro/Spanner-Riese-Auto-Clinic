import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../customer/presentation/customer_lookup_screen.dart';
import 'login_screen.dart';

class RoleChoiceScreen extends StatelessWidget {
  const RoleChoiceScreen({super.key});

  /// Shown under the logo. Change the wording here.
  static const tagline = 'Spanner workshop system';

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
                Image.asset(
                  'assets/images/riese_logo.png',
                  width: 340,
                  fit: BoxFit.contain,
                  semanticLabel: 'Riese Auto Clinic',
                  // If the image ever fails to load, fall back to the name as text.
                  errorBuilder: (_, _, _) => Text(
                    'Riese Auto Clinic',
                    textAlign: TextAlign.center,
                    style: AppText.heading(26, letterSpacing: -0.3),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tagline,
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
