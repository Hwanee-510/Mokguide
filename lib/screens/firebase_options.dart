import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {

  // 첫 번째 Firebase 앱 설정 (app1)
  static const FirebaseOptions app1 = FirebaseOptions(
    apiKey: 'AIzaSyBrqWYCnFbPoPUUsNonjXupoPTlJHQvsns',
    appId: '1:334119688715:android:79fa2d805ec3cb1522850e',
    messagingSenderId: '334119688715',
    projectId: 'capproject-96per',
    storageBucket: 'capproject-96per.appspot.com',
  );

  // 두 번째 Firebase 앱 설정 (app2)
  static const FirebaseOptions app2 = FirebaseOptions(
    apiKey: 'AIzaSyAZCLPzX216QksbjcXb3S47sSK3cRYAPI4',
    appId: '1:845748202878:android:e9b8a42e4c4aba0ceb172f',
    messagingSenderId: '845748202878',
    projectId: 'capstoned-mok',
    databaseURL: 'https://capstoned-mok-default-rtdb.firebaseio.com',
    storageBucket: 'capstoned-mok.firebasestorage.app',
  );

  // 첫 번째 Firebase 앱 - 웹 설정 (web)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBLDWF_RDWFc654FE5Q4gRjRsF9X-yNBW0',
    appId: '1:334119688715:web:00ffca6a49942ca822850e',
    messagingSenderId: '334119688715',
    projectId: 'capproject-96per',
    authDomain: 'capproject-96per.firebaseapp.com',
    storageBucket: 'capproject-96per.appspot.com',
    measurementId: 'G-RHH2RV7SBW',
  );

  // 두 번째 Firebase 앱 - 웹 설정 (web2)
  static const FirebaseOptions web2 = FirebaseOptions(
    apiKey: 'AIzaSyBCUsxQrNwjWhGYQd55oXz9jWWqXWrMv6M',
    appId: '1:845748202878:web:b4d40395180dafe1eb172f',
    messagingSenderId: '845748202878',
    projectId: 'capstoned-mok',
    authDomain: 'capstoned-mok.firebaseapp.com',
    databaseURL: 'https://capstoned-mok-default-rtdb.firebaseio.com',
    storageBucket: 'capstoned-mok.firebasestorage.app',
  );

  // 첫 번째 Firebase 앱 - 안드로이드 설정 (android)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrqWYCnFbPoPUUsNonjXupoPTlJHQvsns',
    appId: '1:334119688715:android:79fa2d805ec3cb1522850e',
    messagingSenderId: '334119688715',
    projectId: 'capproject-96per',
    storageBucket: 'capproject-96per.appspot.com',
  );

  // 두 번째 Firebase 앱 - 안드로이드 설정 (android2)
  static const FirebaseOptions android2 = FirebaseOptions(
    apiKey: 'AIzaSyAZCLPzX216QksbjcXb3S47sSK3cRYAPI4',
    appId: '1:845748202878:android:e9b8a42e4c4aba0ceb172f',
    messagingSenderId: '845748202878',
    projectId: 'capstoned-mok',
    databaseURL: 'https://capstoned-mok-default-rtdb.firebaseio.com',
    storageBucket: 'capstoned-mok.firebasestorage.app',
  );

  // 첫 번째 Firebase 앱 - iOS 설정 (ios)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCzdGRcGa4nucViF-lycc7XyfY17yHr0Ew',
    appId: '1:334119688715:ios:1a804c7364c396b022850e',
    messagingSenderId: '334119688715',
    projectId: 'capproject-96per',
    storageBucket: 'capproject-96per.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  // 두 번째 Firebase 앱 - iOS 설정 (ios2)
  static const FirebaseOptions ios2 = FirebaseOptions(
    apiKey: 'AIzaSyA3-sCLgmvHHFaHdEgPtH-HRL2c4qJBWiA',
    appId: '1:845748202878:ios:58437a1fa2e03247eb172f',
    messagingSenderId: '845748202878',
    projectId: 'capstoned-mok',
    databaseURL: 'https://capstoned-mok-default-rtdb.firebaseio.com',
    storageBucket: 'capstoned-mok.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  // macOS 설정 (기본적으로 iOS와 동일 설정 사용)
  static const FirebaseOptions macos = ios;

  // 두 번째 Firebase 앱 - macOS 설정 (macos2)
  static const FirebaseOptions macos2 = ios2;

  // Windows 설정
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBLDWF_RDWFc654FE5Q4gRjRsF9X-yNBW0',
    appId: '1:334119688715:web:da5d1ddf75ae481022850e',
    messagingSenderId: '334119688715',
    projectId: 'capproject-96per',
    authDomain: 'capproject-96per.firebaseapp.com',
    storageBucket: 'capproject-96per.appspot.com',
    measurementId: 'G-1375JRDX3T',
  );

  // 두 번째 Firebase 앱 - Windows 설정 (windows2)
  static const FirebaseOptions windows2 = FirebaseOptions(
    apiKey: 'AIzaSyBCUsxQrNwjWhGYQd55oXz9jWWqXWrMv6M',
    appId: '1:845748202878:web:12c6dbb707c98c30eb172f',
    messagingSenderId: '845748202878',
    projectId: 'capstoned-mok',
    authDomain: 'capstoned-mok.firebaseapp.com',
    databaseURL: 'https://capstoned-mok-default-rtdb.firebaseio.com',
    storageBucket: 'capstoned-mok.firebasestorage.app',
  );

  // currentPlatform 정의
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web; // 웹 설정 반환
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android; // 안드로이드 설정 반환
      case TargetPlatform.iOS:
        return ios; // iOS 설정 반환
      case TargetPlatform.macOS:
        return macos; // macOS 설정 반환
      case TargetPlatform.windows:
        return windows; // Windows 설정 반환
      default:
        throw UnsupportedError('Platform not supported');
    }
  }
}
