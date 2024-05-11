// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_application_real_time_chat_easy/api/api.dart';
import 'package:flutter_application_real_time_chat_easy/date_extensions/date_format.dart';
import 'package:flutter_application_real_time_chat_easy/modules/chat_user.dart';
import 'package:flutter_application_real_time_chat_easy/screens/chat_screen.dart';

class UserCard extends StatefulWidget {
  const UserCard({
    super.key,
    required this.chatUser,
  });
  final ChatUser chatUser;
  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiverEmail: widget.chatUser.email,
                receiverID: widget.chatUser.id,
              ),
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 159, 14),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      backgroundImage: AssetImage('/img/logo.png'),
                    ),
                    widget.chatUser.isOnlne
                        ? Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 13,
                              width: 13,
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 81, 187, 85),
                                  borderRadius: BorderRadius.circular(55)),
                            ),
                          )
                        : Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 13,
                              width: 13,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(55)),
                            ),
                          )
                  ],
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chatUser.name,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    StreamBuilder(
                      stream:
                          Api.getLastMessage(Api.user.uid, widget.chatUser.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Error');
                        }
                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          final data = snapshot.data!.docs.first;
                          final message = data['message'];
                          return SizedBox(
                              width: mq.width * .5,
                              child: Text(
                                message,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 99, 99, 99),
                                    fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ));
                        }
                        return const Text(
                          'Say Hi 👋',
                          style: TextStyle(fontSize: 12),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
            Text(
              DateFormat.formatTimeAgo(widget.chatUser.lastActive),
              style: const TextStyle(
                  color: Color.fromARGB(255, 56, 56, 56), fontSize: 11),
            )
          ],
        ),
      ),
    );
  }
}
