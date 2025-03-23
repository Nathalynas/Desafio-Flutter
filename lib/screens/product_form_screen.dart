import 'dart:async';
import 'package:almeidatec/core/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
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
  final MoneyMaskedTextController _priceController = productPriceFormatter;

  late String _selectedCategory;
  int productCode = DateTime.now().millisecondsSinceEpoch % 10000;

  @override
  void initState() {
    super.initState();
    _selectedCategory = "dress";
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Nome do Produto
                      _buildTextFormField(
                        label: AppLocalizations.of(context)!.name,
                        controller: _nameController,
                        validator: (value) =>
                            Validators.validateRequired(value, context),
                      ),
                      const SizedBox(height: 20),

                      /// Categoria
                      _buildDropdown(
                        AppLocalizations.of(context)!
                            .category, // Título traduzido
                        _selectedCategory,
                        {
                          "dress": AppLocalizations.of(context)!.dress,
                          "pants": AppLocalizations.of(context)!.pants,
                          "shirt": AppLocalizations.of(context)!.shirt,
                        },
                        (value) => setState(() => _selectedCategory = value!),
                      ),
                      const SizedBox(height: 20),

                      /// Quantidade
                      _buildTextFormField(
                        label: AppLocalizations.of(context)!.quantity,
                        controller: _quantityController,
                        validator: (value) =>
                            Validators.validateInteger(value, context),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(width: 20),

                      /// Preço
                      _buildTextFormField(
                        label: AppLocalizations.of(context)!.price,
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            Validators.validatePrice(value, context),
                      ),
                      const SizedBox(height: 20),

                      /// Botão de Salvar
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: radiusBorder,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          onPressed:
                              _submitForm, // Valida antes de exibir o diálogo
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.dialogTitle,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(AppLocalizations.of(context)!.dialogMessage),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context)!.dialogCancel,
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
                      child: Text(
                        AppLocalizations.of(context)!.dialogSave,
                        style: const TextStyle(color: AppColors.background),
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

  /// Valida o formulário e salva o produto
  void _saveProduct() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.addProduct({
      'id': productCode,
      'name': _nameController.text,
      'category': _selectedCategory,
      'quantity': int.tryParse(_quantityController.text) ?? 0,
      'price': _priceController.text,
    });

    /// Limpa os campos após salvar
    setState(() {
      _nameController.clear();
      _quantityController.clear();
      _priceController.updateValue(0);
      _selectedCategory = "dress";
    });

    /// Obtendo o contexto do ScaffoldMessenger antes de fechar o diálogo
    final messengerContext = ScaffoldMessenger.of(context);

    Navigator.pop(context);

    /// Aguarde um curto período antes de exibir o SnackBar
    Future.delayed(Duration(milliseconds: 300), () {
      messengerContext.showSnackBar(
        SnackBar(
          content: const Text(
            "Produto cadastrado com sucesso!",
            style: TextStyle(color: AppColors.background),
          ),
          backgroundColor: AppColors.green,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: "Desfazer",
            textColor: AppColors.background,
            onPressed: () {
              provider.deleteProduct(productCode);
            },
          ),
        ),
      );
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
