import 'dart:convert';
import 'package:almeidatec/api/api_base_module.dart';
import 'package:almeidatec/core/http_utils.dart';
import 'package:dio/dio.dart';

class SignupAPI extends BaseModuleAPI {
  SignupAPI(super.api);

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await requestWrapper(
        () => api.dio.post(
          '/signup',
          data: jsonEncode(<String, dynamic>{
            'name': name,
            'email': email,
            'password': password,
          }),
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        // E-mail já está em uso
        final message = e.response?.data.toString() ?? 'E-mail já cadastrado.';
        throw Exception(message);
      }

      throw Exception('Erro ao cadastrar usuário.');
    }
  }
}
