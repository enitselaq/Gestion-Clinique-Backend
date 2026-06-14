class NotificationModel {
  final int id;
  final int userId;
  final String message;
  final String createdAt;
  final bool read;

  NotificationModel({required this.id, required this.userId, required this.message, required this.createdAt, required this.read});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      userId: json['user'] as int,
      message: json['message'] as String,
      createdAt: json['created_at'] as String,
      read: json['read'] as bool,
    );
  }
}
