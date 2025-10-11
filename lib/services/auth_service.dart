import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teaseme_flutter/providers/auth_provider.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref));

class AuthService {
  final Ref ref;

  AuthService(this.ref);

  Future<void> verifyAge() async {
    // Integrate Yoti/Veriff SDK
    // Mock: assume success
    ref.read(authProvider.notifier).setAgeVerified(true);
  }
}