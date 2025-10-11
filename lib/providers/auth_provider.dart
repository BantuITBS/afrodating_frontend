import 'package:teaseme_flutter/models/user_model.dart';
import 'package:teaseme_flutter/services/api_service.dart';

class AuthProvider {
  UserModel? _user;

  UserModel? get user => _user;

  Future<void> login(String email, String password) async {
    final data = await ApiService().post('/api/users/login/', {
      'email': email,
      'password': password,
    });
    _user = UserModel.fromJson(data);
  }

  Future<void> register(String username, String email, String password, String role, List<String> preferences) async {
    final data = await ApiService().post('/api/users/register/', {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
      'preferences': preferences,
    });
    _user = UserModel.fromJson(data);
  }

  Future<void> logout() async {
    _user = null;
  }
}