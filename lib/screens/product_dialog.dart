import 'package:almeidatec/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../utils/validators.dart'; // Importando os validadores

class ProductDialog extends StatefulWidget {
  const ProductDialog({super.key});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
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
                "Nome do Produto",
                _nameController,
                validator: Validators.validateRequired,
              ),
              const SizedBox(height: 15),

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
              const SizedBox(height: 15),

              /// Quantidade e Preço
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      "Quantidade",
                      _quantityController,
                      keyboardType: TextInputType.number,
                      validator: Validators.validateInteger, 
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      "Preço",
                      _priceController,
                      keyboardType: TextInputType.number,
                      validator: Validators.validatePrice, 
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                    ),
                  ),
                ],
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

    Provider.of<ProductProvider>(context, listen: false).addProduct({
      'id': productCode,
      'name': _nameController.text,
      'category': _selectedCategory,
      'quantity': int.tryParse(_quantityController.text) ?? 0,
      'price': _priceController.text,
    });

    Navigator.pop(context);

    /// SnackBar de confirmação
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Produto cadastrado com sucesso!",
          style: TextStyle(color: AppColors.background),
        ),
        backgroundColor: AppColors.accent,
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

