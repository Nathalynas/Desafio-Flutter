import 'package:flutter/material.dart';
import '../core/colors.dart';

ThemeData themeLightData() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      titleTextStyle:
          const TextStyle(color: AppColors.background, fontSize: 20),
      iconTheme: const IconThemeData(color: AppColors.background),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16),
      titleMedium: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
    ),
  );
}

ThemeData themeDarkData() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      titleTextStyle:
          const TextStyle(color: AppColors.background, fontSize: 20),
      iconTheme: const IconThemeData(color: AppColors.background),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.background,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.background, fontSize: 16),
      titleMedium: const TextStyle(color: AppColors.background, fontSize: 16),
    ),
  );
}
