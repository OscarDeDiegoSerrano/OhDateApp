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
    apiKey: 'AIzaSyBDJf084K8sk28cZfhMM58lKbI-Q7reQro',
    appId: '1:66605947614:web:e6cb6ec12a12118c97004f',
    messagingSenderId: '66605947614',
    projectId: 'ohdate-428ef',
    authDomain: 'ohdate-428ef.firebaseapp.com',
    storageBucket: 'ohdate-428ef.appspot.com',
    measurementId: 'G-KEVDB71246',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSHAIjXGIcUBp775jYaCH-zyYt1Dz21Og',
    appId: '1:66605947614:android:f4bb6629fa216acb97004f',
    messagingSenderId: '66605947614',
    projectId: 'ohdate-428ef',
    storageBucket: 'ohdate-428ef.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCeLoel48iGRnBYFogvSfL35bJj77D_DEI',
    appId: '1:66605947614:ios:b71fed6ba3adbfe697004f',
    messagingSenderId: '66605947614',
    projectId: 'ohdate-428ef',
    storageBucket: 'ohdate-428ef.appspot.com',
    iosBundleId: 'com.example.ohdateApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCeLoel48iGRnBYFogvSfL35bJj77D_DEI',
    appId: '1:66605947614:ios:32c348ba7d35c3ad97004f',
    messagingSenderId: '66605947614',
    projectId: 'ohdate-428ef',
    storageBucket: 'ohdate-428ef.appspot.com',
    iosBundleId: 'com.example.ohdateApp.RunnerTests',
  );
}
