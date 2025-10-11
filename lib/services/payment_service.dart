import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:teaseme_flutter/providers/payment_provider.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) => PaymentService(ref));

class PaymentService {
  final Ref ref;

  PaymentService(this.ref);

  Future<void> processPayment(String type, double amount, String teaserId) async {
    // Mock Stripe (replace with Segpay/CCBill)
    await Stripe.instance.createPaymentMethod(const PaymentMethodParams.card());
    await ref.read(paymentProvider.notifier).processPayment(type, amount, teaserId);
  }
}