import 'package:almeidatec/api/api.dart';
import 'package:almeidatec/configs.dart';
import 'package:almeidatec/models/user.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  final List<User> _users = [];

  List<User> get users => _users;

  Future<void> addUser(User user) async {
    final accountId = selectedAccount?.id ?? 0;
    final createdMember = await API.users.createMember(accountId, user);
    _users.add(createdMember);
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    final accountId = selectedAccount?.id ?? 0;

    final updatedUser =
        await API.users.editMember(accountId: accountId, user: user);

    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners();
    }
  }

  Future<void> toggleUserActive(User user, bool isActive) async {
    final accountId = selectedAccount?.id;
    if (accountId == null) throw Exception('Conta não selecionada.');

    await API.users.toggleActive(
      userId: user.id,
      accountId: accountId,
      isActive: isActive,
    );

    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user.copyWith(isActive: isActive);
      notifyListeners();
    }
  }
}
