import 'package:flutter/material.dart';
import 'package:flutter_application_crud_mvvm/modules/sample_item.dart';
import 'package:flutter_application_crud_mvvm/screens/sample_item_detail.dart';
import 'package:flutter_application_crud_mvvm/provider/sample_item_view_model.dart';
import 'package:flutter_application_crud_mvvm/components/sample_item_widget.dart';

class SearchDel extends SearchDelegate {
  final viewModel = SampleItemViewModel();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchList(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchList(query);
  }

  // Hiển thị kết qủa tìm kiếm
  Widget _buildSearchList(String query) {
    List<String> listSearch = [];

    for (int i = 0; i < viewModel.items.length; i++) {
      if (i > 1) {
        break;
      }
      listSearch.add(viewModel.items[i].name);
    }
    List<SampleItem> matchQuery = [];
    for (var itemName in listSearch) {
      if (itemName.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.addAll(viewModel.items.where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase())));
        break;
      }
    }
    // Nếu thanh Search rỗng thì hiển thị gợi ý tên 1 vài item
    return query.isEmpty
        ? ListView.builder(
            itemCount: listSearch.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(listSearch[index]),
              );
            },
          )
        // Hiển thị kết quả tìm được
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              final item = matchQuery[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: SampleItemWidget(
                  key: ValueKey(item.id),
                  item: item,
                  onTap: () {
                    Navigator.pop(context);
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
            });
  }
}
