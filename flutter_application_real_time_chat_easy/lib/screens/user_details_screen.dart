import 'package:flutter/material.dart';
import 'package:flutter_application_real_time_chat_easy/api/api.dart';
import 'package:flutter_application_real_time_chat_easy/modules/chat_user.dart';
import 'package:flutter_application_real_time_chat_easy/modules/noti.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, required this.chatUser});
  final ChatUser chatUser;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Details'),
          centerTitle: true,
        ),
        body: Container(
          height: mq.height * .13,
          width: mq.width,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 159, 14),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 35,
                backgroundImage: AssetImage('/img/logo.png'),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatUser.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                    stream: Api.getSelfNoti(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!.docs;
                        final list =
                            data.map((e) => Noti.fromJson(e.data())).toList();
                        if (list.isNotEmpty) {
                          final item = list.firstWhere((element) =>
                              element.receiverID == widget.chatUser.id &&
                              element.kindOfNoti ==
                                  typeNoti.addFriend.toString());
                          if (item.receiverID == widget.chatUser.id &&
                              item.kindOfNoti ==
                                  typeNoti.addFriend.toString()) {
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    minimumSize: const Size(40, 45),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () {
                                  Api.deleteNotiAddFriend(
                                      Api.user.uid, widget.chatUser.id);
                                },
                                child: const Text(
                                  'Xoa loi moi ket ban',
                                  style: TextStyle(color: Colors.white),
                                ));
                          }
                        }
                        return StreamBuilder(
                          stream: Api.getMyInfo(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data!.docs;
                              final myUser = data
                                  .map((e) => ChatUser.fromJson(e.data()))
                                  .toList()[0];
                              return myUser.listFriends
                                      .contains(widget.chatUser.id)
                                  ? Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.blueAccent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Text(
                                            'Ban be',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                minimumSize: Size(40, 45),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10))),
                                            onPressed: () {
                                              Api.removeFromListFriend(
                                                  Api.me.id,
                                                  widget.chatUser.id);
                                            },
                                            child: const Text(
                                              'Xoa ban be',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))
                                      ],
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          minimumSize: Size(40, 45),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      onPressed: () {
                                        Api.sendNotiAddFriend(
                                            Api.me.id, widget.chatUser.id);
                                      },
                                      child: const Text(
                                        'Add Friend',
                                        style: TextStyle(color: Colors.white),
                                      ));
                            }
                            return Container();
                          },
                        );
                      }
                      return Container();
                    },
                  )
                ],
              )
            ],
          ),
        ));
  }
}
