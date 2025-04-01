import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyToken = 'auth_token';
  static const String _keyStayConnected = 'stay_connected';

  /// Salva o token de login no SharedPreferences
  static Future<void> saveLoginToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  /// Simula o cadastro do usuário e salva um token fictício
  static Future<void> registerUser(String name, String email, String password) async {
    // Aqui você pode adicionar lógica para salvar o usuário em um banco de dados ou API
    await Future.delayed(Duration(seconds: 2)); // Simula um tempo de resposta
    await saveLoginToken("fake_token_12345"); // Salva um token fictício
  }

  /// Busca o token salvo e verifica se o usuário está logado
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken) != null;
  }

  /// Remove o token de login ao sair da conta
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyStayConnected);
  }

  /// Salva o valor da preferência "manter conectado"
  static Future<void> setStayConnected(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyStayConnected, value);
  }

  /// Verifica se o usuário marcou "manter conectado"
  static Future<bool> isStayConnected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyStayConnected) ?? false;
  }

  /// Verifica se o usuário está logado E quer manter a sessão
  static Future<bool> isUserLoggedInAndStayConnected() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    final stayConnected = prefs.getBool(_keyStayConnected) ?? false;
    return token != null && stayConnected;
  }
}
