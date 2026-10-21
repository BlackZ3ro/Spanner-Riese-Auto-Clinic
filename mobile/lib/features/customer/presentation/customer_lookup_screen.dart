import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../providers/customer_booking_provider.dart';
import '../providers/push_notification_provider.dart';
import 'customer_status_screen.dart';

class CustomerLookupScreen extends ConsumerStatefulWidget {
  const CustomerLookupScreen({super.key});

  @override
  ConsumerState<CustomerLookupScreen> createState() => _CustomerLookupScreenState();
}

class _CustomerLookupScreenState extends ConsumerState<CustomerLookupScreen> {
  final _codeController = TextEditingController();
  bool _looking = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    ref.read(pushNotificationServiceProvider).getLastReferenceCode().then((code) {
      if (code != null && mounted) _codeController.text = code;
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _looking = true;
      _error = null;
    });

    try {
      final view = await ref.read(customerBookingRepositoryProvider).lookupByReferenceCode(code);
      if (!mounted) return;

      if (view == null) {
        setState(() {
          _error = 'No booking found for that reference code.';
          _looking = false;
        });
        return;
      }

      final push = ref.read(pushNotificationServiceProvider);
      await push.saveLastReferenceCode(code);
      try {
        await push.registerForNotifications(code);
      } catch (_) {
        // Push is a nice-to-have. Never block the customer from seeing their status.
      }
      if (!mounted) return;

      setState(() => _looking = false);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CustomerStatusScreen(referenceCode: code, initialBooking: view),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Something went wrong. Check the code and try again.';
        _looking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Check your vehicle'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Enter your reference code', style: AppText.heading(22)),
              const SizedBox(height: 6),
              Text(
                'Use the code you were given when your vehicle was booked in.',
                style: AppText.body(14, color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                onSubmitted: (_) => _submit(),
                style: AppText.body(18, weight: FontWeight.w600).copyWith(letterSpacing: 2),
                decoration: AppTheme.inputDecoration(label: 'Reference code'),
              ),
              const SizedBox(height: 16),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_error!, style: AppText.body(13.5, color: AppColors.danger)),
                ),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                onPressed: _looking ? null : _submit,
                child: _looking
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onGold),
                      )
                    : const Text('Check status'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
