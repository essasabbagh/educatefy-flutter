// lib/models/user.dart
/// Represents a user entity in the application.
/// Contains basic user information and metadata.
class User {
  /// Creates a new [User] instance.
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.role,
    required this.status,
  });

  /// Creates a [User] instance from JSON data.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
    );
  }
  final int id;
  final String name;
  final String email;
  final String avatarUrl;
  final String role;
  final String status;

  /// Converts the user instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'role': role,
      'status': status,
    };
  }
}
