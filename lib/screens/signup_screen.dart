import 'package:almeidatec/configs.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/models/signup.dart';
import 'package:almeidatec/routes.dart';
import 'package:awidgets/fields/a_field_email.dart';
import 'package:awidgets/fields/a_field_password.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:almeidatec/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 350,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: AppColors.textPrimary,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: AForm<SignupData>(
            fromJson: (json) =>
                SignupData.fromJson(json as Map<String, dynamic>),
            showDefaultAction: false,
            submitText: localizations.signup,
            onSubmit: (SignupData data) async {
              try {
                await AuthService.registerUser(
                  data.name.trim(),
                  data.email.trim(),
                  data.password.trim(),
                );

                if (!mounted) return;

                navigator.pushNamedAndRemoveUntil(
                  Routes.login,
                  (route) => false,
                );
              } catch (e) {
                if (!mounted) return;

                final localizations = AppLocalizations.of(this.context)!;

                final errorMessage =
                    e.toString().contains('already in use')
                        ? localizations.emailAlreadyInUse
                        : e.toString().replaceFirst('Exception: ', '');

                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    backgroundColor: AppColors.accent,
                  ),
                );
              }

              return null;
            },
            fields: [
              Center(
                child: Image.asset('assets/logo.png', height: 130),
              ),
              const SizedBox(height: 10),
              AFieldText(
                identifier: 'name',
                label: localizations.name,
                required: true,
              ),
              const SizedBox(height: 10),
              AFieldEmail(
                identifier: 'email',
                required: true,
                label: localizations.email,
              ),
              const SizedBox(height: 10),
              AFieldPassword(
                identifier: 'password',
                label: localizations.password,
                minLength: 6,
              ),
              const SizedBox(height: 25),
              Builder(
                builder: (context) {
                  return Center(
                      child: AButton(
                    text: localizations.signup,
                    onPressed: () {
                      final formState = AForm.maybeOf(context);
                      formState?.onSubmit();
                    },
                    color: AppColors.primary,
                    textColor: AppColors.background,
                    fontWeight: FontWeight.bold,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    borderRadius: radiusBorder.topLeft.x,
                  ));
                },
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () => navigator.pop(),
                  child: Text(
                    localizations.alreadyHaveAccount,
                    style: TextStyle(color: AppColors.primary),
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
