import 'dart:convert';

import 'package:almeidatec/api/api_base_module.dart';
import 'package:almeidatec/core/http_utils.dart';

class LoginAPI extends BaseModuleAPI {
  LoginAPI(super.api);
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await requestWrapper(
      () => api.dio.post(
        '/login',
        data: jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
        }),
      ),
    );
  }
}
