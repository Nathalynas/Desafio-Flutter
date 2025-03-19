import 'package:almeidatec/providers/product_provider.dart';
import 'package:almeidatec/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'configs.dart';
import 'core/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale _locale = Locale('pt'); // Define o idioma inicial

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale; // Atualiza o idioma
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        locale: _locale, // Define o idioma atual do app
        supportedLocales: [
          Locale('en', ''), // Inglês
          Locale('pt', ''), // Português
        ],
        localizationsDelegates: [
          AppLocalizations.delegate, // Traduções personalizadas
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: AppColors.primary,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusBorder),
            ),
          ),
        ),
        home: LoginScreen(changeLanguage: changeLanguage), // Passa a função de trocar idioma
      ),
    );
  }
}
