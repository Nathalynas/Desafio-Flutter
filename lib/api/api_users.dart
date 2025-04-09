import 'package:almeidatec/core/http_utils.dart';
import 'package:almeidatec/models/account.dart';
import 'package:dio/dio.dart';
import 'package:almeidatec/api/api.dart';
import 'package:almeidatec/models/user.dart';
import 'package:flutter/foundation.dart';

class UserAPI {
  final API _api;
  UserAPI(this._api);

  Future<List<Map<String, dynamic>>> getMembers(int accountId) async {
    final response = await requestWrapper(
      () => _api.dio.get(
        '/members/$accountId',
      ),
    );

    debugPrint('[RAW USERS RESPONSE] ${response.data}');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<User> createMember(int accountId, User user) async {
    try {
      final response = await _api.dio.post(
        '/member',
        queryParameters: {
          'account_id': accountId,
        },
        data: {
          'name': user.name,
          'email': user.email,
          'password': user.password,
          'permissions': user.permissions.toJson(),
        },
      );

      final json = response.data;
      return User.fromJson(json);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Erro ao criar usuário');
    }
  }

  Future<User> editMember({
    required int accountId,
    required User user,
  }) async {
    final data = {
      'permissions': user.permissions.map((p) => p.permission.name).toList(),
    };

    final response = await requestWrapper(() => _api.dio.put(
          '/member/edit',
          queryParameters: {
            'user_id': user.id,
            'account_id': accountId,
          },
          data: data,
        ));

    return User.fromJson(response.data);
  }

  Future<void> toggleActive({
    required int userId,
    required int accountId,
    required bool isActive,
  }) async {
    final path = isActive
        ? '/member/activate/$userId'
        : '/member/deactivate/active/$userId';

    try {
      await _api.dio.put(
        path,
        queryParameters: {
          'account_id': accountId,
        },
      );
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['detail'] ?? 'Erro ao atualizar status do usuário');
    }
  }
}
