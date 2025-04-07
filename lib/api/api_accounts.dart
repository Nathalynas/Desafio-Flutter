import 'package:almeidatec/api/api.dart';
import 'package:dio/dio.dart';

class AccountAPI {
  final API api;
  AccountAPI(this.api);

  Future<Map<String, dynamic>> getCurrentAccount(int accountId) async {
    try {
      final response = await api.dio.get(
        '/account',
        queryParameters: {'account_id': accountId},
      );
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      // ignore: avoid_print
      print('[ERRO AO BUSCAR CONTA]');
      // ignore: avoid_print
      print('Status: ${e.response?.statusCode}');
      // ignore: avoid_print
      print('Detalhes: ${e.response?.data}');
      rethrow;
    }
  }
}
