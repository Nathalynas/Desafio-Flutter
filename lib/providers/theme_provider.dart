import 'package:flutter/material.dart';
import '../core/themes.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeData get themeData => _isDark ? themeDarkData() : themeLightData();

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}