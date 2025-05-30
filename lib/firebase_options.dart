import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRXtxjI7MrwSjG6VvexZpwddVlksnIqek',
    appId: '1:75682466586:android:6642614412a4e4b430baa3',
    messagingSenderId: '75682466586',
    projectId: 'kids-magazine-19cf6',
    storageBucket: 'kids-magazine-19cf6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBBuraeq2d7jdAtxs8AnD-dW1mzYbeRZT4',
    appId: '1:75682466586:ios:2d89e6579d5841fe30baa3',
    messagingSenderId: '75682466586',
    projectId: 'kids-magazine-19cf6',
    storageBucket: 'kids-magazine-19cf6.appspot.com',
    iosClientId:
        '75682466586-oqrh3mgtckjshjf0t5ilvfbblfvtlbvr.apps.googleusercontent.com',
    iosBundleId: 'com.example.kidsMagazine',
  );
}
