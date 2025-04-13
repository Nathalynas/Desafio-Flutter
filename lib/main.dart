// ignore_for_file: avoid_print

import 'package:almeidatec/providers/theme_provider.dart';
import 'package:almeidatec/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:almeidatec/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔕 Mensagem em segundo plano recebida: ${message.messageId}');
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  bool isLoggedIn = await AuthService.isUserLoggedInAndStayConnected();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  static final GlobalKey<NavigatorState> appStateKey = GlobalKey<NavigatorState>();

  const MyApp({super.key, required this.isLoggedIn});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale _locale = const Locale('pt'); 

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey, 
      navigatorKey: MyApp.appStateKey,

      locale: _locale, 
      supportedLocales: const [
        Locale('en', ''),
        Locale('pt', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: widget.isLoggedIn ? Routes.productList : Routes.login, 
      onGenerateRoute: (settings) => Routes.generateRoute(settings, changeLanguage),
    );
  }

  @override
void initState() {
  super.initState();

  // Solicita permissão (Android 13+ e iOS)
  FirebaseMessaging.instance.requestPermission();

  // Mensagens recebidas com o app aberto
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null) {
      final snackBar = SnackBar(content: Text(notification.title ?? 'Nova notificação'));
      scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }
  });

  // Quando o usuário clica na notificação e abre o app
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('📨 App aberto por notificação: ${message.data}');
  });
}
}
