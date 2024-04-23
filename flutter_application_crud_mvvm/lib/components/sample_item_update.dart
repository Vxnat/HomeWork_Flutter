// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SampleItemUpdate extends StatefulWidget {
  const SampleItemUpdate({
    super.key,
    this.initialName,
    this.initialDescription,
  });
  final String? initialName;
  final String? initialDescription;
  @override
  State<SampleItemUpdate> createState() => _SampleItemUpdateState();
}

class _SampleItemUpdateState extends State<SampleItemUpdate> {
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  late TextEditingController nameEditingController;
  late TextEditingController desEditingController;
  @override
  void initState() {
    super.initState();
    nameEditingController = TextEditingController(text: widget.initialName);
    desEditingController =
        TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    desEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.initialName != null ? 'Chỉnh sửa' : 'Thêm mới'),
          actions: [
            IconButton(
                onPressed: () {
                  if (formKey1.currentState!.validate() &&
                      formKey2.currentState!.validate()) {
                    Navigator.of(context).pop([
                      nameEditingController.text,
                      desEditingController.text
                    ]);
                  }
                },
                icon: const Icon(
                  Icons.save,
                  color: Colors.blue,
                ))
          ],
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Name: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: formKey1,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Require Field';
                    }
                    return null;
                  },
                  controller: nameEditingController,
                  decoration: InputDecoration(
                    hintText: 'name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent, // Màu viền
                        width: 1.0, // Độ dày của viền
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color:
                            Colors.blueAccent, // Màu viền khi trạng thái focus
                        width: 1.0, // Độ dày của viền khi trạng thái focus
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.red, // Màu viền khi có lỗi
                        width: 1.0, // Độ dày của viền khi có lỗi
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors
                            .red, // Màu viền khi có lỗi và trạng thái focus
                        width:
                            1.0, // Độ dày của viền khi có lỗi và trạng thái focus
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Description: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: formKey2,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Require Field';
                    }
                    return null;
                  },
                  controller: desEditingController,
                  decoration: InputDecoration(
                    hintText: 'description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent, // Màu viền
                        width: 1.0, // Độ dày của viền
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color:
                            Colors.blueAccent, // Màu viền khi trạng thái focus
                        width: 1.0, // Độ dày của viền khi trạng thái focus
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.red, // Màu viền khi có lỗi
                        width: 1.0, // Độ dày của viền khi có lỗi
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors
                            .red, // Màu viền khi có lỗi và trạng thái focus
                        width:
                            1.0, // Độ dày của viền khi có lỗi và trạng thái focus
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
