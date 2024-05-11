// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatUser {
  late String id;
  late String name;
  late String email;
  late bool isOnlne;
  late int lastActive;
  late List<dynamic> listFriends;
  ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.isOnlne,
    required this.lastActive,
    required this.listFriends,
  });
  
  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    isOnlne = json['is_online'];
    lastActive = json['last_active'];
    listFriends = json['list_friends'];
  }
}
