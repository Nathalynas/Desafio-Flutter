// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCPLXk44kchXVR0M3Cnc9qXAIkKA9bwjP0',
    appId: '1:548121456382:web:c174d24ab76786175c7faf',
    messagingSenderId: '548121456382',
    projectId: 'almeidatec-c2c16',
    authDomain: 'almeidatec-c2c16.firebaseapp.com',
    storageBucket: 'almeidatec-c2c16.firebasestorage.app',
    measurementId: 'G-F5PDW45JL4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDXmBsJwJb9w0KXE9TDqt9_qtSrv5djlrU',
    appId: '1:548121456382:android:f3b6c9d1af9e3f275c7faf',
    messagingSenderId: '548121456382',
    projectId: 'almeidatec-c2c16',
    storageBucket: 'almeidatec-c2c16.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCf_t9sVDxo3ptvf6TYIZ-2cWw3VauH1R0',
    appId: '1:548121456382:ios:909b45e6c8b1921c5c7faf',
    messagingSenderId: '548121456382',
    projectId: 'almeidatec-c2c16',
    storageBucket: 'almeidatec-c2c16.firebasestorage.app',
    iosBundleId: 'com.example.almeidatec',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCf_t9sVDxo3ptvf6TYIZ-2cWw3VauH1R0',
    appId: '1:548121456382:ios:909b45e6c8b1921c5c7faf',
    messagingSenderId: '548121456382',
    projectId: 'almeidatec-c2c16',
    storageBucket: 'almeidatec-c2c16.firebasestorage.app',
    iosBundleId: 'com.example.almeidatec',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCPLXk44kchXVR0M3Cnc9qXAIkKA9bwjP0',
    appId: '1:548121456382:web:ca3255d1a58cf0405c7faf',
    messagingSenderId: '548121456382',
    projectId: 'almeidatec-c2c16',
    authDomain: 'almeidatec-c2c16.firebaseapp.com',
    storageBucket: 'almeidatec-c2c16.firebasestorage.app',
    measurementId: 'G-LLKBB6P38W',
  );
}
