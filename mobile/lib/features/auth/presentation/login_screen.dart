import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../providers/auth_provider.dart';
import '../providers/biometric_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _signingIn = false;
  String? _error;

  bool _fingerprintAvailable = false; // this phone has a fingerprint enrolled
  bool _fingerprintEnabled = false; // a login is saved for fingerprint sign-in
  bool _enableNextTime = false; // the "use fingerprint next time" switch

  @override
  void initState() {
    super.initState();
    _loadFingerprintState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadFingerprintState() async {
    final service = ref.read(biometricAuthServiceProvider);
    final available = await service.isAvailable();
    final enabled = available && await service.isEnabled();
    if (!mounted) return;
    setState(() {
      _fingerprintAvailable = available;
      _fingerprintEnabled = enabled;
    });
    // Ask for the fingerprint straight away so signing in is one touch.
    if (enabled) _signInWithFingerprint();
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() {
      _error = message;
      _signingIn = false;
    });
  }

  Future<void> _signInWithFingerprint() async {
    if (_signingIn) return;
    final service = ref.read(biometricAuthServiceProvider);
    final auth = ref.read(authRepositoryProvider);

    final saved = await service.unlock();
    if (saved == null || !mounted) return; // cancelled: stay on the form

    setState(() {
      _signingIn = true;
      _error = null;
    });

    try {
      await auth.signIn(email: saved.email, password: saved.password);
      if (mounted) Navigator.of(context).maybePop();
    } on AuthException catch (e) {
      if (e.statusCode == '400') {
        // The password was changed, so the saved login no longer works.
        await service.disable();
        if (!mounted) return;
        setState(() {
          _fingerprintEnabled = false;
          _error = 'Your saved login is out of date. Sign in with your password '
              'to set up fingerprint again.';
          _signingIn = false;
        });
      } else {
        _fail('Could not sign in. Check your connection and try again.');
      }
    } catch (_) {
      _fail('Could not sign in. Check your connection and try again.');
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final service = ref.read(biometricAuthServiceProvider);
    final auth = ref.read(authRepositoryProvider);

    setState(() {
      _signingIn = true;
      _error = null;
    });

    try {
      await auth.signIn(email: email, password: password);

      if (_enableNextTime && _fingerprintAvailable && !_fingerprintEnabled) {
        final saved = await service.enable(email: email, password: password);
        if (!saved && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fingerprint sign-in was not turned on.')),
          );
        }
      }
      if (mounted) Navigator.of(context).maybePop();
    } catch (e) {
      _fail('Could not sign in - check your email and password.');
    }
  }

  Future<void> _turnOffFingerprint() async {
    await ref.read(biometricAuthServiceProvider).disable();
    if (!mounted) return;
    setState(() {
      _fingerprintEnabled = false;
      _enableNextTime = false;
    });
  }

  Widget _spinner() => const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onGold),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Staff sign-in'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Welcome back', style: AppText.heading(24)),
                const SizedBox(height: 6),
                Text(
                  'Sign in with your work account.',
                  style: AppText.body(14, color: AppColors.textMuted),
                ),
                const SizedBox(height: 28),
                if (_fingerprintEnabled) ...[
                  FilledButton.icon(
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                    icon: const Icon(Icons.fingerprint, size: 24),
                    label: const Text('Sign in with fingerprint'),
                    onPressed: _signingIn ? null : _signInWithFingerprint,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'or use your password',
                          style: AppText.body(12.5, color: AppColors.textFaint),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 18),
                ],
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: AppTheme.inputDecoration(
                    label: 'Email',
                    prefixIcon: const Icon(Icons.mail_outline, size: 20),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: AppTheme.inputDecoration(
                    label: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                if (_fingerprintAvailable && !_fingerprintEnabled) ...[
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Use fingerprint next time', style: AppText.body(14)),
                    subtitle: Text(
                      "Your login is kept in this phone's secure storage.",
                      style: AppText.body(12, color: AppColors.textFaint),
                    ),
                    value: _enableNextTime,
                    onChanged: _signingIn ? null : (v) => setState(() => _enableNextTime = v),
                  ),
                ],
                const SizedBox(height: 16),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(_error!, style: AppText.body(13.5, color: AppColors.danger)),
                  ),
                if (_fingerprintEnabled)
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                    onPressed: _signingIn ? null : _submit,
                    child: const Text('Sign in with password'),
                  )
                else
                  FilledButton(
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                    onPressed: _signingIn ? null : _submit,
                    child: _signingIn ? _spinner() : const Text('Sign in'),
                  ),
                if (_fingerprintEnabled) ...[
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: _signingIn ? null : _turnOffFingerprint,
                    child: const Text('Turn off fingerprint sign-in'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
