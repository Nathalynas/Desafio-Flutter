import 'dart:convert';

import 'package:almeidatec/configs.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/models/profile.dart';
import 'package:almeidatec/routes.dart';
import 'package:almeidatec/services/auth_service.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    // Supondo que há dados do profile salvos como JSON em 'profile_data'
    final profileJson = prefs.getString('profile_data');
    if (profileJson != null) {
      final Map<String, dynamic> jsonData = jsonDecode(profileJson);
      final profile = ProfileData.fromJson(jsonData);
      setState(() {
        _name = profile.name;
        _email = profile.email;
      });
    } else {
      // Caso não haja dados salvos no formato JSON
      setState(() {
        _name = prefs.getString('user_name') ?? "Nathaly Nascimento";
        _email = prefs.getString('user_email') ?? "teste@email.com";
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    bool confirmLogout = await _showLogoutConfirmationDialog(context);
    if (confirmLogout) {
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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                const SizedBox(height: 30),

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
}
