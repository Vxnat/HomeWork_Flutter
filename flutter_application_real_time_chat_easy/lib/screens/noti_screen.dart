import 'package:flutter/material.dart';
import 'package:flutter_application_real_time_chat_easy/api/api.dart';
import 'package:flutter_application_real_time_chat_easy/modules/noti.dart';

class NotiScreen extends StatefulWidget {
  const NotiScreen({super.key});

  @override
  State<NotiScreen> createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noti'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        // Lay Tat Ca Du Lieu Noti Cua Minh
        stream: Api.getSelfNoti(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.docs;
            final list = data.map((e) => Noti.fromJson(e.data())).toList();
            final addFriendList = list
                .where((element) =>
                    element.receiverID == Api.user.uid &&
                    element.kindOfNoti == typeNoti.addFriend.toString())
                .toList();
            return addFriendList.isNotEmpty
                ? ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = addFriendList[index];
                      return StreamBuilder(
                        // Lay ra du lieu cua nguoi gui thong bao ket qua
                        stream: Api.getAnotherUser(item.senderID),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Error');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasData) {
                            // Du lieu nguoi gui
                            final dataUser = snapshot.data!.docs.first;
                            if (list.isNotEmpty) {
                              // final itemNoti = list.firstWhere((element) =>
                              // element.receiverID == Api.user.uid &&
                              //     element.kindOfNoti ==
                              //     typeNoti.addFriend.toString());
                              return Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 35,
                                    backgroundImage:
                                        AssetImage('/img/logo.png'),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(dataUser['name']),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(dataUser['email']),
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Api.addToListFriend(
                                                    item.receiverID,
                                                    item.senderID);
                                                Api.deleteNotiAddFriend(
                                                    item.senderID,
                                                    item.receiverID);
                                              },
                                              child: const Text(
                                                  'Chap nhan loi moi ket ban')),
                                          ElevatedButton(
                                              onPressed: () {
                                                Api.deleteNotiAddFriend(
                                                    item.senderID,
                                                    item.receiverID);
                                              },
                                              child: const Text(
                                                  'Xoa loi moi ket ban'))
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              );
                            }
                            return Container(child: Text(dataUser['name']));
                          }
                          return Container();
                        },
                      );
                    },
                  )
                : Container();
          }
          return Container();
        },
      ),
    );
  }
}
