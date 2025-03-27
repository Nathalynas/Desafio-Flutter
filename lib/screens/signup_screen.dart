import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/routes.dart';
import 'package:awidgets/fields/a_field_email.dart';
import 'package:awidgets/fields/a_field_password.dart';
import 'package:awidgets/fields/a_field_text.dart';
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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

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
          child: AForm<Map<String, dynamic>>(
            fromJson: (json) => json as Map<String, dynamic>,
            showDefaultAction: false,
            submitText: localizations.signup,
            onSubmit: (data) async {
              setState(() => _isLoading = true);

              final name = data['name']?.trim() ?? '';
              final email = data['email']?.trim() ?? '';
              final password = data['password']?.trim() ?? '';

              await AuthService.registerUser(name, email, password);

              navigator.pushNamedAndRemoveUntil(
                Routes.login,
                (route) => false,
              );

              setState(() => _isLoading = false);

              return null;
            },
            fields: [
              Center(
                child: Image.asset('assets/logo.png', height: 100),
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              final formState = AForm.maybeOf(context);
                              formState?.onSubmit();
                            },
                      child: Text(
                        localizations.signup,
                        style: const TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
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
