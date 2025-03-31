import 'package:flutter/material.dart';
import '../models/product.dart';


class ProductProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(id: 1, name: 'lunaDress', category: 'dress', quantity: 12, price: 50.00),
    Product(id: 2, name: 'zigPants', category: 'pants', quantity: 5, price: 60.00),
  ];

  List<Product> get products => List.unmodifiable(_products);

  // Método para adicionar um produto
  void addProduct(Product product) {
  _products.add(product);
  notifyListeners();
}

  void updateProduct(Product updatedProduct) {
    int index = _products.indexWhere((prod) => prod.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(int id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
