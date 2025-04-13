// ignore_for_file: avoid_print
import 'package:almeidatec/providers/theme_provider.dart';
import 'package:almeidatec/routes.dart';
import 'package:almeidatec/services/firebase_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:almeidatec/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔕 Mensagem em segundo plano recebida: ${message.messageId}');
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCPLXk44ckhXVR0M3Cnc9qXAIkKA9bwjP0",
        authDomain: "almeidatec-c2c16.firebaseapp.com",
        projectId: "almeidatec-c2c16",
        storageBucket: "almeidatec-c2c16.appspot.com",
        messagingSenderId: "54812456382",
        appId: "1:54812456382:web:c174d24ab76786175c7faf",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseNotificationService.initialize(MyApp.appStateKey);
  
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
}
