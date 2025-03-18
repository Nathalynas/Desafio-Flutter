import 'package:almeidatec/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../screens/product_list_screen.dart';
import '../configs.dart';

class LoginScreen extends StatefulWidget {
  final Function(Locale) changeLanguage; // Função para alterar idioma

  const LoginScreen({super.key, required this.changeLanguage});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _stayConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Conteúdo principal
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 350,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(radiusBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo.png', height: 150),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.loginMessage,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.password),
                    obscureText: true,
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
                      Text(AppLocalizations.of(context)!.stayConnected),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radiusBorder),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductListScreen(),
                        ),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Positioned(
            top: 40, // Define a altura do ícone
            right: 20, // Define a posição à direita
            child: IconButton(
              icon: const Icon(Icons.language, color: Colors.white, size: 30),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.chooseLanguage),
                      actions: [
                        TextButton(
                          onPressed: () {
                            widget.changeLanguage(Locale('en'));
                            Navigator.pop(context);
                          },
                          child: const Text("English"),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.changeLanguage(Locale('pt'));
                            Navigator.pop(context);
                          },
                          child: const Text("Português"),
                        ),
                      ],
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

