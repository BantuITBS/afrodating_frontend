import 'package:flutter/material.dart';
import 'package:teaseme_flutter/services/api_service.dart';
import 'package:teaseme_flutter/widgets/custom_button.dart';
import 'package:teaseme_flutter/utils/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final response = await ApiService().post('/api/users/login/', {
          'identifier': _identifierController.text,
          'password': _passwordController.text,
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', response['token']);
        await prefs.setString('user_role', response['role']);
        Navigator.pushReplacementNamed(
          context,
          response['role'] == 'teaser' ? '/dashboard/teaser' : '/dashboard/client',
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.pinkAccent,
            content: Text('Login failed: $e', style: const TextStyle(color: Colors.black)),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0), // reduced padding
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Animate(
                  child: const Text(
                    'Login to TeaseMe',
                    style: TextStyle(
                      fontSize: 14, // reduced font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ).fadeIn(duration: const Duration(milliseconds: 300)),
                const SizedBox(height: 12), // reduced spacing
                TextFormField(
                  controller: _identifierController,
                  decoration: const InputDecoration(
                    labelText: 'Email or Username',
                    labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pinkAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  validator: Validators.requiredValidator,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pinkAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  obscureText: true,
                  validator: Validators.passwordValidator,
                ),
                const SizedBox(height: 12),
                _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.pinkAccent, strokeWidth: 2),
                      )
                    : Animate(
                        child: CustomButton(
                          text: 'Login',
                          onPressed: _login,
                        ),
                      ).scaleXY(
                        begin: 0.4,
                        end: 0.5,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutBack,
                      ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/recover'),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.white70, decoration: TextDecoration.underline, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
