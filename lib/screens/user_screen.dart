import 'package:almeidatec/configs.dart';
import 'package:almeidatec/core/colors.dart';
import 'package:almeidatec/core/main_drawer.dart';
import 'package:almeidatec/main.dart';
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
import '../providers/user_provider.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final GlobalKey<ATableState<User>> tableKey = GlobalKey<ATableState<User>>();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false);

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
        cellBuilder: (_, __, user) => Text(user.permissions.join(', ')),
      ),
      ATableColumn(
        titleWidget: Text(
          AppLocalizations.of(context)!.actions,
          style: const TextStyle(color: Colors.white),
        ),
        cellBuilder: (_, __, user) => Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _openUserDialog(user: user);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: AppColors.accent,
              onPressed: () {
                _showDeleteConfirmationDialog(context, user.id);
              },
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
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchHint,
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() => searchText = value);
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
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, provider, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      secondaryHeaderColor: AppColors.primary,
                    ),
                    child: ATable<User>(
                      key: tableKey,
                      columns: columns,
                      loadItems: (_, __) async {
                        await provider.loadUsers();
                        return provider.users
                            .where((u) =>
                                u.name
                                    .toLowerCase()
                                    .contains(searchText.toLowerCase()) ||
                                u.email
                                    .toLowerCase()
                                    .contains(searchText.toLowerCase()))
                            .toList();
                      },
                      striped: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openUserDialog({User? user}) {
    final isEdit = user != null;

    showDialog(
      context: context,
      builder: (context) {
        return AFormDialog<User>(
          title: isEdit
              ? AppLocalizations.of(context)!.editUser
              : AppLocalizations.of(context)!.newUser,
          submitText: AppLocalizations.of(context)!.dialogSave,
          persistent: true,
          initialData: isEdit
              ? {
                  'name': user.name,
                  'email': user.email,
                  'password': user.password,
                  'permissions': user.permissions.map((p) {
                    switch (p) {
                      case 'Usuários':
                        return 1;
                      case 'Criar Produto':
                        return 2;
                      case 'Editar Produto':
                        return 3;
                      default:
                        return 0;
                    }
                  }).toList(),
                }
              : null,
          fields: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                AppLocalizations.of(context)!.newUser,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            AFieldText(
              label: AppLocalizations.of(context)!.name,
              identifier: 'name',
              required: true,
            ),
            AFieldText(
              label: AppLocalizations.of(context)!.email,
              identifier: 'email',
              required: true,
            ),
            AFieldText(
              label: AppLocalizations.of(context)!.password,
              identifier: 'password',
              required: true,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                AppLocalizations.of(context)!.permissions,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            AFieldCheckboxList(
              label: '',
              identifier: 'permissions',
              options: [
                Option(AppLocalizations.of(context)!.userScreen, 1),
                Option(AppLocalizations.of(context)!.productForm, 2),
                Option(AppLocalizations.of(context)!.productEdit, 3),
              ],
              minRequired: 1,
            ),
          ],
          fromJson: (json) => User(
            id: user?.id ?? 0,
            name: json['name'],
            email: json['email'],
            password: json['password'],
            permissions: (json['permissions'] as List).map((id) {
              switch (id) {
                case 1:
                  return AppLocalizations.of(context)!.userScreen;
                case 2:
                  return AppLocalizations.of(context)!.productForm;
                case 3:
                  return AppLocalizations.of(context)!.productEdit;
                default:
                  return AppLocalizations.of(context)!.unknownPermission;
              }
            }).toList(),
          ),
          onSubmit: (userData) async {
            final provider = Provider.of<UserProvider>(context, listen: false);

            if (isEdit) {
              await provider.updateUser(userData);
            } else {
              await provider.addUser(userData);
            }

            return null;
          },
          onSuccess: () {
            if (tableKey.currentState?.mounted ?? false) {
              tableKey.currentState?.reload();
            }

            Navigator.of(context).pop();

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
  }

  void _showDeleteConfirmationDialog(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (context) {
        return buildStandardDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.confirmDelete,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(AppLocalizations.of(context)!.deleteMessage),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.dialogCancel),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () async {
                      final provider =
                          Provider.of<UserProvider>(context, listen: false);
                      await provider.deleteUser(userId);
                      if (!mounted) return;
                      tableKey.currentState?.reload();
                      Navigator.of(this.context).pop();
                    },
                    style:
                        TextButton.styleFrom(foregroundColor: AppColors.accent),
                    child: Text(AppLocalizations.of(context)!.delete),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
