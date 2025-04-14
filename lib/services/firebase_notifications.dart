import 'package:awidgets/general/a_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:almeidatec/main.dart'; // Para acessar scaffoldMessengerKey
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FirebaseNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    // Solicita permissão (Android 13+ / iOS)
    await _messaging.requestPermission();

    // App em foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(notification.title ?? 'Nova notificação'),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    // App aberto por clique na notificação
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = message.notification;
      final context = navigatorKey.currentState?.context;

      if (notification != null && context != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ADialogV2.show(
            context: context,
            title: notification.title ?? 'Sem título',
            content: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(notification.body ?? 'Sem conteúdo'),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.dialogCancel),
                ),
              ),
            ],
            width: 400,
          );
        });
      }
    });
  }
}
