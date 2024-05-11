import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_real_time_chat_easy/api/api.dart';
import 'package:flutter_application_real_time_chat_easy/auth/auth_service.dart';
import 'package:flutter_application_real_time_chat_easy/components/search_delegate.dart';
import 'package:flutter_application_real_time_chat_easy/components/user_cart.dart';
import 'package:flutter_application_real_time_chat_easy/modules/chat_user.dart';
import 'package:flutter_application_real_time_chat_easy/modules/noti.dart';
import 'package:flutter_application_real_time_chat_easy/screens/noti_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    Api.getSelfInfor();
    Api.updateActiveStatus(true);
    Api.updateLastActive();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains('resume')) {
        Api.updateActiveStatus(true);
      }
      if (message.toString().contains('pause')) {
        Api.updateActiveStatus(false);
      }
      return Future.value(message);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
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
              onPressed: () {
                authService.signOut();
                Api.updateActiveStatus(false);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.logout)),
          Stack(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotiScreen(),
                        ));
                  },
                  icon: const Icon(Icons.notifications)),
              Positioned(
                top: 0,
                right: 5,
                child: StreamBuilder(
                  stream: Api.getSelfNoti(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      final data = snapshot.data!.docs;
                      final list =
                          data.map((e) => Noti.fromJson(e.data())).toList();
                      int count = 0;
                      for (var i in list) {
                        if (i.receiverID == Api.user.uid) {
                          count++;
                        }
                      }
                      return count != 0
                          ? Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                count.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ))
                          : Container();
                    }
                    return Container();
                  },
                ),
              )
            ],
          )
        ],
      ),
      body: StreamBuilder(
        stream: Api.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          }
          if (snapshot.hasData) {
            // Data Users
            final data = snapshot.data!.docs;
            // List Users
            final list = data.map((e) => ChatUser.fromJson(e.data())).toList();
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return StreamBuilder(
                  stream: Api.getMyInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final myUser = snapshot.data!.docs;
                      final listMyData = myUser
                          .map((e) => ChatUser.fromJson(e.data()))
                          .toList();
                      final itemUser = listMyData[0];
                      return itemUser.listFriends.contains(item.id)
                          ? UserCard(chatUser: item)
                          : Container();
                    }
                    return const Center(
                      child: Text('No User!'),
                    );
                  },
                );
              },
            );
          }
          return const Center(
            child: Text('No User!'),
          );
        },
      ),
    );
  }
}
