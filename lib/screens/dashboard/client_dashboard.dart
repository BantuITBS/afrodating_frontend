import 'package:flutter/material.dart';
import 'package:teaseme_flutter/widgets/custom_button.dart';

class ClientDashboard extends StatelessWidget {
  const ClientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Client Hub')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ready for some fun?',
              style: TextStyle(fontSize: 24, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Browse Teasers',
              onPressed: () => Navigator.pushNamed(context, '/content'),
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Upgrade Plan',
              onPressed: () => Navigator.pushNamed(context, '/payment'),
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Settings',
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),
    );
  }
}