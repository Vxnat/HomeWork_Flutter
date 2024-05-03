import 'package:flutter/material.dart';
import 'package:flutter_application_crud_mvvm/auth/auth_service.dart';
import 'package:flutter_application_crud_mvvm/modules/sample_item.dart';
import 'package:flutter_application_crud_mvvm/screens/sample_item_detail.dart';
import 'package:flutter_application_crud_mvvm/components/sample_item_update.dart';
import 'package:flutter_application_crud_mvvm/provider/sample_item_view_model.dart';
import 'package:flutter_application_crud_mvvm/components/sample_item_widget.dart';
import 'package:flutter_application_crud_mvvm/components/search_delegate.dart';

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({super.key});

  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  TextEditingController nameController = TextEditingController();
  FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final viewModel = SampleItemViewModel();
  bool isChangeDate = false;
  bool isChangeName = false;

  @override
  void initState() {
    super.initState();
    // Load dữ liệu Local Storge thì vào ứng dụng
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 236, 233, 253),
        title: const Text(
          'Sample Item',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchDel());
              },
              icon: const Icon(
                Icons.search,
                color: Color.fromARGB(255, 116, 116, 116),
              )),
          IconButton(
            onPressed: () {},
            icon: PopupMenuButton<String>(
              icon: const Icon(
                Icons.filter_alt_sharp,
                color: Color.fromARGB(255, 116, 116, 116),
              ),
              tooltip: 'Sort',
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Date',
                  child: Text('Ngày khởi tạo'),
                ),
              ],
              // Xử lý khi một mục được chọn từ PopupMenu
              onSelected: (String value) {
                if (value == 'Date') {
                  isChangeDate = !isChangeDate;
                  isChangeName = false;
                  setState(() {});
                }
              },
              iconSize: 23,
            ),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet<List<String>?>(
                context: context,
                builder: (context) => const SampleItemUpdate(),
              ).then((List<String>? value) {
                if (value != null) {
                  viewModel.addItem(value[0], value[1]);
                }
              });
            },
            icon: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 116, 116, 116),
            ),
          )
        ],
      ),
      body: Container(
          color: const Color.fromARGB(255, 236, 233, 253),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          // Load dữ liệu từ list Items
          child: StreamBuilder(
            stream: isChangeDate
                ? AuthService.getReserveSampleItem()
                : AuthService.getAllSampleItem(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black54,
                    ),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    final data = snapshot.data?.docs;
                    final jsonList = data!
                        .map((e) => SampleItem.fromJson(e.data()))
                        .toList();
                    viewModel.items.addAll(jsonList);
                    return jsonList.isEmpty
                        ? const Center(
                            child: Text(
                            'No Item',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ))
                        :
                        // In ra danh sách các chuỗi JSON đã mã hóa
                        ListView.builder(
                            itemCount: jsonList.length,
                            itemBuilder: (context, index) {
                              final item = jsonList[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: SampleItemWidget(
                                  item: item,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push<bool>(MaterialPageRoute(
                                      builder: (context) =>
                                          SampleItemDetail(item: item),
                                    ))
                                        .then((value) {
                                      if (value ?? false) {
                                        viewModel.removeItem(item.id);
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          );
                  }
              }
              return Container();
            },
          )),
    );
  }
}
