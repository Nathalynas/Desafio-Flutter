import 'package:almeidatec/configs.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/models/product.dart';
import 'package:almeidatec/routes.dart';
import 'package:awidgets/general/a_button.dart';
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
  final GlobalKey<ATableState<Product>> tableKey =
      GlobalKey<ATableState<Product>>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final columns = <ATableColumn<Product>>[
      ATableColumn(
        titleWidget: Text(
          AppLocalizations.of(context)!.code,
          style: const TextStyle(color: AppColors.background),
        ),
        cellBuilder: (_, __, product) => Text(product.id.toString()),
      ),
      ATableColumn(
        titleWidget: Text(
          AppLocalizations.of(context)!.name,
          style: const TextStyle(color: AppColors.background),
        ),
        cellBuilder: (_, __, product) => Text(
          AppLocalizations.of(context)!.getProductTranslation(product.name),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      ATableColumn(
        titleWidget: Text(
          AppLocalizations.of(context)!.category,
          style: const TextStyle(color: AppColors.background),
        ),
        cellBuilder: (_, __, product) => Text(
          AppLocalizations.of(context)!
              .getCategoryTranslation(product.category),
        ),
      ),
      ATableColumn(
        titleWidget: Text(
          AppLocalizations.of(context)!.quantity,
          style: const TextStyle(color: AppColors.background),
        ),
        cellBuilder: (_, __, product) => Text(
          product.quantity.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      ATableColumn(
        titleWidget: Text(
          AppLocalizations.of(context)!.price,
          style: const TextStyle(color: AppColors.background),
        ),
        cellBuilder: (_, __, product) =>
            Text('R\$ ${product.price.toStringAsFixed(2)}'),
      ),
      ATableColumn(
        titleWidget: Text(
          AppLocalizations.of(context)!.actions,
          style: const TextStyle(color: AppColors.background),
        ),
        cellBuilder: (_, __, product) => Row(
          children: [
            Tooltip(
              message: AppLocalizations.of(context)!.edit,
              child: IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.textSecondary),
                  onPressed: () async {
                    await showProductDialog(
                      context,
                      product: product,
                      onCompleted: (String result) {
                        if (!mounted) return;
                        _showProductSnackBar(result);
                        tableKey.currentState?.reload();
                      },
                    );
                  }),
            ),
            Tooltip(
              message: AppLocalizations.of(context)!.delete,
              child: IconButton(
                icon: const Icon(Icons.delete, color: AppColors.accent),
                onPressed: () {
                  _showDeleteConfirmationDialog(context, provider, product.id);
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
          Tooltip(
            message: AppLocalizations.of(context)!.toggleTheme,
            child: IconButton(
              icon: Icon(
                Provider.of<ThemeProvider>(context).isDark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                size: 30,
                color: AppColors.background,
              ),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
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

          Tooltip(
            message: AppLocalizations.of(context)!.profile,
            child: IconButton(
              icon: const Icon(
                Icons.account_circle,
                size: 30,
                color: AppColors.background,
              ),
              onPressed: () {
                Navigator.pushNamed(context, Routes.profile);
              },
            ),
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
                AButton(
                  text: AppLocalizations.of(context)!.newProduct,
                  onPressed: () async {
                    final result =
                        await Navigator.pushNamed(context, Routes.productForm);
                    if (!mounted) return;
                    if (result is String && result.startsWith('added')) {
                      _showProductSnackBar(result);
                      tableKey.currentState?.reload();
                    }
                  },
                  color: AppColors.primary,
                  textColor: AppColors.background,
                  fontWeight: FontWeight.bold,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  borderRadius: radiusBorder.topLeft.x,
                ),
                const SizedBox(width: 10),
                AButton(
                  text: AppLocalizations.of(context)!.newProduct,
                  landingIcon: Icons.add,
                  onPressed: () async {
                    await showProductDialog(
                      context,
                      onCompleted: (result) {
                        if (!mounted) return;
                        _showProductSnackBar(result);
                        tableKey.currentState?.reload();
                      },
                    );
                  },
                  color: AppColors.accent,
                  textColor: AppColors.background,
                  fontWeight: FontWeight.bold,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  borderRadius: radiusBorder.topLeft.x,
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  return Theme(
                      data: Theme.of(context).copyWith(
                        secondaryHeaderColor: AppColors.primary,
                      ),
                      child: ATable<Product>(
                        key: tableKey,
                        columns: columns,
                        loadItems: (_, __) async => provider.products,
                        striped: true,
                        fontSize: 14,
                        rowPadding: const EdgeInsets.all(12),
                        customRowColor: (product) =>
                            product.quantity == 0 ? Colors.red.shade50 : null,
                      ));
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
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.dialogCancel),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      provider.deleteProduct(productId);
                      Navigator.pop(context);
                      tableKey.currentState?.reload();
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

  void _showProductSnackBar(String typeWithId) {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    final split = typeWithId.split(':');
    final type = split.first;
    final productId = split.length > 1 ? int.tryParse(split[1]) : null;

    final snackbarMessage = type == 'added'
        ? AppLocalizations.of(context)!.snackbarProductSuccess
        : AppLocalizations.of(context)!.snackbarProductUpdated;

    ScaffoldMessenger.of(tableKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          snackbarMessage,
          style: const TextStyle(color: AppColors.background),
        ),
        backgroundColor: AppColors.green,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        action: type == 'added' && productId != null
            ? SnackBarAction(
                label: AppLocalizations.of(context)!.snackbarUndo,
                textColor: AppColors.background,
                onPressed: () async {
                  provider.deleteProduct(productId);
                  tableKey.currentState?.reload();
                },
              )
            : null,
      ),
    );
  }
}
