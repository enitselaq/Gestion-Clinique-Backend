import 'package:dio/dio.dart';
import '../models/notification_model.dart';
import 'api_client.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient();
  Dio get _dio => _apiClient.dio;

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final resp = await _dio.get('notifications/');
      return (resp.data as List).map((e) => NotificationModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  Future<void> markRead(int id) async {
    try {
      await _dio.post('notifications/$id/mark-read/');
    } on DioException {
      rethrow;
    }
  }
}
