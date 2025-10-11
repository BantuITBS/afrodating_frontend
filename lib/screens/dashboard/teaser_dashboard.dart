import 'package:flutter/material.dart';
import 'package:teaseme_flutter/widgets/custom_button.dart';

class TeaserDashboard extends StatelessWidget {
  const TeaserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teaser Hub')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Time to shine!',
              style: TextStyle(fontSize: 24, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Edit Profile',
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Upload Content',
              onPressed: () => Navigator.pushNamed(context, '/content'),
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