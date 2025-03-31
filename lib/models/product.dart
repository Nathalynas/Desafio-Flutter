import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/product.freezed.dart';
part 'generated/product.g.dart';

@Freezed()
class Product with _$Product {
  const factory Product({
    required int id,
    required String name,
    required String category,
    required int quantity,
    required double price,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
