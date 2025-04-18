import 'package:almeidatec/api/api.dart';
import 'package:almeidatec/core/http_utils.dart';
import 'package:almeidatec/models/forgot_password.dart';
import 'package:almeidatec/models/login.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_form.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:awidgets/fields/a_field_email.dart';
import 'package:awidgets/fields/a_field_password.dart';
import '../configs.dart';
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

  Future<void> _showForgotPasswordDialog() async {
    await AFormDialog.show<ForgotPasswordData>(
      context,
      title: AppLocalizations.of(context)!.forgotPassword,
      persistent: true,
      submitText: AppLocalizations.of(context)!.send,
      fromJson: (json) =>
          ForgotPasswordData.fromJson(json as Map<String, dynamic>),
      onSubmit: (ForgotPasswordData data) async {
        try {
          await API.forgotPassword.sendRecoveryEmail(email: data.email.trim());
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.passwordResetSent),
              backgroundColor: AppColors.green,
            ),
          );

          // Mostrar o diálogo para redefinir senha
          // ignore: avoid_print
          print("Código de recuperação enviado com sucesso");
          await _showResetPasswordDialog();
        } catch (e) {
          if (!mounted) return;
          if (e is HTTPError) {
            final localizations = AppLocalizations.of(context)!;
            final errorMessage = e.statusCode == 401
                ? localizations.expiredCode
                : (e.message ?? localizations.somethingWentWrong);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: AppColors.accent,
              ),
            );
          }
        }
        return null;
      },
      fields: [
        AFieldEmail(
          identifier: 'email',
          label: AppLocalizations.of(context)!.email,
          required: true,
        ),
      ],
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
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color),
                          ),
                        ),
                      ),
                      AForm<LoginData>(
                        fromJson: (json) =>
                            LoginData.fromJson(json as Map<String, dynamic>),
                        showDefaultAction: false,
                        submitText: AppLocalizations.of(context)!.login,
                        onSubmit: (LoginData data) async {
                          setState(() => _isLoading = true);

                          final navigator = Navigator.of(context);
                          final messenger = ScaffoldMessenger.of(context);
                          final localizations = AppLocalizations.of(context)!;

                          try {
                            await API.login.login(
                              email: data.email.trim(),
                              password: data.password.trim(),
                            );
                            await AuthService.saveLoginToken(data.email);
                            await AuthService.setStayConnected(_stayConnected);
                            await API.accounts.getAccounts();
                            
                            navigator.pushNamedAndRemoveUntil(
                                Routes.productList, (route) => false);
                          } catch (e) {
                            if (e is HTTPError) {
                              // ignore: avoid_print
                              print('Erro: ${e.statusCode} - ${e.message}');
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
                                style: TextStyle(
                                    color: AppColors.accent,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.accent,
                                    decorationThickness: 1.5),
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
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Builder(
                            builder: (context) {
                              return Center(
                                  child: AButton(
                                text: AppLocalizations.of(context)!.login,
                                onPressed: () {
                                  final formState = AForm.maybeOf(context);
                                  formState?.onSubmit();
                                },
                                loading: _isLoading,
                                color: AppColors.primary,
                                textColor: AppColors.background,
                                fontWeight: FontWeight.bold,
                                borderRadius: radiusBorder.topLeft.x,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                              ));
                            },
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
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

  Future<void> _showResetPasswordDialog() async {
    await AFormDialog.show<Map<String, dynamic>>(
      context,
      title: AppLocalizations.of(context)!.resetPassword,
      persistent: true,
      submitText: AppLocalizations.of(context)!.confirm,
      fromJson: (json) => json as Map<String, dynamic>,
      onSubmit: (Map<String, dynamic> data) async {
        try {
          await API.forgotPassword.resetPassword(
            code: data['code'],
            newPassword: data['new_password'],
          );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.passwordChanged),
              backgroundColor: AppColors.green,
            ),
          );
        } catch (e) {
          if (!mounted) return;
          if (e is HTTPError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message ??
                    AppLocalizations.of(context)!.somethingWentWrong),
                backgroundColor: AppColors.accent,
              ),
            );
          }
        }

        return null;
      },
      fields: [
        AFieldText(
          identifier: 'code',
          label: AppLocalizations.of(context)!.verificationCode,
          required: true,
        ),
        AFieldPassword(
          identifier: 'new_password',
          label: AppLocalizations.of(context)!.newPassword,
          minLength: 6,
        ),
      ],
    );
  }
}
