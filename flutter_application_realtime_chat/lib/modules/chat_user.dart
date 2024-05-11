class ChatUser {
  ChatUser({
    required this.id,
    required this.name,
    required this.createAt,
    required this.email,
    required this.about,
    required this.image,
    required this.pushToken,
    required this.isOnline,
    required this.lastActive,
  });
  late String name;
  late final String id;
  late final String createAt;
  late final String email;
  late String about;
  late String image;
  late String pushToken;
  late bool isOnline;
  late String lastActive;

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    createAt = json['create_at'] ?? '';
    email = json['email'] ?? '';
    about = json['about'] ?? '';
    image = json['image'] ?? '';
    pushToken = json['push_token'] ?? '';
    isOnline = json['is_online'] ?? '';
    lastActive = json['last_active'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['create_at'] = createAt;
    data['email'] = email;
    data['about'] = about;
    data['image'] = image;
    data['push_token'] = pushToken;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    return data;
  }
}
