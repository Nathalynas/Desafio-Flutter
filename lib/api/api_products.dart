import 'dart:convert';
import 'package:almeidatec/api/api_base_module.dart';
import 'package:almeidatec/configs.dart';
import 'package:almeidatec/core/http_utils.dart';
import 'package:flutter/foundation.dart';

class ProductAPI extends BaseModuleAPI {
  ProductAPI(super.api);

  Future<void> createProduct({
    required String name,
    required String categoryType,
    required int quantity,
    required double value,
    required int accountId,
  }) async {
    final response = await requestWrapper(
      () => api.dio.post(
        '/product',
        queryParameters: {'account_id': accountId},
        data: jsonEncode({
          "name": name,
          "category_type": categoryType,
          "quantity": quantity,
          "value": value,
          "url": null,
        }),
      ),
    );
    debugPrint('Resposta: ${response.data}');
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final response = await requestWrapper(
      () => api.dio.get(
        '/products',
        queryParameters: {
          'account_id': selectedAccount!.id,
        },
      ),
    );
    debugPrint('[RAW PRODUCTS RESPONSE] ${response.data}');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<Map<String, dynamic>> getProductById(int productId) async {
    final response = await requestWrapper(
      () => api.dio.get(
        '/product/$productId',
        queryParameters: {
          'account_id': selectedAccount!.id,
        },
      ),
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    required String categoryType,
    required int quantity,
    required double value,
    required int accountId,
  }) async {
    final Map<String, dynamic> data = {
      "name": name,
      "category_type": categoryType,
      "quantity": quantity,
      "value": value,
      "url": null,
    };

    await requestWrapper(
      () => api.dio.patch(
        '/product/update',
        queryParameters: {
          'product_id': id,
          'account_id': accountId,
        },
        data: jsonEncode(data),
      ),
    );
  }

  Future<void> deleteProduct(int productId) async {
    await requestWrapper(
      () => api.dio.delete(
        '/product/$productId',
        queryParameters: {
          'account_id': selectedAccount!.id,
        },
      ),
    );
  }
}
