import 'package:almeidatec/api/api.dart';
import 'package:almeidatec/configs.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/core/http_utils.dart';
import 'package:almeidatec/routes.dart';
import 'package:almeidatec/services/auth_service.dart';
import 'package:awidgets/fields/a_field_password.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String _name = "Carregando...";
  String _email = "Carregando...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await API.profile.getUser();
      setState(() {
        _name = userData['name'] ?? 'Sem nome';
        _email = userData['email'] ?? 'Sem email';
      });
    } catch (e) {
      setState(() {
        _name = 'Erro ao carregar';
        _email = '---';
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    bool confirmLogout = await _showLogoutConfirmationDialog(context);
    if (confirmLogout) {
      try {
        await API.login.logout();
      } catch (e) {
        debugPrint('Erro ao deslogar do servidor: $e');
      }

      await AuthService.logout();
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.login, (route) => false);
    }
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;

    return await showDialog(
          context: context,
          builder: (context) {
            return buildStandardDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localizations.confirmLogoutTitle,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(localizations.confirmLogoutMessage),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(localizations.dialogCancel),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.accent),
                        child: Text(localizations.logout),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.profile,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),

                // Nome do usuário
                Text(
                  _name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 5),

                // Email do usuário
                Text(
                  _email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),

                const SizedBox(height: 20),

                // Botão de Editar Perfil
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: AButton(
                    text: localizations.editProfile,
                    landingIcon: Icons.edit,
                    onPressed: _showEditProfileDialog,
                    color: AppColors.primary,
                    textColor: AppColors.background,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    borderRadius: radiusBorder.topLeft.x,
                  ),
                ),

                const SizedBox(height: 10),
                // Botão de Logout
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: AButton(
                      text: localizations.logout,
                      landingIcon: Icons.logout,
                      onPressed: () => _logout(context),
                      color: AppColors.accent,
                      textColor: AppColors.background,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      borderRadius: radiusBorder.topLeft.x,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showEditProfileDialog() async {
    final localizations = AppLocalizations.of(context)!;

    await AFormDialog.show<Map<String, dynamic>>(
      context,
      title: localizations.editProfile,
      persistent: true,
      submitText: localizations.confirm,
      fromJson: (json) => json as Map<String, dynamic>,
      onSubmit: (Map<String, dynamic> data) async {
        try {
          await API.profile.updateUser(
            name: data['name'],
            newPassword: data['new_password'],
            oldPassword: data['old_password'],
          );

          if (!mounted) return;
          Navigator.pop(context); // Fecha o dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.profileUpdated),
              backgroundColor: AppColors.green,
            ),
          );

          _loadUserData(); // Atualiza os dados exibidos
        } catch (e) {
          if (!mounted) return;

          String errorMsg = AppLocalizations.of(context)!.somethingWentWrong;

          if (e is HTTPError) {
            if (e.statusCode == 401) {
              errorMsg = AppLocalizations.of(context)!.wrongPassword;
            } else if (e.statusCode == 404) {
              errorMsg = AppLocalizations.of(context)!.samePassword;
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: AppColors.accent,
            ),
          );
        }
        return null;
      },
      fields: [
        AFieldText(
          identifier: 'name',
          label: localizations.name,
          required: true,
          initialValue: _name,
        ),
        const SizedBox(height: 10),
        AFieldPassword(
          identifier: 'old_password',
          label: localizations.currentPassword,
          minLength: 6,
        ),
        const SizedBox(height: 10),
        AFieldPassword(
          identifier: 'new_password',
          label: localizations.newPassword,
          minLength: 6,
        ),
      ],
    );
  }
}
