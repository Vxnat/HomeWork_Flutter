import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_crud_mvvm/auth/auth_service.dart';
import 'package:flutter_application_crud_mvvm/modules/sample_item.dart';

class SampleItemViewModel extends ChangeNotifier {
  static final SampleItemViewModel _instance = SampleItemViewModel._();
  factory SampleItemViewModel() => _instance;
  final AuthService authService = AuthService();
  SampleItemViewModel._();
  // Khởi tạo list Items
  List<SampleItem> items = [];

  List<SampleItem> filteredItems = [];

  // Thêm item vào list
  void addItem(String name, String description) {
    String id = generateUuid();
    final item = SampleItem(
        id: id,
        name: name,
        date: DateTime.now().millisecondsSinceEpoch.toString(),
        description: description,
        imgItem: 'img/ronaldo.jpg');
    authService.addNewItem(item);
  }

  // Xóa item khỏi list
  void removeItem(String id) {
    authService.deleteItem(id);
  }

  // Cập nhật item
  void updateItem(String id, String newName, String newDescription) {
    try {
      authService.updateItem(id, newName, newDescription);
    } catch (e) {
      debugPrint('Error id');
    }
  }

  // Tạo id ngẫu nhiên
  String generateUuid() {
    return int.parse(
            '${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(100000)}')
        .toRadixString(35)
        .substring(0, 9);
  }
}
