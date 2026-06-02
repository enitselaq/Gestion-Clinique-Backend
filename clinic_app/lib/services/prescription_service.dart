import 'package:dio/dio.dart';
import '../models/prescription_model.dart';
import 'api_client.dart';

class PrescriptionService {
  final ApiClient _apiClient = ApiClient();
  Dio get _dio => _apiClient.dio;

  Future<List<PrescriptionModel>> getPrescriptions() async {
    try {
      final response = await _dio.get('ordonnances/');
      return (response.data as List)
          .map((item) => PrescriptionModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  Future<PrescriptionModel> createOrdonnance({required int consultationId}) async {
    try {
      final response = await _dio.post('ordonnances/', data: {
        'consultation': consultationId,
      });
      return PrescriptionModel.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }
}
