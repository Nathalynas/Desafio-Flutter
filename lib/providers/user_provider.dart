import 'package:almeidatec/models/user.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  final List<User> _users = [];

  List<User> get users => _users;

  Future<void> loadUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> addUser(User user) async {
    _users.add(user);
    notifyListeners();
  }

  Future<void> updateUser(User updatedUser) async {
    final index = _users.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners();
    }
  }

  Future<void> deleteUser(int userId) async {
    _users.removeWhere((u) => u.id == userId);
    notifyListeners();
  }
}

