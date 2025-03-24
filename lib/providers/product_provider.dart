import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _products = [
    {'id': 1, 'name': 'lunaDress', 'category': 'dress', 'quantity': 12, 'price': "R\$ 50,00"},
    {'id': 2, 'name': 'zigPants', 'category': 'pants', 'quantity': 5, 'price': "R\$ 60,00"},
  ];

  List<Map<String, dynamic>> get products => List.unmodifiable(_products);

  // Método para adicionar um produto
  void addProduct(Map<String, dynamic> product) {
  int newId = _products.isNotEmpty ? _products.last['id'] + 1 : 1; 
  product['id'] = newId;
  _products.add(product);
  notifyListeners();
}

  void updateProduct(Map<String, dynamic> updatedProduct) {
  int index = _products.indexWhere((prod) => prod['id'] == updatedProduct['id']);
  if (index != -1) {
    _products[index] = {
      ..._products[index],
      ...updatedProduct, 
    };
    notifyListeners();
  }
}

  void deleteProduct(int id) {
    _products.removeWhere((product) => product['id'] == id);
    notifyListeners();
  }
}
