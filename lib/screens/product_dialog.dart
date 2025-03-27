import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/main.dart';
import 'package:awidgets/fields/a_drop_option.dart';
import 'package:awidgets/fields/a_field_drop_down.dart';
import 'package:awidgets/fields/a_field_money.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

Future<void> showProductDialog(BuildContext context, {Map<String, dynamic>? product}) async {
  final int productCode = product?['id'] ?? DateTime.now().millisecondsSinceEpoch % 10000;

  await AFormDialog.show<Map<String, dynamic>>(
    context,
    title: product == null
        ? AppLocalizations.of(context)!.newProduct
        : AppLocalizations.of(context)!.editProduct,
    persistent: true,
    submitText: AppLocalizations.of(context)!.dialogSave,
    fromJson: (json) => json as Map<String, dynamic>,
    initialData: product,
    onSubmit: (data) async {
      final provider = Provider.of<ProductProvider>(context, listen: false);

      bool isNewProduct = product == null;
      int? addedProductId;

      final productData = {
        'id': isNewProduct ? productCode : product['id'],
        'name': data['product_name'],
        'category': data['category'],
        'quantity': int.tryParse(data['product_quantity']) ?? 0,
        'price': data['product_price'],
      };

      if (isNewProduct) {
        provider.addProduct(productData);
        addedProductId = provider.products.last['id'];
      } else {
        provider.updateProduct(productData);
      }

      final snackbarMessage = isNewProduct
          ? AppLocalizations.of(context)!.snackbarProductSuccess
          : AppLocalizations.of(context)!.snackbarProductUpdated;

      final snackbarUndo = AppLocalizations.of(context)!.snackbarUndo;

      Future.delayed(const Duration(milliseconds: 300), () {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(snackbarMessage,
                style: const TextStyle(color: Colors.white)),
            backgroundColor: AppColors.green,
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            action: isNewProduct
                ? SnackBarAction(
                    label: snackbarUndo,
                    textColor: Colors.white,
                    onPressed: () {
                      provider.deleteProduct(addedProductId!);
                    },
                  )
                : null,
          ),
        );
      });

      return null; // sucesso
    },
    fields: [
      AFieldText(
        identifier: 'product_name',
        label: AppLocalizations.of(context)!.name,
        required: true,
        initialValue: product?['name'],
      ),
      AFieldDropDown<String>(
        identifier: "category",
        label: AppLocalizations.of(context)!.category,
        required: true,
        initialValue: product?['category'] ?? 'dress',
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
        initialValue: product?['quantity']?.toString(),
        keyboardType: TextInputType.number,
      ),
      AFieldMoney(
        identifier: 'product_price',
        label: AppLocalizations.of(context)!.price,
        required: true,
        initialValue: product?['price'] != null
            ? double.tryParse(product!['price']
                    .toString()
                    .replaceAll('R\$', '')
                    .replaceAll('.', '')
                    .replaceAll(',', '.'))
                ?.toStringAsFixed(2)
            : null,
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
