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
    apiKey: 'AIzaSyCcpRdnVVaLIePGJZSfbqHv4ADQyNgkWO8',
    appId: '1:894082371447:web:3441cec90fa924fab85b72',
    messagingSenderId: '894082371447',
    projectId: 'stop-smoking-3f50b',
    authDomain: 'stop-smoking-3f50b.firebaseapp.com',
    storageBucket: 'stop-smoking-3f50b.firebasestorage.app',
    measurementId: 'G-X1JFQBCMZ4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBiFaV1DOUWAeywENpjKGn42FjIYP9tcO4',
    appId: '1:894082371447:android:ca18c254dbcecd1db85b72',
    messagingSenderId: '894082371447',
    projectId: 'stop-smoking-3f50b',
    storageBucket: 'stop-smoking-3f50b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJufcTh2Anl6bgBdTvP0zWxRiiTgKIrvE',
    appId: '1:894082371447:ios:cf9af28132fbcc30b85b72',
    messagingSenderId: '894082371447',
    projectId: 'stop-smoking-3f50b',
    storageBucket: 'stop-smoking-3f50b.firebasestorage.app',
    iosBundleId: 'com.example.stopSmoke',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCJufcTh2Anl6bgBdTvP0zWxRiiTgKIrvE',
    appId: '1:894082371447:ios:cf9af28132fbcc30b85b72',
    messagingSenderId: '894082371447',
    projectId: 'stop-smoking-3f50b',
    storageBucket: 'stop-smoking-3f50b.firebasestorage.app',
    iosBundleId: 'com.example.stopSmoke',
  );
}