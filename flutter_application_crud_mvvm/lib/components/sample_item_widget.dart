// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_application_crud_mvvm/modules/sample_item.dart';

class SampleItemWidget extends StatelessWidget {
  const SampleItemWidget({
    Key? key,
    required this.item,
    this.onTap,
  }) : super(key: key);
  final SampleItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: item.name,
      builder: (context, name, child) {
        return ValueListenableBuilder<String>(
          valueListenable: item.description,
          builder: (context, value, child) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10),
              child: ListTile(
                hoverColor: Colors.white,
                onTap: onTap,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'img/ronaldo.jpg',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.date,
                      style: const TextStyle(fontSize: 13),
                    )
                  ],
                ),
                subtitle: Text(
                  item.description.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                // trailing: Container(
                //   width: 15,
                //   height: 15,
                //   decoration: BoxDecoration(
                //       color: Colors.greenAccent.shade400,
                //       borderRadius: BorderRadius.circular(10)),
                // )
              ),
            );
          },
        );
      },
    );
  }
}
