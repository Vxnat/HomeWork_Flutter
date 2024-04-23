import 'package:flutter/material.dart';
import 'package:flutter_application_crud_mvvm/screens/sample_item_detail.dart';
import 'package:flutter_application_crud_mvvm/components/sample_item_update.dart';
import 'package:flutter_application_crud_mvvm/provider/sample_item_view_model.dart';
import 'package:flutter_application_crud_mvvm/components/sample_item_widget.dart';
import 'package:flutter_application_crud_mvvm/components/search_delegate.dart';

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({Key? key}) : super(key: key);

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
    viewModel.loadDataLocal();
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
                const PopupMenuItem<String>(
                  value: 'Name',
                  child: Text('Bảng Chữ Cái'),
                ),
              ],
              // Xử lý khi một mục được chọn từ PopupMenu
              onSelected: (String value) {
                if (value == 'Date') {
                  isChangeDate = !isChangeDate;
                  viewModel.sortDate(isChangeDate);
                  isChangeName = false;
                } else {
                  isChangeName = !isChangeName;
                  viewModel.sortName(isChangeName);
                  isChangeDate = false;
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
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return ListView.builder(
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SampleItemWidget(
                    key: ValueKey(item.id),
                    item: item,
                    onTap: () {
                      Navigator.of(context)
                          .push<bool>(MaterialPageRoute(
                        builder: (context) => SampleItemDetail(item: item),
                      ))
                          .then((deleted) {
                        if (deleted ?? false) {
                          viewModel.removeItem(item.id);
                        }
                      });
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
