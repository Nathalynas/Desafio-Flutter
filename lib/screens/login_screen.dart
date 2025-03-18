import 'package:almeidatec/core/colors.dart';
import 'package:flutter/material.dart';
import '../screens/product_list_screen.dart';
import '../configs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
      body: Center(
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
                  'Bem-vindo, por favor informe seus dados de acesso.',
                  style: TextStyle(
                    color: AppColors.textSecondary, 
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Esqueci minha senha',
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
                  const Text('Manter-me conectado'),
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
                child: const Text(
                  'Entrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}