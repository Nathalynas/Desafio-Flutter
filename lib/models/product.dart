// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'generated/product.freezed.dart';
part 'generated/product.g.dart';

@Freezed()
class Product with _$Product {
  factory Product({
    required int id,
    required String name,
    @JsonKey(name: 'category_type') required String category,
    required int quantity,
    @JsonKey(name: 'value') required double price,
    String? url,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}