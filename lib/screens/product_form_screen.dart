import 'package:almeidatec/api/api.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/models/product.dart';
import 'package:almeidatec/routes.dart';
import 'package:awidgets/fields/a_drop_option.dart';
import 'package:awidgets/fields/a_field_drop_down.dart';
import 'package:awidgets/fields/a_field_money.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:almeidatec/configs.dart';


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
          onPressed: () => Navigator.pop(context),
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
                    final newProduct = Product(
                      id: 0,
                      name: data['product_name'],
                      category: data['category'],
                      quantity: int.tryParse(data['product_quantity']) ?? 0,
                      price: _parsePrice(data['product_price']),
                    );

                    try {
                      await API.products.createProduct(
                        name: newProduct.name,
                        categoryType: newProduct.category,
                        quantity: newProduct.quantity,
                        value: newProduct.price,
                        accountId: selectedAccount!.id,
                      );
                      if (!mounted) return;
                      Navigator.pop(this.context, 'added');
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(this.context)!
                              .somethingWentWrong),
                          backgroundColor: AppColors.accent,
                        ),
                      );
                    }

                    return null;
                  },
                  onCancelled: () async {
                    Navigator.pushNamed(context, Routes.productList);
                  },
                  fields: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textPrimary.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
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
                            initialValue: "Vestido",
                            options: [
                              AOption<String>(
                                label: AppLocalizations.of(context)!.dress,
                                value: "Vestido",
                              ),
                              AOption<String>(
                                label: AppLocalizations.of(context)!.pants,
                                value: "Calça",
                              ),
                              AOption<String>(
                                label: AppLocalizations.of(context)!.shirt,
                                value: "Camiseta",
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
                                  value
                                          ?.replaceAll('.', '')
                                          .replaceAll(',', '.') ??
                                      '',
                                );
                                if (parsed == null || parsed <= 0.0) {
                                  return AppLocalizations.of(context)!
                                      .priceGreaterThanZero;
                                }
                                return null;
                              },
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ), // AForm
              ), // ConstrainedBox
            ), // Padding
          ), // SingleChildScrollView
        ), // Center
      ), // Container
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
}
