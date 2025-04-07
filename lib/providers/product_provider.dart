import 'package:almeidatec/api/api.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  int? _accountId;
  int? get accountId => _accountId;

  Future<void> _loadAccountId() async {
  if (_accountId != null) return;

  final profile = await API().getUserData();
  _accountId = profile?.accountId;

  if (_accountId == null) {
    throw Exception("accountId não encontrado no token JWT");
  }
}

  /// Carrega todos os produtos do backend
  Future<void> loadProducts() async {
  await _loadAccountId();

  if (_accountId == null) {
    throw Exception("accountId não foi carregado");
  }

  final result = await API.products.getAllProducts(accountId: _accountId!);
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
