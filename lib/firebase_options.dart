import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Generated template and customizable for ToLate Bangladesh Property Marketplace.
/// Replace placeholder values with your Firebase Project configuration from the
/// Firebase Console (Project Settings -> General -> Your apps) or run `flutterfire configure`.
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
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Set to true once you have placed real credentials from your Firebase Console.
  static const bool isConfigured = false;

  // Web Firebase configuration
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDemoPlaceholderWebKey123456789',
    appId: '1:1234567890:web:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'tolate-bd',
    authDomain: 'tolate-bd.firebaseapp.com',
    storageBucket: 'tolate-bd.appspot.com',
  );

  // Android Firebase configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDemoPlaceholderAndroidKey123456',
    appId: '1:1234567890:android:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'tolate-bd',
    storageBucket: 'tolate-bd.appspot.com',
  );

  // iOS Firebase configuration
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDemoPlaceholderIosKey123456789',
    appId: '1:1234567890:ios:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'tolate-bd',
    storageBucket: 'tolate-bd.appspot.com',
    iosBundleId: 'com.tolate.marketplace.tolate',
  );

  // macOS Firebase configuration
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDemoPlaceholderIosKey123456789',
    appId: '1:1234567890:ios:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'tolate-bd',
    storageBucket: 'tolate-bd.appspot.com',
    iosBundleId: 'com.tolate.marketplace.tolate',
  );

  // Windows Firebase configuration
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDemoPlaceholderWebKey123456789',
    appId: '1:1234567890:web:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'tolate-bd',
    authDomain: 'tolate-bd.firebaseapp.com',
    storageBucket: 'tolate-bd.appspot.com',
  );
}

