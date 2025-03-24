import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../configs.dart';
import '../utils/validators.dart';
import 'package:almeidatec/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final Function(Locale) changeLanguage;

  const LoginScreen({super.key, required this.changeLanguage});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave do formulário
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _stayConnected = false;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Inicia o loading

      // Simula uma autenticação simples
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (email == "teste@email.com" && password == "123456") {
        await AuthService.saveLoginToken(email);

        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.productList,
          (route) => false,
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.invalidCredentials),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() => _isLoading = false); // Para o loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: radiusBorder,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/logo.png', height: 150),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.loginMessage,
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Campo de e-mail
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.email,
                        labelStyle:
                            const TextStyle(color: AppColors.textPrimary),
                        errorStyle: TextStyle(color: AppColors.accent),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const <String>[AutofillHints.email],
                      validator: (value) =>
                          Validators.validateEmail(value, context),
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),

                    const SizedBox(height: 10),

                    /// Campo de senha
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.password,
                        labelStyle:
                            const TextStyle(color: AppColors.textPrimary),
                        errorStyle: TextStyle(color: AppColors.accent),
                      ),
                      obscureText: true,
                      validator: (value) => Validators.validatePassword(
                          value, context,
                          minLength: 6),
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.forgotPassword,
                        style: TextStyle(
                          color: AppColors.accent,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),

                    /// Checkbox "Manter Conectado"
                    Row(
                      children: [
                        Checkbox(
                          value: _stayConnected,
                          onChanged: (value) {
                            setState(() {
                              _stayConnected = value ?? false;
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                        Text(
                          AppLocalizations.of(context)!.stayConnected,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    /// Botão de Login
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: radiusBorder,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15)),
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white))
                          : Text(
                              AppLocalizations.of(context)!.login,
                              style: const TextStyle(
                                color: AppColors.background,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Ícone de mudança de idioma
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.language,
                  color: AppColors.background, size: 30),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return buildStandardDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.chooseLanguage,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  widget.changeLanguage(const Locale('en'));
                                  Navigator.pushNamed(context, Routes.login);
                                },
                                child: const Text("English"),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget.changeLanguage(const Locale('pt'));
                                  Navigator.pushNamed(context, Routes.login);
                                },
                                child: const Text("Português"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
