import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {

  static FirebaseOptions? get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android;
      case TargetPlatform.iOS:
        return null;
      case TargetPlatform.macOS:
        return null;
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

   static FirebaseOptions get _android {
    return const FirebaseOptions(
      apiKey: 'AIzaSyApCvyoHH7Kh70b31KhlVO7ZjecEOus5Ww',
      appId: '1:217680825989:android:88b63bd0d3393a40f0e3ec',
      messagingSenderId: '217680825989',
      projectId: 'gail-b0233',
      storageBucket: 'gail-b0233.appspot.com',
    );
  }

}