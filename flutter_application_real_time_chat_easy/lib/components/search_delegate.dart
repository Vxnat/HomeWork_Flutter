import 'package:flutter/material.dart';
import 'package:flutter_application_real_time_chat_easy/api/api.dart';
import 'package:flutter_application_real_time_chat_easy/modules/chat_user.dart';
import 'package:flutter_application_real_time_chat_easy/screens/user_details_screen.dart';

class SearchDel extends SearchDelegate {
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
    List<String> listSearch = ['user2'];
    // for (var itemName in listSearch) {
    //   if (itemName.toLowerCase().contains(query.toLowerCase())) {
    //     matchQuery.addAll(listChatUsers.where((element) =>
    //         element.name.toLowerCase().contains(query.toLowerCase())));
    //     break;
    //   }
    // }
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
        : StreamBuilder(
            stream: Api.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!.docs;
                final list =
                    data.map((e) => ChatUser.fromJson(e.data())).toList();
                return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      if (item.name.contains(query)) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserDetailsScreen(chatUser: item),
                                ));
                          },
                          child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 255, 159, 14),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Stack(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 25,
                                              backgroundImage:
                                                  AssetImage('/img/logo.png'),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        );
                      } else {
                        return Container();
                      }
                    });
              }
              return Container();
            });
  }
}
