// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDhOVp12aiTjJhozfIXrX8C9P6EqL0Bszc',
    appId: '1:630854078610:web:1b444b294b8f7b9baa164b',
    messagingSenderId: '630854078610',
    projectId: 'flutter-journal-ea1b4',
    authDomain: 'flutter-journal-ea1b4.firebaseapp.com',
    storageBucket: 'flutter-journal-ea1b4.appspot.com',
    measurementId: 'G-T5FKZ1MRES',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDezK3k2iCIs2bSODyU7ukw3G5vFN7qapk',
    appId: '1:630854078610:android:3184258e6ab64553aa164b',
    messagingSenderId: '630854078610',
    projectId: 'flutter-journal-ea1b4',
    storageBucket: 'flutter-journal-ea1b4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDh3y8V7msVVlPDMUaWzTuhHFTp96-GwEg',
    appId: '1:630854078610:ios:a5a2bba089d2195daa164b',
    messagingSenderId: '630854078610',
    projectId: 'flutter-journal-ea1b4',
    storageBucket: 'flutter-journal-ea1b4.appspot.com',
    iosBundleId: 'com.example.flutterJournal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDh3y8V7msVVlPDMUaWzTuhHFTp96-GwEg',
    appId: '1:630854078610:ios:f7d4e3731a7c865faa164b',
    messagingSenderId: '630854078610',
    projectId: 'flutter-journal-ea1b4',
    storageBucket: 'flutter-journal-ea1b4.appspot.com',
    iosBundleId: 'com.example.flutterJournal.RunnerTests',
  );
}
