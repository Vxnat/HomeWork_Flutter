import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_real_time_chat_easy/auth/auth_gate.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyC36ly6FJsNWbkmCHYGkUW3l5dgm-KWdwo',
          appId: '287134087059:android:3494bd715ff7202226da66',
          messagingSenderId: '287134087059',
          projectId: 'realtime-chat-simple'));
  runApp(const MaterialApp(home: AuthGate(),debugShowCheckedModeBanner: false,));
}