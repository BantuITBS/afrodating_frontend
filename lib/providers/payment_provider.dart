import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teaseme_flutter/models/payment_model.dart';

final paymentProvider = StateNotifierProvider<PaymentNotifier, List<PaymentModel>>((ref) => PaymentNotifier(ref));

class PaymentNotifier extends StateNotifier<List<PaymentModel>> {
  final Ref ref;

  PaymentNotifier(this.ref) : super([]);

  Future<void> processPayment(String type, double amount, String teaserId) async {
    final response = await ref.read(apiProvider).post('/api/payments/', {
      'type': type,
      'amount': amount,
      'teaser': teaserId,
      'client': ref.read(authProvider).user?.email,
    });
    if (response.statusCode == 201) {
      state = [...state, PaymentModel.fromJson(response.data)];
    }
  }
}