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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBHSGcBJMKqmXXYU8-MA2kXH69hP_5XFcs',
    appId: '1:791555468209:web:70a7b4bfa4d0520653ab90',
    messagingSenderId: '791555468209',
    projectId: 'mysnap-0',
    authDomain: 'mysnap-0.firebaseapp.com',
    storageBucket: 'mysnap-0.appspot.com',
    measurementId: 'G-XTPFG3EQM6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDcIj-TNJwtYBBYKpSUUGz7nnL6aiHKuRc',
    appId: '1:791555468209:android:e3b141ac5b0bc07b53ab90',
    messagingSenderId: '791555468209',
    projectId: 'mysnap-0',
    storageBucket: 'mysnap-0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVlKb1Jsfx3kQcvMTpm59q9IEodvc2nqM',
    appId: '1:791555468209:ios:7f33df9e10394f0653ab90',
    messagingSenderId: '791555468209',
    projectId: 'mysnap-0',
    storageBucket: 'mysnap-0.appspot.com',
    iosBundleId: 'com.mysnap.mysnap',
  );
}