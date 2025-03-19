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
  int productCode = DateTime.now().millisecondsSinceEpoch % 10000;

  @override
  void initState() {
    super.initState();
    _selectedCategory = "Vestido";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.productForm,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.background, // Agora fica branco no modo claro
          ),
        ),
        backgroundColor: AppColors.primary, // Mantém o fundo roxo
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.background,
        ), // Ícone de voltar branco
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField("Nome", _nameController),
                    const SizedBox(height: 20),
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
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            "Quantidade",
                            _quantityController,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildTextField("Preço", _priceController),
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
                        onPressed: () => _showCustomDialog(context),
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
    );
  }

  Future<void> _showCustomDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Confirmação",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text("Tem certeza que deseja salvar este produto?"),
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
      'id': int.tryParse(_codeController.text) ?? productCode,
      'name': _nameController.text,
      'category': _selectedCategory,
      'quantity': int.tryParse(_quantityController.text) ?? 0,
      'price': _priceController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Produto salvo com sucesso!"),
        duration: const Duration(seconds: 2),
      ),
    );

    Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      Navigator.pop(context);
    });
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
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
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
          items:
              options.entries
                  .map(
                    (entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          dropdownColor: Theme.of(context).cardColor,
        ),
      ],
    );
  }
}
