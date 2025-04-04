import 'package:almeidatec/api/api.dart';
import 'package:almeidatec/configs.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/core/http_utils.dart';
import 'package:almeidatec/core/main_drawer.dart';
import 'package:almeidatec/main.dart';
import 'package:almeidatec/providers/theme_provider.dart';
import 'package:almeidatec/routes.dart';
import 'package:awidgets/fields/a_field_password.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.background),
        actions: [
          Tooltip(
            message: AppLocalizations.of(context)!.toggleTheme,
            child: IconButton(
              icon: Icon(
                Provider.of<ThemeProvider>(context).isDark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                size: 30,
                color: AppColors.background,
              ),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ),

          /// Botão para mudar idioma
          IconButton(
            tooltip: AppLocalizations.of(context)!.chooseLanguage,
            icon: const Icon(
              Icons.language,
              size: 30,
              color: AppColors.background,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return buildStandardDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.chooseLanguage,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                final myAppState = context
                                    .findAncestorStateOfType<MyAppState>();
                                myAppState?.changeLanguage(Locale('en'));
                                Navigator.pushNamed(
                                    context, Routes.profile);
                              },
                              child: const Text("English"),
                            ),
                            const SizedBox(width: 60),
                            TextButton(
                              onPressed: () {
                                final myAppState = context
                                    .findAncestorStateOfType<MyAppState>();
                                myAppState?.changeLanguage(Locale('pt'));
                                Navigator.pushNamed(
                                    context, Routes.profile);
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
        ],
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
