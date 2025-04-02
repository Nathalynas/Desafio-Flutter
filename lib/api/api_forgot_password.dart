import 'dart:convert';
import 'package:almeidatec/api/api_base_module.dart';
import 'package:almeidatec/core/http_utils.dart';

class ForgotPasswordAPI extends BaseModuleAPI {
  ForgotPasswordAPI(super.api);

  Future<void> sendRecoveryEmail({required String email}) async {
    await requestWrapper(
      () => api.dio.put(
        '/forgot-password',
        queryParameters: {'email': email},
      ),
    );
  }

  Future<void> resetPassword({
    required String code,
    required String newPassword,
  }) async {
    await requestWrapper(
      () => api.dio.put(
        '/password_recovery/set_password',
        data: jsonEncode({
          'code': code,
          'new_password': newPassword,
        }),
      ),
    );
  }
}
