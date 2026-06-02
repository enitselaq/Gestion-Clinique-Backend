import 'package:dio/dio.dart';
import '../models/paiement_model.dart';
import 'api_client.dart';

class PaymentService {
  final ApiClient _apiClient = ApiClient();
  Dio get _dio => _apiClient.dio;

  Future<List<PaiementModel>> getPayments() async {
    try {
      final response = await _dio.get('paiements/');
      return (response.data as List)
          .map((item) => PaiementModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  Future<PaiementModel> createPayment(PaiementModel payment) async {
    try {
      final response = await _dio.post('paiements/', data: payment.toJson());
      return PaiementModel.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }
}
