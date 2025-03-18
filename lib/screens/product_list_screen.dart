import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/main.dart';
import 'package:almeidatec/screens/login_screen.dart';
import 'package:almeidatec/screens/product_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../configs.dart';
import '../providers/product_provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.productList, // 🔹 Traduzido
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              size: 30,
              color: AppColors.primary,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => LoginScreen(
                        changeLanguage: (Locale locale) {
                          final myAppState =
                              context.findAncestorStateOfType<MyAppState>();
                          myAppState?.changeLanguage(locale);
                        },
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        color: AppColors.background,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radiusBorder),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductFormScreen(),
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.newProduct, // 🔹 Traduzido
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowColor: WidgetStateProperty.all(
                            AppColors.primary,
                          ),
                          dataRowColor: WidgetStateProperty.all(
                            AppColors.background,
                          ),
                          dividerThickness: 1,
                          columns: _buildColumns(context), // 🔹 Traduzido
                          rows:
                              provider.products.isNotEmpty
                                  ? provider.products
                                      .map(
                                        (product) => _buildRow(
                                          context,
                                          product,
                                          provider,
                                        ),
                                      )
                                      .toList()
                                  : [],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para criar as colunas da tabela
  List<DataColumn> _buildColumns(BuildContext context) {
    return [
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.code,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.category,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.quantity,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.actions,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ];
  }

  // Método para criar cada linha da tabela
  DataRow _buildRow(
    BuildContext context,
    Map<String, dynamic> product,
    ProductProvider provider,
  ) {
    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary.withValues(alpha: 0.2);
        }
        return null;
      }),
      cells: [
        DataCell(
          Text(
            product['id'].toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          Text(
            product['name'].toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        DataCell(Text(product['category'].toUpperCase())),
        DataCell(
          Text(
            product['quantity'].toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.grey[700]),
                onPressed: () {
                  // Função para editar
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  provider.deleteProduct(product['id']);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
