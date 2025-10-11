import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 150)
                .animate()
                .fadeIn(duration: 1.seconds)
                .scale(),
            const SizedBox(height: 20),
            const Text(
              'TeaseMe',
              style: TextStyle(fontSize: 36, color: Colors.pinkAccent),
            ).animate().slideY(duration: 1.seconds),
            const SizedBox(height: 10),
            const Text(
              'Ready to be teased?',
              style: TextStyle(color: Colors.white70),
            ).animate().fadeIn(delay: 1.seconds),
          ],
        ),
      ),
    );
  }
}