import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BiometricAuthScreen extends ConsumerWidget {
  const BiometricAuthScreen({super.key});

  Future<void> _authenticate(BuildContext context, WidgetRef ref) async {
    final localAuth = LocalAuthentication();
    final isAvailable = await localAuth.canCheckBiometrics;
    if (!isAvailable) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometrics not available on this device')),
      );
      return;
    }

    try {
      final authenticated = await localAuth.authenticate(
        localizedReason: 'Authenticate to access CopiaOS',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated && context.mounted) {
        ref.read(authStateProvider.notifier).setBiometricEnabled(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication successful')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Auth')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fingerprint,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Enable Biometric Login',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Use fingerprint or face ID to securely access your account',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => _authenticate(context, ref),
                icon: const Icon(Icons.fingerprint),
                label: const Text('Authenticate'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
