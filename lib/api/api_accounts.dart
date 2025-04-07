import 'package:almeidatec/api/api.dart';
import 'package:almeidatec/configs.dart';
import 'package:almeidatec/models/account.dart';
import 'package:dio/dio.dart';

class AccountAPI {
  final API api;
  AccountAPI(this.api);

  Future<Account> getAccounts() async {
    try {
      final response = await api.dio.get(
        '/accounts',
      );
      selectedAccount = Account.fromJson(response.data[0]);
      print(selectedAccount);
      return Account.fromJson(response.data[0]);
    } on DioException catch (e) {
      // ignore: avoid_print
      print('[ERRO AO BUSCAR CONTAS]');
      // ignore: avoid_print
      print('Status: ${e.response?.statusCode}');
      // ignore: avoid_print
      print('Detalhes: ${e.response?.data}');
      rethrow;
    }
  }

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
