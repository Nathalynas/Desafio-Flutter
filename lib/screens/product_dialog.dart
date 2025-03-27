import 'package:almeidatec/configs.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/main.dart';
import 'package:awidgets/fields/a_drop_option.dart';
import 'package:awidgets/fields/a_field_drop_down.dart';
import 'package:awidgets/fields/a_field_money.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductDialog extends StatefulWidget {
  final Map<String, dynamic>? product;

  const ProductDialog({super.key, this.product});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final MoneyMaskedTextController _priceController = productPriceFormatter;

  late ProductProvider provider;

  late int productCode;

  @override
  void initState() {
    if (widget.product != null) {
      productCode = widget.product!['id'];
      _nameController.text = widget.product!['name'];
      _quantityController.text = widget.product!['quantity'].toString();
      _priceController.text = widget.product!['price'];
    } else {
      productCode = DateTime.now().millisecondsSinceEpoch % 10000;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildStandardDialog(
      content: AForm<Map<String, dynamic>>(
        fromJson: (json) => json as Map<String, dynamic>,
        submitText: AppLocalizations.of(context)!.dialogSave,
        onSubmit: (data) async {
          provider = Provider.of<ProductProvider>(context, listen: false);

          bool isNewProduct = widget.product == null;
          int? addedProductId;

          if (isNewProduct) {
            final newProduct = {
              'id': productCode,
              'name': data['product_name'],
              'category': data['category'],
              'quantity': int.tryParse(data['product_quantity']) ?? 0,
              'price': data['product_price'],
            };

            provider.addProduct(newProduct);
            addedProductId = provider.products.last['id'];
          } else {
            final updatedProduct = {
              'id': widget.product!['id'],
              'name': data['product_name'],
              'category': data['category'],
              'quantity': int.tryParse(data['product_quantity']) ?? 0,
              'price': data['product_price'],
            };

            provider.updateProduct(updatedProduct);
          }

          Navigator.pop(context);

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

          return null; // indica sucesso
        },
        onCancelled: () async {
          Navigator.pop(context);
        },
        fields: [
          Text(
            widget.product == null
                ? AppLocalizations.of(context)!.newProduct
                : AppLocalizations.of(context)!.editProduct,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          AFieldText(
            identifier: 'product_name',
            label: AppLocalizations.of(context)!.name,
            required: true,
            initialValue: widget.product?['name'],
          ),
          AFieldDropDown<String>(
            identifier: "category",
            label: AppLocalizations.of(context)!.category,
            required: true,
            initialValue: widget.product?['category'] ?? 'dress',
            options: [
              AOption(
                  label: AppLocalizations.of(context)!.dress, value: 'dress'),
              AOption(
                  label: AppLocalizations.of(context)!.pants, value: 'pants'),
              AOption(
                  label: AppLocalizations.of(context)!.shirt, value: 'shirt'),
            ],
          ),
          AFieldText(
            identifier: 'product_quantity',
            label: AppLocalizations.of(context)!.quantity,
            required: true,
            initialValue: widget.product?['quantity']?.toString(),
            keyboardType: TextInputType.number,
          ),
          AFieldMoney(
            identifier: 'product_price',
            label: AppLocalizations.of(context)!.price,
            required: true,
            initialValue: widget.product?['price'] != null
                ? double.tryParse(widget.product!['price']
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
                  return 'O preço deve ser maior que zero';
                }
                return null;
              }
            ],
          ),
        ],
      ),
    );
  }
}
