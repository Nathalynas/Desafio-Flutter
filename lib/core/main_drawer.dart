import 'package:almeidatec/api/api.dart';
import 'package:almeidatec/configs.dart';
import 'package:almeidatec/services/auth_service.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/routes.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

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
        context,
        Routes.login,
        (route) => false,
      );
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

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                localizations.menu,
                style: const TextStyle(
                  color: AppColors.background,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.shopping_bag),
                  title: Text(localizations.productList),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, Routes.productList);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.group),
                  title: Text(localizations.users),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, Routes.userList);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: Text(localizations.profile),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, Routes.profile);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: SizedBox(
              width: double.infinity, 
              child: AButton(
                text: localizations.logout,
                landingIcon: Icons.logout,
                onPressed: () => _logout(context),
                color: AppColors.accent,
                textColor: AppColors.background,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                padding:
                    const EdgeInsets.symmetric(vertical: 12), 
                borderRadius: radiusBorder.topLeft.x,
              ),
            ),
          )
        ],
      ),
    );
  }
}
