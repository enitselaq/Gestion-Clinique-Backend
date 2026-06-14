import 'package:dio/dio.dart';
import '../models/notification_model.dart';

class NotificationService {
  final Dio _dio = Dio();

  Future<List<NotificationModel>> getNotifications() async {
    final resp = await _dio.get('notifications/');
    return (resp.data as List).map((e) => NotificationModel.fromJson(e)).toList();
  }

  Future<void> markRead(int id) async {
    await _dio.post('notifications/$id/mark-read/');
  }
}
