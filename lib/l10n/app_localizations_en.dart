// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get chooseLanguage => 'Choose a language';

  @override
  String get loginMessage => 'Welcome, please enter your login details.';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot my password';

  @override
  String get stayConnected => 'Stay connected';

  @override
  String get login => 'Login';
}
