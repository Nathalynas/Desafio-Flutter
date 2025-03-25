import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../utils/validators.dart';
import 'package:almeidatec/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      
      // Simula o cadastro do usuário
      await AuthService.registerUser(name, email, password);
      
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.login,
        (route) => false,
      );

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 350,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: AppColors.textPrimary,
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
                Image.asset('assets/logo.png', height: 100),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.name,
                    labelStyle: const TextStyle(color: AppColors.textPrimary),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? AppLocalizations.of(context)!.nameRequired : null,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                    labelStyle: const TextStyle(color: AppColors.textPrimary),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      Validators.validateEmail(value, context),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                    labelStyle: const TextStyle(color: AppColors.textPrimary),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      Validators.validatePassword(value, context, minLength: 6),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                      : Text(
                          AppLocalizations.of(context)!.signup,
                          style: const TextStyle(
                            color: AppColors.background,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.alreadyHaveAccount,
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
