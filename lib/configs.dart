import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Definição da variável para bordas arredondadas
 BorderRadius radiusBorder = BorderRadius.circular(8);

// Máscara para formatação de preço (exemplo: R\$ 1.234,56)
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    double value = double.tryParse(newText) ?? 0.0;
    
    String formattedValue = 'R\$ ${(value / 100).toStringAsFixed(2)}';
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

// Máscara para código numérico
class NumericInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.replaceAll(RegExp(r'[^0-9]'), ''),
      selection: newValue.selection,
    );
  }
}