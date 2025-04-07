import 'package:almeidatec/core/colors.dart';
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
      final accountId = provider.accountId;
      final bool isNewProduct = product == null;

      final newProduct = Product(
        id: isNewProduct ? 0 : product.id,
        name: data['product_name'] as String,
        category: data['category'] as String,
        quantity: int.tryParse(data['product_quantity']) ?? 0,
        price: _parsePrice(data['product_price']),
        accountId: accountId ?? 0,
      );

      try {
        if (isNewProduct) {
          await provider.addProduct(newProduct);
          onCompleted?.call('added');
        } else {
          await provider.updateProduct(newProduct);
          onCompleted?.call('updated');
        }
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.somethingWentWrong),
            backgroundColor: AppColors.accent,
          ),
        );
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
        initialValue: product?.category ?? 'Vestido',
        options: [
          AOption(label: AppLocalizations.of(context)!.dress, value: 'Vestido'),
          AOption(label: AppLocalizations.of(context)!.pants, value: 'Calça'),
          AOption(label: AppLocalizations.of(context)!.shirt, value: 'Camiseta'),
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

/// Método para converter string com vírgula/real em double
double _parsePrice(dynamic value) {
  if (value == null) return 0.0;
  if (value is String) {
    final cleaned = value.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(cleaned) ?? 0.0;
  }
  return value;
}
