import 'package:almeidatec/configs.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../utils/validators.dart';

class ProductDialog extends StatefulWidget {
  const ProductDialog({super.key});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cadastrar Produto",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              /// Nome do Produto
              _buildTextField(
                AppLocalizations.of(context)!.name,
                _nameController,
                validator: (value) =>
                    Validators.validateRequired(value, context),
              ),
              const SizedBox(height: 15),

              /// Categoria
              _buildDropdown(
                AppLocalizations.of(context)!.category, 
                _selectedCategory,
                {
                  "dress": AppLocalizations.of(context)!.dress,
                  "pants": AppLocalizations.of(context)!.pants,
                  "shirt": AppLocalizations.of(context)!.shirt,
                },
                (value) => setState(() => _selectedCategory = value!),
              ),
              const SizedBox(height: 15),

              /// Quantidade
              _buildTextField(
                AppLocalizations.of(context)!.quantity,
                _quantityController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    Validators.validateInteger(value, context),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),

              const SizedBox(width: 10),

              /// Preço
              _buildTextField(
                AppLocalizations.of(context)!.price,
                _priceController,
                keyboardType: TextInputType.number,
                validator: (value) => Validators.validatePrice(value, context),
              ),
              const SizedBox(height: 20),

              /// Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: AppColors.accent),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _saveProduct,
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
      ),
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

    /// Reseta o formulário
    _formKey.currentState!.reset();

    /// Obtendo o contexto do ScaffoldMessenger antes de fechar o diálogo
    final messengerContext = ScaffoldMessenger.of(context);
    final snackbarProductSuccess = AppLocalizations.of(context)!.snackbarProductSuccess;
    final snackbarUndo = AppLocalizations.of(context)!.snackbarUndo;

    Navigator.pop(context);

    /// Aguarde um curto período antes de exibir o SnackBar
    Future.delayed(Duration(milliseconds: 300), () {
      messengerContext.showSnackBar(
        SnackBar(
          content: Text(
            snackbarProductSuccess,
            style: TextStyle(color: AppColors.background),
          ),
          backgroundColor: AppColors.green,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: snackbarUndo,
            textColor: AppColors.background,
            onPressed: () {
              provider.deleteProduct(productCode);
            },
          ),
        ),
      );
    });
  }

  /// Campo de texto com validação
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
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
          inputFormatters: inputFormatters,
          validator: validator,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
      ],
    );
  }

  /// Dropdown para selecionar categoria
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
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
      ],
    );
  }
}
