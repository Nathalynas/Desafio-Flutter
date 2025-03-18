import 'dart:async';
import 'package:almeidatec/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../configs.dart';
import '../providers/product_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  ProductFormScreenState createState() => ProductFormScreenState();
}

class ProductFormScreenState extends State<ProductFormScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(
    text: '0',
  );
  final TextEditingController _priceController = TextEditingController(
    text: 'R\$ 0,00',
  );

  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = "Vestido"; // 🔹 Defina um valor padrão válido
  }

  int productCode = DateTime.now().millisecondsSinceEpoch % 10000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.productForm, // 🔹 Traduzido
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        color: AppColors.background,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildTextField(
                            AppLocalizations.of(context)!.name, // 🔹 Traduzido
                            _nameController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: _buildTextField(
                            AppLocalizations.of(context)!.code, // 🔹 Traduzido
                            _codeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [NumericInputFormatter()],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDropdown(
                      AppLocalizations.of(context)!.category,
                      _selectedCategory,
                      {
                        "Vestido": AppLocalizations.of(context)!.dress,
                        "Calça": AppLocalizations.of(context)!.pants,
                        "Camiseta": AppLocalizations.of(context)!.shirt,
                      },
                      (value) {
                        setState(() => _selectedCategory = value!);
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            AppLocalizations.of(
                              context,
                            )!.quantity, // 🔹 Traduzido
                            _quantityController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [NumericInputFormatter()],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildTextField(
                            AppLocalizations.of(context)!.price, // 🔹 Traduzido
                            _priceController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [CurrencyInputFormatter()],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(radiusBorder),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<ProductProvider>(
                            context,
                            listen: false,
                          ).addProduct({
                            'id':
                                int.tryParse(_codeController.text) ??
                                productCode,
                            'name': _nameController.text,
                            'category': _selectedCategory,
                            'quantity':
                                int.tryParse(_quantityController.text) ?? 0,
                            'price': _priceController.text,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.productSuccess,
                              ), // 🔹 Traduzido
                              duration: const Duration(seconds: 2),
                            ),
                          );

                          Timer(const Duration(milliseconds: 500), () {
                            if (!mounted) return;
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)!.save, // 🔹 Traduzido
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  Widget _buildDropdown(
    String label,
    String value,
    Map<String, String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButtonFormField<String>(
          value: value,
          items:
              options.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusBorder),
              borderSide: BorderSide(color: AppColors.textSecondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusBorder),
              borderSide: BorderSide(color: AppColors.textPrimary),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildTextField(
  String label,
  TextEditingController controller, {
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusBorder),
            borderSide: BorderSide(color: AppColors.textSecondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusBorder),
            borderSide: BorderSide(color: AppColors.textPrimary),
          ),
        ),
      ),
    ],
  );
}
