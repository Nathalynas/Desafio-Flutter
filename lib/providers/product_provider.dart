import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _products = [
    {'id': 1, 'name': 'lunaDress', 'category': 'dress', 'quantity': 12, 'price': "R\$ 50,00"},
    {'id': 2, 'name': 'zigPants', 'category': 'pants', 'quantity': 5, 'price': "R\$ 60,00"},
  ];

  List<Map<String, dynamic>> get products => _products;

  // Método para adicionar um produto
  void addProduct(Map<String, dynamic> product) {
    _products.add(product);
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }

  void deleteProduct(int id) {
    _products.removeWhere((product) => product['id'] == id);
    notifyListeners();
  }
}
