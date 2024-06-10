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
    apiKey: 'AIzaSyDEWdAakzKO2cJM3k4JGjh10-95E7N1bhs',
    appId: '1:647027698856:web:00305f9b4073d4dcc2a69d',
    messagingSenderId: '647027698856',
    projectId: 'sppkita-731a3',
    authDomain: 'sppkita-731a3.firebaseapp.com',
    storageBucket: 'sppkita-731a3.appspot.com',
    measurementId: 'G-EYVP49ZPCH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDcbTNpdGiiQ1aBreVUApX5cEVCQu5NANs',
    appId: '1:647027698856:android:986128430318227cc2a69d',
    messagingSenderId: '647027698856',
    projectId: 'sppkita-731a3',
    storageBucket: 'sppkita-731a3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDfTcbmHNSpa--i9WOI1c5j5_SFVSwxML8',
    appId: '1:647027698856:ios:0c10b69d7c360424c2a69d',
    messagingSenderId: '647027698856',
    projectId: 'sppkita-731a3',
    storageBucket: 'sppkita-731a3.appspot.com',
    iosBundleId: 'com.example.cobaSpp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDfTcbmHNSpa--i9WOI1c5j5_SFVSwxML8',
    appId: '1:647027698856:ios:06b8ee2354f69ab3c2a69d',
    messagingSenderId: '647027698856',
    projectId: 'sppkita-731a3',
    storageBucket: 'sppkita-731a3.appspot.com',
    iosBundleId: 'com.example.cobaSpp.RunnerTests',
  );
}
