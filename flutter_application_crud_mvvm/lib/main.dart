import 'package:flutter/material.dart';
import 'package:flutter_application_crud_mvvm/screens/sample_item_list_view.dart';
import 'package:flutter_application_crud_mvvm/provider/sample_item_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => SampleItemViewModel(),
    child: const MaterialApp(
      home: SampleItemListView(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
