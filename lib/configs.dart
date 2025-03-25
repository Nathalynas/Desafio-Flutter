import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Definição da variável para bordas arredondadas
BorderRadius radiusBorder = BorderRadius.circular(8);

// Máscara para valores de produto
final productPriceFormatter = MoneyMaskedTextController(
  decimalSeparator: ',',
  thousandSeparator: '.',
  leftSymbol: "R\$ ",
  initialValue: 0,
  precision: 2,
);

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

// Definição de dimensões globais para diálogos
const double kDialogMinWidth = 300.0;
const double kDialogMaxWidth = 600.0;
const double kDialogMinHeight = 200.0;
const double kDialogMaxHeight = 600.0;

/// Função para criar um diálogo padronizado
/// Função para criar um diálogo padronizado
Widget buildStandardDialog({required Widget content, List<Widget>? footer}) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: radiusBorder),
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: kDialogMinWidth,
        maxWidth: kDialogMaxWidth,
        minHeight: kDialogMinHeight,
        maxHeight: kDialogMaxHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            content,
            if (footer != null) ...[
              const SizedBox(height: 20), 
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: footer, 
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

