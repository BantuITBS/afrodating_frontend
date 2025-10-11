import 'package:flutter/material.dart';
import 'package:teaseme_flutter/screens/splash_screen.dart';
import 'package:teaseme_flutter/screens/login_screen.dart';
import 'package:teaseme_flutter/screens/register_screen.dart';
import 'package:teaseme_flutter/screens/profile_screen.dart';
import 'package:teaseme_flutter/screens/content_screen.dart';
import 'package:teaseme_flutter/screens/payment_screen.dart';
import 'package:teaseme_flutter/screens/settings_screen.dart';
import 'package:teaseme_flutter/screens/dashboard/client_dashboard.dart';
import 'package:teaseme_flutter/screens/dashboard/teaser_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeaseMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: '/content',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/content': (context) => const ContentScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/dashboard/client': (context) => const ClientDashboard(),
        '/dashboard/teaser': (context) => const TeaserDashboard(),
      },
    );
  }
}