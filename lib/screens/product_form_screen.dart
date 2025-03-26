import 'dart:async';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/routes.dart';
import 'package:awidgets/fields/a_drop_option.dart';
import 'package:awidgets/fields/a_field_drop_down.dart';
import 'package:awidgets/fields/a_field_money.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  ProductFormScreenState createState() => ProductFormScreenState();
}

class ProductFormScreenState extends State<ProductFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.productForm,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.background,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.background),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, Routes.productList),
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: AForm<Map<String, dynamic>>(
                  fromJson: (json) => json as Map<String, dynamic>,
                  submitText: AppLocalizations.of(context)!.dialogSave,
                  onSubmit: (data) async {
                    final provider =
                        Provider.of<ProductProvider>(context, listen: false);
                    final navigator = Navigator.of(context);
                    final messenger = ScaffoldMessenger.of(context);

                    final newProduct = {
                      'id': DateTime.now().millisecondsSinceEpoch % 10000,
                      'name': data['product_name'],
                      'category': data['category'],
                      'quantity': int.tryParse(data['product_quantity']) ?? 0,
                      'price': data['product_price'],
                    };

                    provider.addProduct(newProduct);
                    final addedProductId = provider.products.last['id'];

                    final snackbarProductSuccess =AppLocalizations.of(context)!.snackbarProductSuccess;
                    final snackbarUndo =AppLocalizations.of(context)!.snackbarUndo;

                    navigator.pushNamed(Routes.productList);

                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (!mounted) return;

                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            snackbarProductSuccess,
                            style: const TextStyle(color: AppColors.background),
                          ),
                          backgroundColor: AppColors.green,
                          duration: const Duration(seconds: 5),
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                            label: snackbarUndo,
                            textColor: AppColors.background,
                            onPressed: () {
                              provider.deleteProduct(addedProductId);
                            },
                          ),
                        ),
                      );
                    });

                    return null;
                  },
                  onCancelled: () async {
                    Navigator.pushNamed(context, Routes.productList);
                  },
                  fields: [
                    AFieldText(
                      identifier: 'product_name',
                      label: AppLocalizations.of(context)!.name,
                      required: true,
                    ),
                    const SizedBox(height: 20),
                    AFieldDropDown<String>(
                      identifier: 'category',
                      label: AppLocalizations.of(context)!.category,
                      required: true,
                      initialValue: "dress",
                      options: [
                        AOption<String>(
                          label: AppLocalizations.of(context)!.dress,
                          value: "dress",
                        ),
                        AOption<String>(
                          label: AppLocalizations.of(context)!.pants,
                          value: "pants",
                        ),
                        AOption<String>(
                          label: AppLocalizations.of(context)!.shirt,
                          value: "shirt",
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AFieldText(
                      identifier: 'product_quantity',
                      label: AppLocalizations.of(context)!.quantity,
                      required: true,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    AFieldMoney(
                      identifier: 'product_price',
                      label: AppLocalizations.of(context)!.price,
                      required: true,
                      customRules: [
                        (value) {
                          final parsed = double.tryParse(
                            value?.replaceAll('.', '').replaceAll(',', '.') ??
                                '',
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
