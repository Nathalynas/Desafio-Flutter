import 'package:almeidatec/configs.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/main.dart';
import 'package:almeidatec/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../utils/validators.dart';

class ProductDialog extends StatefulWidget {
  final Map<String, dynamic>? product;

  const ProductDialog({super.key, this.product});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final MoneyMaskedTextController _priceController = productPriceFormatter;

  late ProductProvider provider;

  late String _selectedCategory;
  late int productCode;

  @override
  void initState() {
    if (widget.product != null) {
      productCode = widget.product!['id'];
      _nameController.text = widget.product!['name'];
      _selectedCategory = widget.product!['category'];
      _quantityController.text = widget.product!['quantity'].toString();
      _priceController.text = widget.product!['price'];
    } else {
      productCode = DateTime.now().millisecondsSinceEpoch % 10000;
      _selectedCategory = "dress";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildStandardDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product == null
                  ? AppLocalizations.of(context)!.newProduct // "Novo Produto"
                  : AppLocalizations.of(context)!
                      .editProduct, // "Editar Produto"
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            /// Nome do Produto
            _buildTextField(
              AppLocalizations.of(context)!.name,
              _nameController,
              validator: (value) => Validators.validateRequired(value, context),
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
              (value) => _selectedCategory = value!,
            ),
            const SizedBox(height: 15),

            /// Quantidade
            _buildTextField(
              AppLocalizations.of(context)!.quantity,
              _quantityController,
              keyboardType: TextInputType.number,
              validator: (value) => Validators.validateInteger(value, context),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),

            const SizedBox(height: 15),

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
                  onPressed: () {
                    _priceController.updateValue(0);
                    Navigator.pushNamed(context, Routes.productList);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.dialogCancel,
                    style: const TextStyle(color: AppColors.accent),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text(
                    widget.product == null
                        ? AppLocalizations.of(context)!.dialogSave
                        : AppLocalizations.of(context)!.update,
                    style: const TextStyle(color: AppColors.background),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Valida o formulário e salva o produto
  void _saveProduct() {
    if (!_formKey.currentState!.validate()) return;

    provider = Provider.of<ProductProvider>(context, listen: false);

    bool isNewProduct = widget.product == null;
    int? addedProductId;

    if (isNewProduct) {
      // Novo produto
      final newProduct = {
        'name': _nameController.text,
        'category': _selectedCategory,
        'quantity': int.tryParse(_quantityController.text) ?? 0,
        'price': _priceController.text,
      };

      provider.addProduct(newProduct);
      addedProductId = provider.products.last['id'];
    } else {
      // Atualizar produto existente
      final updatedProduct = {
        'id': widget.product!['id'],
        'name': _nameController.text,
        'category': _selectedCategory,
        'quantity': int.tryParse(_quantityController.text) ?? 0,
        'price': _priceController.text,
      };

      provider.updateProduct(updatedProduct);
    }

    /// Reseta o formulário
    _formKey.currentState!.reset();
    _priceController.updateValue(0);

    final snackbarMessage = isNewProduct
        ? AppLocalizations.of(context)!.snackbarProductSuccess
        : AppLocalizations.of(context)!.snackbarProductUpdated;
    final snackbarUndo = AppLocalizations.of(context)!.snackbarUndo;

    Navigator.pop(context);

    /// Aguarde um curto período antes de exibir o SnackBar
    Future.delayed(Duration(milliseconds: 300), () {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            snackbarMessage,
            style: TextStyle(color: AppColors.background),
          ),
          backgroundColor: AppColors.green,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          action: isNewProduct
              ? SnackBarAction(
                  label: snackbarUndo,
                  textColor: AppColors.background,
                  onPressed: () {
                    provider.deleteProduct(addedProductId!);
                  },
                )
              : null, // Se for edição, não exibe botão "Desfazer"
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
