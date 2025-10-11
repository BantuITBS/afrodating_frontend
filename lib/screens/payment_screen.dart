import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:teaseme_flutter/services/api_service.dart';
import 'package:teaseme_flutter/utils/validators.dart';
import 'package:teaseme_flutter/widgets/consent_checkbox.dart';
import 'package:teaseme_flutter/widgets/custom_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _tier;
  bool _consent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unlock the Fun')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Ready for the full tease?',
                style: TextStyle(fontSize: 24, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Choose Your Plan'),
                items: const [
                  DropdownMenuItem(value: 'basic', child: Text('Basic – 75 ZAR/mo')),
                  DropdownMenuItem(value: 'premium', child: Text('Premium – 300 ZAR/mo')),
                ],
                onChanged: (value) => setState(() => _tier = value),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 20),
              ConsentCheckbox(
                value: _consent,
                onChanged: (value) => setState(() => _consent = value!),
                title: const Text('I consent to payment processing (POPIA)'),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Pay & Play',
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _consent) {
                    final amount = _tier == 'basic' ? 75.0 : 300.0;
                    try {
                      await Stripe.instance.createPaymentMethod(
                        params: PaymentMethodParams.card(
                          paymentMethodData: PaymentMethodData(
                            billingDetails: BillingDetails(),
                          ),
                        ),
                      );
                      await ApiService().post('/api/payments/', {
                        'type': 'subscription',
                        'amount': amount,
                        'consent': _consent,
                      });
                      Navigator.pushReplacementNamed(context, '/dashboard/client');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Payment failed: $e')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a plan and consent')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}