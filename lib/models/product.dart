import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/product.freezed.dart';
part 'generated/product.g.dart';

@Freezed()
class Product with _$Product {
  factory Product({
    required int id,
    required String name,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'category_type') required String category,
    required int quantity,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'value') required double price,
    String? url,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'account_id') required int accountId,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}