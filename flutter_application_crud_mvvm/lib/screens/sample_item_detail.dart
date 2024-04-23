import 'package:flutter/material.dart';
import 'package:flutter_application_crud_mvvm/modules/sample_item.dart';
import 'package:flutter_application_crud_mvvm/components/sample_item_update.dart';
import 'package:flutter_application_crud_mvvm/provider/sample_item_view_model.dart';

// ignore: must_be_immutable
class SampleItemDetail extends StatefulWidget {
  SampleItem item;
  SampleItemDetail({
    super.key,
    required this.item,
  });

  @override
  State<SampleItemDetail> createState() => _SampleItemDetailState();
}

class _SampleItemDetailState extends State<SampleItemDetail> {
  final viewModel = SampleItemViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 236, 233, 253),
        title: const Text(
          'Item Detail',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet<List<String>?>(
                    context: context,
                    builder: (context) => SampleItemUpdate(
                          initialName: widget.item.name.value,
                          initialDescription: widget.item.description.value,
                        )).then((List<String>? value) {
                  if (value != null) {
                    // print('${value[0]} ${value[1]}');
                    viewModel.updateItem(widget.item.id, value[0], value[1]);
                  }
                });
              },
              icon: const Icon(Icons.edit, color: Colors.blue)),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text(
                          'Are you sure you want to delete this item?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                ).then((confirmed) {
                  if (confirmed) {
                    Navigator.of(context).pop(true);
                  }
                });
              },
              icon: const Icon(Icons.delete, color: Colors.red)),
        ],
      ),
      // Bọc 2 ValueListenableBuilder để có thể nhận về 2 giá trị Key đã thay đổi
      // Chưa tìm ra cách tối ưu hơn
      body: ValueListenableBuilder<String>(
        valueListenable: widget.item.name,
        builder: (context, name, child) {
          return ValueListenableBuilder<String>(
            valueListenable: widget.item.description,
            builder: (context, description, child) {
              return Container(
                color: const Color.fromARGB(255, 236, 233, 253),
                child: Column(
                  children: [
                    Image.asset(widget.item.imgItem, fit: BoxFit.fitWidth),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            'Name: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(widget.item.date)
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Text(
                            'Description: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            description,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 88, 88, 88),
                                fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
