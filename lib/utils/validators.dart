import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';


class Validators {
  /// Valida um e-mail.
  static String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emailRequired;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalidEmail;
    }
    return null;
  }

  /// Valida uma senha.
  static String? validatePassword(String? value, BuildContext context, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }
    if (value.length < minLength) {
      return AppLocalizations.of(context)!.passwordMinLength(minLength.toString());
    }
    return null;
  }

  /// Valida um campo obrigatório.
  static String? validateRequired(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    return null;
  }

  /// Valida um número inteiro positivo maior que zero (Ex: Quantidade de produtos).
  static String? validateInteger(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    final int? number = int.tryParse(value);
    if (number == null || number <= 0) {
      return AppLocalizations.of(context)!.invalidInteger;
    }
    return null;
  }

  /// Valida um preço positivo maior que zero.
  static String? validatePrice(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.priceRequired;
    }
    if (value.replaceAll('R\$ ', '') == '0,00') {
      return AppLocalizations.of(context)!.priceGreaterThanZero;
    }
    return null;
  }
}
