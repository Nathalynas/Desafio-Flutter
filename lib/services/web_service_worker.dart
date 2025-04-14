// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js' as js;

void registerServiceWorker() {
  js.context.callMethod('eval', [
    """
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.register('firebase-messaging-sw.js')
      .then(function(registration) {
        console.log('✅ Service Worker registrado:', registration.scope);
      }).catch(function(err) {
        console.log('❌ Erro ao registrar o Service Worker:', err);
      });
    }
    """
  ]);
}
