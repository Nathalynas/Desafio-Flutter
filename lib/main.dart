import 'package:almeidatec/providers/product_provider.dart';
import 'package:almeidatec/providers/theme_provider.dart';
import 'package:almeidatec/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()), // Adicionando ThemeProvider
      ],
      child: const MyApp(),
    ),
  );
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
          AppLocalizations.delegate, 
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        theme: Provider.of<ThemeProvider>(context).themeData,
        home: LoginScreen(changeLanguage: changeLanguage), 
      ),
    );
  }
}
