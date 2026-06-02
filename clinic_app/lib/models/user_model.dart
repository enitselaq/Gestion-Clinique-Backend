class UserModel {
  final String token;
  final int userId;
  final int? profileId;
  final String role;
  final String name;
  final String email;

  UserModel({
    required this.token,
    required this.userId,
    this.profileId,
    required this.role,
    required this.name,
    required this.email,
  });

  // Convert JSON from Django into this Dart Object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'],
      userId: json['user_id'],
      profileId: json['profile_id'],
      role: json['role'],
      name: json['name'],
      email: json['email'],
    );
  }
}