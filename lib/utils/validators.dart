class Validators {
  /// Valida um e-mail.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'O e-mail é obrigatório.';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Insira um e-mail válido.';
    }
    return null;
  }

  /// Valida uma senha.
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'A senha é obrigatória.';
    }
    if (value.length < minLength) {
      return 'A senha deve ter pelo menos $minLength caracteres.';
    }
    return null;
  }

  /// Valida um campo obrigatório.
  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo é obrigatório.';
    }
    return null;
  }

  /// Valida um número inteiro positivo maior que zero (Ex: Quantidade de produtos).
  static String? validateInteger(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo é obrigatório.';
    }
    final int? number = int.tryParse(value);
    if (number == null || number <= 0) {
      return 'Insira um número maior que 0.';
    }
    return null;
  }

  /// Valida um preço positivo maior que zero.
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'O valor é obrigatório.';
    }
    if (value.replaceAll('R\$ ', '') == '0,00') {
      return 'O valor deve ser maior que R\$ 0,00';
    }
    return null;
  }
}
