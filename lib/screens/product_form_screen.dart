import 'dart:async';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../configs.dart';
import '../providers/product_provider.dart';
import '../utils/validators.dart'; 

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  ProductFormScreenState createState() => ProductFormScreenState();
}

class ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>(); 
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  late String _selectedCategory;
  int productCode = DateTime.now().millisecondsSinceEpoch % 10000;

  @override
  void initState() {
    super.initState();
    _selectedCategory = "Vestido";
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _showCustomDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).productForm,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Nome do Produto
                      _buildTextFormField(
                        label: "Nome do Produto",
                        controller: _nameController,
                        validator: Validators.validateRequired,
                      ),
                      const SizedBox(height: 20),

                      /// Categoria
                      _buildDropdown(
                        "Categoria",
                        _selectedCategory,
                        {
                          "Vestido": "Vestido",
                          "Calça": "Calça",
                          "Camiseta": "Camiseta",
                        },
                        (value) => setState(() => _selectedCategory = value!),
                      ),
                      const SizedBox(height: 20),

                      /// Quantidade e Preço
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextFormField(
                              label: "Quantidade",
                              controller: _quantityController,
                              validator: Validators.validateInteger,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildTextFormField(
                              label: "Preço",
                              controller: _priceController,
                              validator: Validators.validatePrice,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      /// Botão de Salvar
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: radiusBorder,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          ),
                          onPressed: _submitForm, // Valida antes de exibir o diálogo
                          child: const Text(
                            "Salvar",
                            style: TextStyle(
                              color: AppColors.background,
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
      ),
    );
  }

  Future<void> _showCustomDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Confirmação",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text("Tem certeza que deseja salvar este produto?"),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancelar",
                        style: TextStyle(color: AppColors.accent),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _saveProduct();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text(
                        "Salvar",
                        style: TextStyle(color: AppColors.background),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveProduct() {
    Provider.of<ProductProvider>(context, listen: false).addProduct({
      'id': productCode,
      'name': _nameController.text,
      'category': _selectedCategory,
      'quantity': int.tryParse(_quantityController.text) ?? 0,
      'price': _priceController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Produto salvo com sucesso!",
          style: TextStyle(color: AppColors.background),
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: "Desfazer",
          textColor: AppColors.background,
          onPressed: () {
            final provider = Provider.of<ProductProvider>(context, listen: false);
            provider.deleteProduct(productCode);
          },
        ),
      ),
    );

    Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      Navigator.pop(context);
    });
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ],
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
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        DropdownButtonFormField<String>(
          value: value,
          items: options.entries.map((entry) {
            return DropdownMenuItem(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor: Theme.of(context).cardColor,
        ),
      ],
    );
  }
}

