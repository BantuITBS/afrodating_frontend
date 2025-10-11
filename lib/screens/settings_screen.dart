import 'package:flutter/material.dart';
import 'package:teaseme_flutter/services/api_service.dart';
import 'package:teaseme_flutter/widgets/consent_checkbox.dart';
import 'package:teaseme_flutter/widgets/custom_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _marketingConsent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Tweak your vibe',
              style: TextStyle(fontSize: 24, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ConsentCheckbox(
              value: _marketingConsent,
              onChanged: (value) => setState(() => _marketingConsent = value!),
              title: const Text('Allow marketing emails (POPIA)'),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Save Settings',
              onPressed: () async {
                try {
                  await ApiService().post('/api/users/settings/', {
                    'marketing_consent': _marketingConsent,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings saved')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save settings: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}