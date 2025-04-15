import 'package:almeidatec/api/api.dart';
import 'package:almeidatec/configs.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/core/responsiveScaffold.dart';
import 'package:almeidatec/models/product.dart';
import 'package:almeidatec/routes.dart';
import 'package:almeidatec/screens/import_dialog.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_table.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:almeidatec/main.dart';
import 'package:almeidatec/screens/product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final GlobalKey<ATableState<Product>> tableKey =
      GlobalKey<ATableState<Product>>();

  String searchText = '';

  @override
  Widget build(BuildContext context) {
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
          translateCategory(context, product.name),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      ATableColumn(
        titleWidget: Text(
          AppLocalizations.of(context)!.category,
          style: const TextStyle(color: AppColors.background),
        ),
        cellBuilder: (_, __, product) => Text(
          translateCategory(context, product.category),
        ),
      ),
      ATableColumn(
        titleWidget: Text(
          AppLocalizations.of(context)!.quantity,
          style: const TextStyle(color: AppColors.background),
        ),
        cellBuilder: (_, __, product) => Text(
          '${product.quantity}',
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
                  _showDeleteConfirmationDialog(context, product.id);
                },
              ),
            ),
          ],
        ),
      ),
    ];

    return ResponsiveScaffold(
      title: AppLocalizations.of(context)!.productList,
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
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
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
                              final myAppState =
                                  context.findAncestorStateOfType<MyAppState>();
                              myAppState?.changeLanguage(Locale('en'));
                              Navigator.pushNamed(context, Routes.productList);
                            },
                            child: const Text("English"),
                          ),
                          const SizedBox(width: 60),
                          TextButton(
                            onPressed: () {
                              final myAppState =
                                  context.findAncestorStateOfType<MyAppState>();
                              myAppState?.changeLanguage(Locale('pt'));
                              Navigator.pushNamed(context, Routes.productList);
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
      ],
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AFieldText(
                        label: AppLocalizations.of(context)!.searchproduct,
                        identifier: 'search',
                        onChanged: (value) {
                          setState(() => searchText = value!);
                          tableKey.currentState?.reload();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    AButton(
                      text: AppLocalizations.of(context)!.newProduct,
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                            context, Routes.productForm);
                        if (!mounted) return;
                        if (result is String && result.startsWith('added')) {
                          _showProductSnackBar(result);
                          tableKey.currentState?.reload();
                        }
                      },
                      color: AppColors.primary,
                      textColor: AppColors.background,
                      fontWeight: FontWeight.bold,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      borderRadius: radiusBorder.topLeft.x,
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      secondaryHeaderColor: AppColors.primary,
                    ),
                    child: ATable<Product>(
                      key: tableKey,
                      columns: columns,
                      loadItems: (_, __) async {
                        final raw = await API.products.getAllProducts();
                        return raw.map(Product.fromJson).toList();
                      },
                      striped: true,
                      fontSize: 14,
                      rowPadding: const EdgeInsets.all(12),
                      customRowColor: (product) =>
                          product.quantity == 0 ? Colors.red.shade50 : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: Tooltip(
              message: AppLocalizations.of(context)!.importFile,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.upload_file, color: Colors.white),
                  onPressed: () async {
                    await showImportDialog(
                      context,
                      onCompleted: (success, failed) {
                        final localizations = AppLocalizations.of(context)!;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${localizations.snackbarProductImportSuccess(success)}\n'
                              '${localizations.snackbarProductImportFailed(failed)}',
                              style:
                                  const TextStyle(color: AppColors.background),
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );

                        // Se estiver usando tabela com reload:
                        tableKey.currentState?.reload();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int productId) {
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
                    style:
                        TextButton.styleFrom(foregroundColor: AppColors.accent),
                    onPressed: () async {
                      final deletedProduct =
                          await API.products.getProductById(productId);
                      await API.products.deleteProduct(productId);

                      if (!mounted) return;
                      Navigator.pop(this.context);
                      tableKey.currentState?.reload();

                      final localizations = AppLocalizations.of(this.context)!;
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          content: Text(
                            localizations.snackbarProductDeleted,
                            style: const TextStyle(color: AppColors.background),
                          ),
                          backgroundColor: AppColors.green,
                          duration: const Duration(seconds: 5),
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                            label: localizations.snackbarUndo,
                            textColor: AppColors.background,
                            onPressed: () async {
                              await API.products.createProduct(
                                name: deletedProduct['name'],
                                categoryType: deletedProduct['category_type'],
                                quantity: deletedProduct['quantity'],
                                value:
                                    (deletedProduct['value'] as num).toDouble(),
                                accountId: selectedAccount!.id,
                              );
                              tableKey.currentState?.reload();
                            },
                          ),
                        ),
                      );
                    },
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
                  await API.products.deleteProduct(productId);
                  tableKey.currentState?.reload();
                },
              )
            : null,
      ),
    );
  }

  String translateCategory(BuildContext context, String rawCategory) {
    final l10n = AppLocalizations.of(context)!;

    switch (rawCategory.toLowerCase()) {
      case 'vestido':
        return l10n.dress;
      case 'calça':
        return l10n.pants;
      case 'camiseta':
        return l10n.shirt;
      default:
        return rawCategory;
    }
  }
}
