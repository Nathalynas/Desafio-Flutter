import 'package:almeidatec/configs.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/routes.dart';
import 'package:awidgets/general/a_table.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:almeidatec/main.dart';
import 'package:almeidatec/screens/product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_localizations_extensions.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final GlobalKey<ATableState<Map<String, dynamic>>> tableKey =
      GlobalKey<ATableState<Map<String, dynamic>>>();

  @override
  Widget build(BuildContext context) {
    final columns = <ATableColumn<Map<String, dynamic>>>[
      ATableColumn(
        title: AppLocalizations.of(context)!.code,
        cellBuilder: (_, __, item) => Text(item['id'].toString()),
      ),
      ATableColumn(
        title: AppLocalizations.of(context)!.name,
        cellBuilder: (_, __, item) => Text(
          AppLocalizations.of(context)!.getProductTranslation(item['name']),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      ATableColumn(
        title: AppLocalizations.of(context)!.category,
        cellBuilder: (_, __, item) => Text(
          AppLocalizations.of(context)!
              .getCategoryTranslation(item['category']),
        ),
      ),
      ATableColumn(
        title: AppLocalizations.of(context)!.quantity,
        cellBuilder: (_, __, item) => Text(
          item['quantity'].toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      ATableColumn(
        title: AppLocalizations.of(context)!.price,
        cellBuilder: (_, __, item) => Text(item['price'] ?? 'R\$ 0,00'),
      ),
      ATableColumn(
        title: AppLocalizations.of(context)!.actions,
        cellBuilder: (_, __, item) => Row(
          children: [
            Tooltip(
              message: AppLocalizations.of(context)!.edit,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  showProductDialog(context, product: item);
                },
              ),
            ),
            Tooltip(
              message: AppLocalizations.of(context)!.delete,
              child: IconButton(
                icon: const Icon(Icons.delete, color: AppColors.accent),
                onPressed: () {
                  _showDeleteConfirmationDialog(
                    context,
                    Provider.of<ProductProvider>(context, listen: false),
                    item['id'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
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
            tooltip: AppLocalizations.of(context)!.chooseLanguage,
            icon: const Icon(
              Icons.language,
              size: 30,
              color: AppColors.background,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return buildStandardDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.chooseLanguage,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                final myAppState = context
                                    .findAncestorStateOfType<MyAppState>();
                                myAppState?.changeLanguage(Locale('en'));
                                Navigator.pushNamed(
                                    context, Routes.productList);
                              },
                              child: const Text("English"),
                            ),
                            const SizedBox(width: 60),
                            TextButton(
                              onPressed: () {
                                final myAppState = context
                                    .findAncestorStateOfType<MyAppState>();
                                myAppState?.changeLanguage(Locale('pt'));
                                Navigator.pushNamed(
                                    context, Routes.productList);
                              },
                              child: const Text("Português"),
                            ),
                          ],
                        ),
                      ],
                    ),
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
              Navigator.pushNamed(context, Routes.profile);
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
                    Navigator.pushNamed(context, Routes.productForm).then((_) {
                      tableKey.currentState?.reload();
                    });
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
                    shape: RoundedRectangleBorder(borderRadius: radiusBorder),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    showProductDialog(context).then((_) {
                      tableKey.currentState?.reload();
                    });
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.add, color: AppColors.background),
                      const SizedBox(width: 5),
                      Text(AppLocalizations.of(context)!.newProduct,
                          style: TextStyle(color: AppColors.background))
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      secondaryHeaderColor:
                          AppColors.primary, 
                    ),
                    child: ATable<Map<String, dynamic>>(
                      key: tableKey,
                      columns: columns,
                      loadItems: (_, __) async => provider.products,
                      striped: true,
                      fontSize: 14,
                      rowPadding: const EdgeInsets.all(12),
                      customRowColor: (item) =>
                          item['quantity'] == 0 ? Colors.red.shade50 : null,
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

  void _showDeleteConfirmationDialog(
      BuildContext context, ProductProvider provider, int productId) {
    showDialog(
      context: context,
      builder: (context) {
        return buildStandardDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.confirmDelete,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(AppLocalizations.of(context)!.deleteMessage),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.productList);
                    },
                    child: Text(AppLocalizations.of(context)!.dialogCancel),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      provider.deleteProduct(productId);
                      Navigator.pop(context);
                    },
                    style:
                        TextButton.styleFrom(foregroundColor: AppColors.accent),
                    child: Text(AppLocalizations.of(context)!.delete),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
