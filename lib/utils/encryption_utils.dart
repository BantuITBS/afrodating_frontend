import 'package:cryptography/cryptography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final encryptionProvider = Provider<EncryptionUtil>((ref) => EncryptionUtil());

class EncryptionUtil {
  final algorithm = AesGcm.with256bits();
  final secretKey = SecretKey(List<int>.filled(32, 0)); // Replace with secure key

  Future<String> encrypt(String plain) async {
    final secretBox = await algorithm.encryptString(plain, secretKey: secretKey);
    return secretBox.concatenation().toBase64();
  }
}