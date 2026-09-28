import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/customer_booking_provider.dart';
import 'customer_status_screen.dart';
import '../providers/push_notification_provider.dart';

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
  void dispose(){
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async{
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
      await ref.read(pushNotificationServiceProvider).saveLastReferenceCode(code);
      await ref.read(pushNotificationServiceProvider).registerForNotifications(code);

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => CustomerStatusScreen(booking: view)));
        setState(() => _looking = false);
    } catch (e){
      setState(() {
        _error = 'Something went wrong - check the code and try again.';
        _looking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check your vehicle')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter the reference code you were given when your vehicle was booked in.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24,),
              TextField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Reference code',
                  border: OutlineInputBorder(), 
                ),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16,),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              FilledButton(
                onPressed: _looking ? null : _submit, 
                child: _looking
                    ? const SizedBox(
                      width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2,))
                    : const Text('Check status'),
                    )
            ],
          ),
        ),
      )
    );
  }
}