import 'package:flutter/material.dart';
import 'package:teaseme_flutter/services/api_service.dart';
import 'package:teaseme_flutter/utils/date_utils.dart' as CustomDateUtils;
import 'package:teaseme_flutter/utils/validators.dart';
import 'package:teaseme_flutter/widgets/custom_button.dart';
import 'package:teaseme_flutter/widgets/consent_checkbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RegisterScreen extends StatefulWidget {
  final bool showLoginLink;
  
  const RegisterScreen({
    super.key,
    this.showLoginLink = true,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthdateController = TextEditingController();
  String _role = 'client';
  bool _consent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate() && _consent) {
      final birthdate = DateTime.tryParse(_birthdateController.text);
      if (birthdate == null || CustomDateUtils.DateUtils.calculateAge(birthdate) < 18) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.pinkAccent,
            content: Text('You must be 18 or older to register', style: TextStyle(color: Colors.black)),
          ),
        );
        return;
      }
      setState(() => _isLoading = true);
      try {
        final response = await ApiService().post('/api/users/register/', {
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'birthdate': _birthdateController.text,
          'role': _role,
          'consent': _consent,
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', response['token']);
        await prefs.setString('user_role', _role);
        Navigator.pushReplacementNamed(
          context,
          _role == 'teaser' ? '/profile' : '/dashboard/client',
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.pinkAccent,
            content: Text('Registration failed: $e', style: const TextStyle(color: Colors.black)),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.pinkAccent,
          content: Text('Please complete all fields and consent', style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }

  Future<void> _selectBirthdate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.pinkAccent,
              onPrimary: Colors.white,
              surface: Colors.black87,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      setState(() {
        _birthdateController.text = selectedDate.toIso8601String().split('T')[0];
      });
    }
  }

  void _showLoginModal() {
    Navigator.pop(context); // Close register modal first
    // The login modal will be shown by the parent ContentScreen
    // This function is called when the login link is clicked
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Animate(
                  child: const Text(
                    'Join TeaseMe',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ).fadeIn(duration: const Duration(milliseconds: 600)),
                const SizedBox(height: 8),
                const Text(
                  'Create your exclusive account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pinkAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: Validators.requiredValidator,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pinkAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: Validators.emailValidator,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pinkAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  validator: Validators.passwordValidator,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _birthdateController,
                  decoration: const InputDecoration(
                    labelText: 'Birthdate (YYYY-MM-DD)',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pinkAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  readOnly: true,
                  onTap: _selectBirthdate,
                  validator: Validators.requiredValidator,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _role,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pinkAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.black87,
                  items: const [
                    DropdownMenuItem(
                      value: 'client', 
                      child: Row(
                        children: [
                          Icon(Icons.visibility, color: Colors.pinkAccent, size: 18),
                          SizedBox(width: 8),
                          Text('Client - View Content'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'teaser',
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.pinkAccent, size: 18),
                          SizedBox(width: 8),
                          Text('Teaser - Create Content'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _role = value!);
                  },
                ),
                const SizedBox(height: 16),
                ConsentCheckbox(
                  value: _consent,
                  onChanged: (value) => setState(() => _consent = value!),
                  title: const Text('I consent to data processing (POPIA)', style: TextStyle(color: Colors.white70)),
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.pinkAccent)
                    : Animate(
                        child: CustomButton(
                          text: 'Begin Your Journey',
                          onPressed: _register,
                        ),
                      ).scaleXY(
                        begin: 0.8,
                        end: 1.0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutBack,
                      ),
                
                // Only show login link if showLoginLink is true
                if (widget.showLoginLink) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _showLoginModal,
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}