import 'package:almeidatec/configs.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:almeidatec/main.dart';
import 'package:almeidatec/screens/login_screen.dart';
import 'package:almeidatec/screens/product_dialog.dart';
import 'package:almeidatec/screens/product_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/theme_provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.productList,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.background),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDark
                  ? Icons.dark_mode
                  : Icons.light_mode,
              size: 30,
              color: AppColors.background,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),

          /// Botão para mudar idioma
          IconButton(
            icon: const Icon(
              Icons.language,
              size: 30,
              color: AppColors.background,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.chooseLanguage),
                    actions: [
                      TextButton(
                        onPressed: () {
                          final myAppState =
                              context.findAncestorStateOfType<MyAppState>();
                          myAppState?.changeLanguage(Locale('en'));
                          Navigator.pop(context);
                        },
                        child: const Text("English"),
                      ),
                      TextButton(
                        onPressed: () {
                          final myAppState =
                              context.findAncestorStateOfType<MyAppState>();
                          myAppState?.changeLanguage(Locale('pt'));
                          Navigator.pop(context);
                        },
                        child: const Text("Português"),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          IconButton(
            icon: const Icon(
              Icons.account_circle,
              size: 30,
              color: AppColors.background,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: radiusBorder,
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
                    AppLocalizations.of(context)!.newProduct,
                    style: const TextStyle(color: AppColors.background),
                  ),
                ),
                const SizedBox(width: 10), // Espaço entre os botões
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: radiusBorder,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () => _showProductDialog(context),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: AppColors.background),
                      SizedBox(width: 5),
                      Text(AppLocalizations.of(context)!.newProduct,
                          style: TextStyle(color: AppColors.background)),
                    ],
                  ),
                ),
              ],
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
                            AppColors.primary, // Cabeçalho roxo
                          ),
                          dataRowColor: WidgetStateProperty.all(
                            Theme.of(context).scaffoldBackgroundColor,
                          ),
                          dividerThickness: 1,
                          columns: _buildColumns(context),
                          rows: provider.products.isNotEmpty
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

  // Função para abrir o diálogo de cadastro de produto
  void _showProductDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const ProductDialog());
  }

  // Criando as colunas da tabela
  List<DataColumn> _buildColumns(BuildContext context) {
    return [
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.code,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.background,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.name,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.background),
        ),
      ),
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.category,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.background),
        ),
      ),
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.quantity,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.background),
        ),
      ),
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.price,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.background,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.actions,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.background),
        ),
      ),
    ];
  }

  // Criando cada linha da tabela
  DataRow _buildRow(
    BuildContext context,
    Map<String, dynamic> product,
    ProductProvider provider,
  ) {
    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          AppColors.primary.withValues(alpha: 0.2);
        }
        return null;
      }),
      cells: [
        DataCell(
          Text(
            product['id'].toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
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
        DataCell(
          Text(
            product['category'].toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        DataCell(
          Text(
            product['quantity'].toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        DataCell(Text(
          product['price'] ?? "R\$ 0,00",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        )),
        DataCell(
          Row(
            children: [
              Tooltip(
                message: AppLocalizations.of(context)!.edit,
                child: IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey[700]),
                  onPressed: () {
                    // Implementar a edição do produto
                  },
                ),
              ),
              Tooltip(
                message: AppLocalizations.of(context)!.delete,
                child: IconButton(
                  icon: Icon(Icons.delete, color: AppColors.accent),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, provider, product['id']);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void _showDeleteConfirmationDialog(
    BuildContext context, ProductProvider provider, int productId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmDelete),
        content: Text(AppLocalizations.of(context)!.deleteMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
            },
            child: Text(AppLocalizations.of(context)!.dialogCancel),
          ),
          TextButton(
            onPressed: () {
              provider.deleteProduct(productId);
              Navigator.pop(context); // Fecha o diálogo após excluir
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      );
    },
  );
}

