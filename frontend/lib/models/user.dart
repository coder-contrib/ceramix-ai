class User {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final int roleId;
  final bool isActive;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.roleId,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['full_name'],
      roleId: json['role_id'],
      isActive: json['is_active'],
    );
  }
}
