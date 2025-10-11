class UserModel {
  final String username;
  final String email;
  final String role;
  final bool isVerified;

  UserModel({
    required this.username,
    required this.email,
    required this.role,
    this.isVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        username: json['username'],
        email: json['email'],
        role: json['role'],
        isVerified: json['is_verified'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'role': role,
        'is_verified': isVerified,
      };
}