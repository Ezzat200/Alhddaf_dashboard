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
    apiKey: 'AIzaSyDakqaPHr9MTMgv05p1mIr8jCtbGwWOguI',
    appId: '1:730829734986:web:18204c938f3e4232a452b3',
    messagingSenderId: '730829734986',
    projectId: 'alhadaf-a3fa2',
    authDomain: 'alhadaf-a3fa2.firebaseapp.com',
    databaseURL: 'https://alhadaf-a3fa2-default-rtdb.firebaseio.com',
    storageBucket: 'alhadaf-a3fa2.appspot.com',
    measurementId: 'G-J0JXT6SXM4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDuZYMfaKN9ZvLre-xFbD4HrTHw9GuRPY',
    appId: '1:730829734986:android:bfd1032b2d52159aa452b3',
    messagingSenderId: '730829734986',
    projectId: 'alhadaf-a3fa2',
    databaseURL: 'https://alhadaf-a3fa2-default-rtdb.firebaseio.com',
    storageBucket: 'alhadaf-a3fa2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtzswRP8v7bg9iGskiZdJ0LDY_8YYgtd8',
    appId: '1:730829734986:ios:6ca8d31ed8a3ac65a452b3',
    messagingSenderId: '730829734986',
    projectId: 'alhadaf-a3fa2',
    databaseURL: 'https://alhadaf-a3fa2-default-rtdb.firebaseio.com',
    storageBucket: 'alhadaf-a3fa2.appspot.com',
    androidClientId: '730829734986-b4kc24gjeo0p6vf53mmrnt0c84kj28f2.apps.googleusercontent.com',
    iosBundleId: 'com.example.admin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtzswRP8v7bg9iGskiZdJ0LDY_8YYgtd8',
    appId: '1:730829734986:ios:6ca8d31ed8a3ac65a452b3',
    messagingSenderId: '730829734986',
    projectId: 'alhadaf-a3fa2',
    databaseURL: 'https://alhadaf-a3fa2-default-rtdb.firebaseio.com',
    storageBucket: 'alhadaf-a3fa2.appspot.com',
    androidClientId: '730829734986-b4kc24gjeo0p6vf53mmrnt0c84kj28f2.apps.googleusercontent.com',
    iosBundleId: 'com.example.admin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD9M5jZioAQRugLDKRnIL9DOvuplAZjl2A',
    appId: '1:730829734986:web:bf9463838d601e13a452b3',
    messagingSenderId: '730829734986',
    projectId: 'alhadaf-a3fa2',
    authDomain: 'alhadaf-a3fa2.firebaseapp.com',
    databaseURL: 'https://alhadaf-a3fa2-default-rtdb.firebaseio.com',
    storageBucket: 'alhadaf-a3fa2.appspot.com',
    measurementId: 'G-WM0KELYR28',
  );
}
