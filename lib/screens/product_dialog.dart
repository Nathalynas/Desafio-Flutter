import 'package:almeidatec/models/product.dart';
import 'package:awidgets/fields/a_drop_option.dart';
import 'package:awidgets/fields/a_field_drop_down.dart';
import 'package:awidgets/fields/a_field_money.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

Future<void> showProductDialog(
  BuildContext context, {
  Product? product,
  void Function(String result)? onCompleted,
}) async {
  final int productCode =
      product?.id ?? DateTime.now().millisecondsSinceEpoch % 10000;

  await AFormDialog.show<Map<String, dynamic>>(
    context,
    title: product == null
        ? AppLocalizations.of(context)!.newProduct
        : AppLocalizations.of(context)!.editProduct,
    persistent: true,
    submitText: AppLocalizations.of(context)!.dialogSave,
    fromJson: (json) => json as Map<String, dynamic>,
    initialData: product?.toJson(),
    onSubmit: (data) async {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      final bool isNewProduct = product == null;

      final newProduct = Product(
        id: isNewProduct ? productCode : product.id,
        name: data['product_name'] as String,
        category: data['category'] as String,
        quantity: int.tryParse(data['product_quantity']) ?? 0,
        price: data['product_price'] is String
            ? double.tryParse(
                  (data['product_price'] as String)
                      .replaceAll('.', '')
                      .replaceAll(',', '.'),
                ) ??
                0.0
            : (data['product_price'] ?? 0.0),
      );

      if (isNewProduct) {
        provider.addProduct(newProduct);
        onCompleted?.call('added:$productCode');
      } else {
        provider.updateProduct(newProduct);
        onCompleted?.call('uptade:$productCode');
      }

      return null;
    },
    fields: [
      AFieldText(
        identifier: 'product_name',
        label: AppLocalizations.of(context)!.name,
        required: true,
        initialValue: product?.name,
      ),
      AFieldDropDown<String>(
        identifier: "category",
        label: AppLocalizations.of(context)!.category,
        required: true,
        initialValue: product?.category ?? 'dress',
        options: [
          AOption(label: AppLocalizations.of(context)!.dress, value: 'dress'),
          AOption(label: AppLocalizations.of(context)!.pants, value: 'pants'),
          AOption(label: AppLocalizations.of(context)!.shirt, value: 'shirt'),
        ],
      ),
      AFieldText(
        identifier: 'product_quantity',
        label: AppLocalizations.of(context)!.quantity,
        required: true,
        initialValue: product?.quantity.toString(),
        keyboardType: TextInputType.number,
      ),
      AFieldMoney(
        identifier: 'product_price',
        label: AppLocalizations.of(context)!.price,
        required: true,
        initialValue: product?.price.toStringAsFixed(2),
        customRules: [
          (value) {
            final parsed = double.tryParse(
              value?.replaceAll('.', '').replaceAll(',', '.') ?? '',
            );
            if (parsed == null || parsed <= 0.0) {
              return AppLocalizations.of(context)!.priceGreaterThanZero;
            }
            return null;
          }
        ],
      ),
    ],
  );
}
