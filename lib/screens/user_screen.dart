import 'package:almeidatec/api/api.dart';
import 'package:almeidatec/configs.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/core/main_drawer.dart';
import 'package:almeidatec/main.dart';
import 'package:almeidatec/models/account.dart';
import 'package:almeidatec/models/account_permission.dart';
import 'package:almeidatec/providers/theme_provider.dart';
import 'package:almeidatec/routes.dart';
import 'package:awidgets/fields/a_field_checkbox_list.dart';
import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/fields/a_option.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_table.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import '../models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final GlobalKey<ATableState<User>> tableKey = GlobalKey<ATableState<User>>();

  String searchText = '';
  bool showInactives = false;

  final List<PermissionData> allPermissions = [
    PermissionData(
      permission: AccountPermission.account_management,
      ptBr: 'Gerenciamento de contas',
    ),
    PermissionData(
      permission: AccountPermission.users,
      ptBr: 'Tela de Usuários',
    ),
    PermissionData(
      permission: AccountPermission.add_and_delete_products,
      ptBr: 'Cadastro e edição de produtos',
    ),
  ];

  List<Option> getPermissionOptions(BuildContext context) {
    return List.generate(
      allPermissions.length,
      (index) => Option(allPermissions[index].ptBr, index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final columns = <ATableColumn<User>>[
      ATableColumn(
        titleWidget: Text(
          AppLocalizations.of(context)!.name,
          style: const TextStyle(color: Colors.white),
        ),
        cellBuilder: (_, __, user) => Text(user.name),
      ),
      ATableColumn(
        titleWidget: Text(
          AppLocalizations.of(context)!.email,
          style: const TextStyle(color: Colors.white),
        ),
        cellBuilder: (_, __, user) => Text(user.email),
      ),
      ATableColumn(
        titleWidget: Text(
          AppLocalizations.of(context)!.permissions,
          style: const TextStyle(color: Colors.white),
        ),
        cellBuilder: (_, __, user) => Wrap(
          spacing: 6,
          runSpacing: 4,
          children: user.permissions.map((p) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                p.ptBr,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      ATableColumn(
        titleWidget: Text(
          'Status',
          style: const TextStyle(color: AppColors.background),
        ),
        cellBuilder: (_, __, user) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: user.isActive
                // ignore: deprecated_member_use
                ? AppColors.green.withOpacity(0.1)
                // ignore: deprecated_member_use
                : AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            user.isActive ? 'Ativo' : 'Inativo',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: user.isActive ? AppColors.green : AppColors.accent,
            ),
          ),
        ),
      ),
      ATableColumn(
        titleWidget: Text(
          AppLocalizations.of(context)!.actions,
          style: const TextStyle(color: AppColors.background),
        ),
        cellBuilder: (_, __, user) => Row(
          children: [
            IconButton(
              tooltip: AppLocalizations.of(context)!.edit,
              icon: const Icon(Icons.edit),
              onPressed: () {
                _openUserDialog(user: user);
              },
            ),
            IconButton(
              tooltip: user.isActive
                  ? AppLocalizations.of(context)!.deactivateUser
                  : AppLocalizations.of(context)!.activateUser,
              icon: Icon(
                user.isActive ? Icons.toggle_on : Icons.toggle_off,
                color:
                    user.isActive ? AppColors.green : AppColors.textSecondary,
                size: 28,
              ),
              onPressed: () => _toggleUserActive(user),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      drawer: const MainDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          AppLocalizations.of(context)!.userScreen,
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
                                Navigator.pushNamed(context, Routes.userList);
                              },
                              child: const Text("English"),
                            ),
                            const SizedBox(width: 60),
                            TextButton(
                              onPressed: () {
                                final myAppState = context
                                    .findAncestorStateOfType<MyAppState>();
                                myAppState?.changeLanguage(Locale('pt'));
                                Navigator.pushNamed(context, Routes.userList);
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AFieldText(
                    label: AppLocalizations.of(context)!.searchHint,
                    identifier: 'search',
                    onChanged: (value) {
                      setState(() => searchText = value!);
                      tableKey.currentState?.reload();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                AButton(
                  text: AppLocalizations.of(context)!.newUser,
                  landingIcon: Icons.person_add,
                  onPressed: _openUserDialog,
                  color: AppColors.accent,
                  textColor: AppColors.background,
                  fontWeight: FontWeight.bold,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  borderRadius: radiusBorder.topLeft.x,
                ),
                const SizedBox(width: 12),
                AButton(
                  text: AppLocalizations.of(context)!.inactiveUsers,
                  landingIcon: Icons.person_off,
                  onPressed: () {
                    setState(() {
                      showInactives = !showInactives;
                    });
                    tableKey.currentState!.reload();
                  },
                  color: AppColors.textSecondary,
                  textColor: AppColors.background,
                  fontWeight: FontWeight.bold,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  borderRadius: radiusBorder.topRight.x,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  secondaryHeaderColor: AppColors.primary,
                ),
                child: ATable<User>(
                  key: tableKey,
                  columns: columns,
                  loadItems: (_, __) async {
                    return await API.users.getMembers(
                      selectedAccount!.id,
                      !showInactives,
                    );
                  },
                  striped: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openUserDialog({User? user}) {
    final isEdit = user != null;

    final List<int> selectedPermissionIndexes = isEdit
        ? user.permissions
            .map((p) => allPermissions
                .indexWhere((perm) => perm.permission == p.permission))
            .where((i) => i != -1)
            .toList()
        : [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AFormDialog<User>(
              title: isEdit
                  ? AppLocalizations.of(context)!.editUser
                  : AppLocalizations.of(context)!.newUser,
              submitText: AppLocalizations.of(context)!.dialogSave,
              persistent: true,
              fields: [
                if (!isEdit)
                  AFieldText(
                      label: AppLocalizations.of(context)!.name,
                      identifier: 'name',
                      required: true),
                if (!isEdit)
                  AFieldText(
                      label: AppLocalizations.of(context)!.email,
                      identifier: 'email',
                      required: true),
                if (!isEdit)
                  AFieldText(
                      label: AppLocalizations.of(context)!.password,
                      identifier: 'password',
                      required: !isEdit),
                AFieldCheckboxList(
                  label: AppLocalizations.of(context)!.permissions,
                  identifier: 'permissions',
                  options: getPermissionOptions(context),
                  minRequired: 1,
                  initialValue: selectedPermissionIndexes,
                  onChanged: (newValues) {
                    setState(() {
                      selectedPermissionIndexes.clear();
                      selectedPermissionIndexes.addAll(
                          // ignore: unnecessary_cast
                          newValues!.map((e) => e as int).toList());
                    });
                  },
                ),
              ],
              fromJson: (json) => User(
                id: user?.id ?? 0,
                name: json['name'] ?? user?.name ?? '',
                email: json['email'] ?? user?.email ?? '',
                password: json['password'] ?? '',
                permissions: selectedPermissionIndexes
                    .map((i) => allPermissions[i])
                    .toList(),
              ),
              onSubmit: (userData) async {
                final accountId = selectedAccount?.id ?? 0;

                final userToSave = isEdit
                    ? user.copyWith(
                        name: userData.name,
                        email: userData.email,
                        password: userData.password!.trim().isEmpty
                            ? user.password
                            : userData.password,
                        permissions: userData.permissions,
                      )
                    : userData;

                if (isEdit) {
                  await API.users.editMember(accountId: accountId, user: userToSave);
                } else {
                  await API.users.createMember(accountId, userToSave);
                }

                return null;
              },
              onSuccess: () {
                if (!mounted) return;
                tableKey.currentState?.reload();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEdit
                        ? AppLocalizations.of(context)!.userEdited
                        : AppLocalizations.of(context)!.userAdded),
                    backgroundColor: AppColors.green,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _toggleUserActive(User user) async {
    try {
      final updated = user.copyWith(isActive: !user.isActive);
      final accountId = selectedAccount?.id ?? 0;

      await API.users.toggleActive(
        userId: user.id,
        accountId: accountId,
        isActive: updated.isActive,
      );

      tableKey.currentState?.reload();
      if (!mounted) return;

      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(updated.isActive
              ? localizations.userActivated
              : localizations.userDeactivated),
          backgroundColor: updated.isActive ? Colors.green : Colors.orange,
        ),
      );
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${localizations.toggleStatusError}: ${e.toString()}'),
          duration: const Duration(seconds: 5),
          backgroundColor: AppColors.accent,
        ),
      );
    }
  }
}
