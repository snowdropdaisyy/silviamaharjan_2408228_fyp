import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web is not supported for this project.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCShGSvGy9eZhF1VYdKteMujnxlVmF-w7U', // from api_key.current_key
    appId: '1:947080104879:android:d52516d723af8433ba3d5a', // from mobilesdk_app_id
    messagingSenderId: '947080104879', // from project_number
    projectId: 'silvia-2408228-fyp', // from project_id
  );
}
