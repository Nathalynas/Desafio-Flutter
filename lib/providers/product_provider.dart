
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _products = [
    {'id': 1, 'name': 'VESTIDO LUNA', 'category': 'VESTIDO', 'quantity': 12},
    {'id': 2, 'name': 'CALÇA ZIG', 'category': 'CALÇA', 'quantity': 5},
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
