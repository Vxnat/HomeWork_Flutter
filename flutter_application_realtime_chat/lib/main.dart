import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_realtime_chat/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyA9k4DKMHMZSohONHDp-Sv2RN-Yp3-ARTQ',
          appId: '1:516933343359:android:d90cfd2f5c558f8cf9074a',
          messagingSenderId: '516933343359',
          projectId: 'wechat-44051'));
  runApp(const MaterialApp(
    home: AuthGate(),
    debugShowCheckedModeBanner: false,
  ));
}
