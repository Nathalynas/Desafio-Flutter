import 'package:almeidatec/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/product_form_screen.dart';
import 'screens/product_list_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


typedef ChangeLanguageCallback = void Function(Locale locale);

class Routes {
  static const String login = '/';
  static const String productDialog = '/product-dialog';
  static const String productForm = '/product-form';
  static const String productList = '/product-list';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(
      RouteSettings settings, Function(Locale) changeLanguage) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
            builder: (_) => LoginScreen(changeLanguage: changeLanguage));
      case productForm:
        return MaterialPageRoute(builder: (_) => ProductFormScreen());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case productList:
        return MaterialPageRoute(builder: (_) => ProductListScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text(AppLocalizations.of(context)!.pageNotFound),
            ),
          ),
        );
    }
  }
}
