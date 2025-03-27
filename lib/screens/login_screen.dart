import 'package:awidgets/general/a_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:awidgets/fields/a_field_email.dart';
import 'package:awidgets/fields/a_field_password.dart';
import '../configs.dart';
import '../utils/validators.dart';
import '../services/auth_service.dart';
import '../routes.dart';
import '../core/colors.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function(Locale) changeLanguage;

  const LoginScreen({super.key, required this.changeLanguage});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool _stayConnected = false;
  bool _isLoading = false;

  void _showForgotPasswordDialog() {
    TextEditingController emailResetController = TextEditingController();
    bool isValidEmail = false;
    bool hasTyped = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return buildStandardDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.enterYourEmail),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailResetController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.email,
                      border: const OutlineInputBorder(),
                      errorText: hasTyped &&
                              Validators.validateEmail(
                                      emailResetController.text, context) !=
                                  null
                          ? AppLocalizations.of(context)!.enterValidEmail
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        hasTyped = true;
                        isValidEmail =
                            Validators.validateEmail(value, context) == null;
                      });
                    },
                  ),
                ],
              ),
              footer: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.dialogCancel),
                ),
                ElevatedButton(
                  onPressed: isValidEmail
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!.passwordResetSent),
                              backgroundColor: AppColors.green,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      : null,
                  child: Text(AppLocalizations.of(context)!.send),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 350),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  width: 350,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: radiusBorder,
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.textPrimary,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset('assets/logo.png', height: 130),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)!.loginMessage,
                            style:
                                TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                          ),
                        ),
                      ),
                      AForm<Map<String, dynamic>>(
                        fromJson: (json) => json as Map<String, dynamic>,
                        showDefaultAction: false,
                        submitText: AppLocalizations.of(context)!.login,
                        onSubmit: (data) async {
                          setState(() => _isLoading = true);
                          final navigator = Navigator.of(context);
                          final messenger = ScaffoldMessenger.of(context);
                          final localizations = AppLocalizations.of(context)!;

                          try {
                            final email = data['email']?.trim() ?? '';
                            final password = data['password']?.trim() ?? '';

                            if (email == "teste@email.com" &&
                                password == "123456") {
                              await AuthService.saveLoginToken(email);
                              navigator.pushNamedAndRemoveUntil(
                                  Routes.productList, (route) => false);
                            } else {
                              messenger.showSnackBar(
                                SnackBar(
                                  content:
                                      Text(localizations.invalidCredentials),
                                  backgroundColor: AppColors.accent,
                                ),
                              );
                            }
                          } finally {
                            setState(() => _isLoading = false);
                          }

                          return null;
                        },
                        fields: [
                          AFieldEmail(
                            identifier: 'email',
                            label: AppLocalizations.of(context)!.email,
                            required: true,
                          ),
                          const SizedBox(height: 10),
                          AFieldPassword(
                            identifier: 'password',
                            label: AppLocalizations.of(context)!.password,
                            minLength: 6,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: _showForgotPasswordDialog,
                              child: Text(
                                AppLocalizations.of(context)!.forgotPassword,
                                style: TextStyle(color: AppColors.accent,
                                decoration: TextDecoration.underline, decorationColor: AppColors.accent, decorationThickness: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Checkbox(
                                value: _stayConnected,
                                onChanged: (value) {
                                  setState(
                                      () => _stayConnected = value ?? false);
                                },
                                activeColor: AppColors.primary,
                              ),
                              Text(
                                AppLocalizations.of(context)!.stayConnected,
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyLarge?.color),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Builder(
                            builder: (context) {
                              return Center(
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          final formState =
                                              AForm.maybeOf(context);
                                          formState?.onSubmit();
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: radiusBorder),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.background),
                                        )
                                      : Text(
                                          AppLocalizations.of(context)!.login,
                                          style: const TextStyle(
                                            color: AppColors.background,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen()),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.dontHaveAccount,
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              tooltip: AppLocalizations.of(context)!.chooseLanguage,
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
