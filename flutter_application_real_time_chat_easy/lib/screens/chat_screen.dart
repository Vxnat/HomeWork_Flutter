// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_real_time_chat_easy/api/api.dart';
import 'package:flutter_application_real_time_chat_easy/components/my_text_field.dart';
import 'package:flutter_application_real_time_chat_easy/date_extensions/date_format.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });
  final String receiverEmail;
  final String receiverID;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      Api.sendMessage(widget.receiverID, messageController.text);
      messageController.clear();
      // Khởi tạo ScrollController và cuộn xuống dòng cuối cùng
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                backgroundImage: AssetImage('/img/logo.png'),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.receiverEmail.split('@')[0],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  StreamBuilder(
                    stream: Api.getAnotherUser(widget.receiverID),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Error');
                      }
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        final data = snapshot.data!.docs.first;
                        String lastActive =
                            DateFormat.formatTimeAgo(data['last_active']);
                        return Text(
                          'Active ${lastActive}',
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(255, 71, 71, 71)),
                        );
                      }
                      return Container();
                    },
                  )
                ],
              ),
            ],
          ),
          backgroundColor: const Color.fromRGBO(255, 195, 116, 1),
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(255, 195, 116, 1)),
          child: Column(
            children: [
              Expanded(child: _buildMessageList()),
              const SizedBox(
                height: 15,
              ),
              _buildUserInput()
            ],
          ),
        ));
  }

  Widget _buildMessageList() {
    String senderID = Api.user.uid;
    return StreamBuilder(
      stream: Api.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }
        // Thực hiện cuộn xuống dòng cuối cùng trong setState
        if (snapshot.hasData) {
          final data = snapshot.data!.docs;
          return data.isNotEmpty
              ? ListView(
                  controller: _scrollController,
                  children: snapshot.data!.docs
                      .map((doc) => _buildMessageItem(doc))
                      .toList(),
                )
              : const Center(
                  child: Text(
                  'Say Hi 👋',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 120, 58)),
                ));
        }
        return Container();
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['sender_id'] == Api.user.uid;
    var mq = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(mq.width * .04),
              margin: EdgeInsets.symmetric(
                  horizontal: mq.width * .04, vertical: mq.height * .01),
              decoration: BoxDecoration(
                border: isCurrentUser
                    ? Border.all(color: const Color.fromARGB(255, 151, 255, 55))
                    : Border.all(
                        color: const Color.fromARGB(255, 170, 228, 255)),
                color: isCurrentUser
                    ? const Color.fromARGB(255, 172, 255, 179)
                    : const Color.fromARGB(255, 208, 234, 255),
                borderRadius: isCurrentUser
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30))
                    : const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(15)),
              ),
              child: Text(data['message']),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
            child: MyTextField(
                hintText: 'Type something ...',
                obscureText: false,
                controller: messageController)),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.orange, borderRadius: BorderRadius.circular(15)),
          child: IconButton(
              onPressed: () {
                sendMessage();
              },
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              )),
        )
      ],
    );
  }
}
