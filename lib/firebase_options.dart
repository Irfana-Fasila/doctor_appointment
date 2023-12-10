// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyABlXRjQkU1_6FFbzGg1sKhYqbKaQu9iCg',
    appId: '1:889382802914:web:05a1065cec483c31f995bb',
    messagingSenderId: '889382802914',
    projectId: 'doctime-31db7',
    authDomain: 'doctime-31db7.firebaseapp.com',
    storageBucket: 'doctime-31db7.appspot.com',
    measurementId: 'G-T7TJ2ME6DE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbLkh98AJpKVAottBBxNoxX3CqaTSXytc',
    appId: '1:889382802914:android:db3b937c95d9c631f995bb',
    messagingSenderId: '889382802914',
    projectId: 'doctime-31db7',
    storageBucket: 'doctime-31db7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDT6SwNn7yJdcTGov9NXZZnEOoP6BiaTKU',
    appId: '1:889382802914:ios:ae42b747452b53eff995bb',
    messagingSenderId: '889382802914',
    projectId: 'doctime-31db7',
    storageBucket: 'doctime-31db7.appspot.com',
    iosClientId: '889382802914-feieqp2jiktu1cklqbiq248h23ji5cv9.apps.googleusercontent.com',
    iosBundleId: 'com.example.DocTime',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDT6SwNn7yJdcTGov9NXZZnEOoP6BiaTKU',
    appId: '1:889382802914:ios:ae42b747452b53eff995bb',
    messagingSenderId: '889382802914',
    projectId: 'doctime-31db7',
    storageBucket: 'doctime-31db7.appspot.com',
    iosClientId: '889382802914-feieqp2jiktu1cklqbiq248h23ji5cv9.apps.googleusercontent.com',
    iosBundleId: 'com.example.DocTime',
  );
}