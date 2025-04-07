import 'package:almeidatec/api/api.dart';
import 'package:almeidatec/configs.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  int? _accountId;
  int? get accountId => _accountId;

  Future<void> _loadAccountId() async {
    await API.accounts.getAccounts();
  }

  /// Carrega todos os produtos do backend
  Future<void> loadProducts() async {
    await _loadAccountId();

    if (selectedAccount == null) {
      await API.accounts.getAccounts();
    }

    final result = await API.products.getAllProducts();
    _products = result.map((json) => Product.fromJson(json)).toList();
    notifyListeners();
  }

  /// Adiciona um novo produto via backend
  Future<void> addProduct(Product product) async {
    await _loadAccountId();
    await API.products.createProduct(
      accountId: _accountId!,
      name: product.name,
      categoryType: product.category,
      quantity: product.quantity,
      value: product.price,
    );
    await loadProducts();
  }

  /// Atualiza um produto existente via backend
  Future<void> updateProduct(Product product) async {
    await _loadAccountId();
    await API.products.updateProduct(
      id: product.id,
      name: product.name,
      categoryType: product.category,
      quantity: product.quantity,
      value: product.price,
    );
    await loadProducts();
  }

  /// Remove produto via backend
  Future<void> deleteProduct(int id) async {
    await _loadAccountId();
    await API.products.deleteProduct(id);
    await loadProducts();
  }

  /// (Opcional) Buscar produto por ID
  Future<Product?> getProductById(int id) async {
    final result = await API.products.getProductById(id);
    return Product.fromJson(result);
  }
}
