import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_crud_mvvm/modules/sample_item.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SampleItemViewModel extends ChangeNotifier {
  static final SampleItemViewModel _instance = SampleItemViewModel._();
  factory SampleItemViewModel() => _instance;

  SampleItemViewModel._();
  // Khởi tạo list Items
  List<SampleItem> items = [
    SampleItem(
        id: '1',
        name: 'Team Metting',
        date: '18/10/2003',
        description:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
        imgItem: 'img/ronaldo.jpg'),
    SampleItem(
        id: '2',
        name: 'Appointment',
        date: '15/7/2012',
        description:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
        imgItem: 'img/ronaldo.jpg'),
    SampleItem(
        id: '3',
        name: 'Email team for updates',
        date: '12/7/2009',
        description:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
        imgItem: 'img/ronaldo.jpg'),
    SampleItem(
        id: '4',
        name: 'Prepare investors pitch deck',
        date: '10/2/2008',
        description:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
        imgItem: 'img/ronaldo.jpg'),
  ];

  List<SampleItem> filteredItems = [];

  // Thêm item vào list
  void addItem(String name, String description) {
    String id = generateUuid();
    final bool item = items.any((element) => element.id == id);
    if (!item) {
      items.add(
        SampleItem(
            id: id,
            name: name,
            date: formatDate(DateTime.now()),
            description: description,
            imgItem: 'img/ronaldo.jpg'),
      );
      saveDataLocal();
      notifyListeners();
    }
  }

  // Xóa item khỏi list
  void removeItem(String id) {
    items.removeWhere((element) => element.id == id);
    saveDataLocal();
    notifyListeners();
  }

  // Cập nhật item
  void updateItem(String id, String newName, String newDescription) {
    try {
      final item = items.firstWhere((element) => element.id == id);
      item.name.value = newName;
      item.description.value = newDescription;
      saveDataLocal();
      notifyListeners();
    } catch (e) {
      debugPrint('Error id');
    }
  }

  // Sắp xếp item theo Ngày khởi tạo
  void sortDate(bool isChangeDate) {
    DateFormat format = DateFormat('dd/MM/yyyy');
    isChangeDate
        ? items.sort(
            (a, b) => format.parse(a.date).compareTo(format.parse(b.date)))
        : items.sort(
            (a, b) => format.parse(b.date).compareTo(format.parse(a.date)));
    notifyListeners();
  }

  // Sắp xếp item theo Bảng chữ cái
  void sortName(bool isChangeName) {
    isChangeName
        ? items.sort((a, b) => a.name.value.compareTo(b.name.value))
        : items.sort((a, b) => b.name.value.compareTo(a.name.value));
    notifyListeners();
  }

  // Load dữ liệu đã được lưu lại bên trong Local
  void loadDataLocal() async {
    final localData = await SharedPreferences.getInstance();
    List<String>? listItem = localData.getStringList('listItemLocal');
    if (listItem != null) {
      List<SampleItem> newListItem = listItem
          .map((itemString) => SampleItem.fromString(itemString))
          .toList();
      items.clear();
      items.addAll(newListItem);
    }

    notifyListeners();
  }

  // Save dữ liệu vào LocalData
  void saveDataLocal() async {
    final localData = await SharedPreferences.getInstance();
    List<String> listItemString = items.map((item) => item.toString()).toList();
    localData.setStringList('listItemLocal', listItemString);
  }

  // Tạo id ngẫu nhiên
  String generateUuid() {
    return int.parse(
            '${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(100000)}')
        .toRadixString(35)
        .substring(0, 9);
  }

  // Format Date về kiểu dd/MM/yyyy
  String formatDate(DateTime date) {
    // Tạo định dạng ngày mới
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    // Sử dụng định dạng để chuyển đổi DateTime thành chuỗi
    final String formattedDate = formatter.format(date);
    // Trả về chuỗi đã định dạng
    return formattedDate;
  }
}
