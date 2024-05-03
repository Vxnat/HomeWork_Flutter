import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_crud_mvvm/screens/sample_item_list_view.dart';
import 'package:flutter_application_crud_mvvm/provider/sample_item_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDMSjduhnBD0OGgjoR6NT8vq84re5XbJ-Q',
          appId: '369547500770:android:2ceeb47cd294a6ae2192bb',
          messagingSenderId: '369547500770',
          projectId: 'sample-app-244b3'));
  runApp(ChangeNotifierProvider(
    create: (context) => SampleItemViewModel(),
    child: const MaterialApp(
      home: SampleItemListView(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
