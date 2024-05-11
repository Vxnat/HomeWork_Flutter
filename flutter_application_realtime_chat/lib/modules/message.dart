class Message {
  Message({
    required this.toId,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sent,
  });
  late final String read;
  late final Type type;
  late final String sent;
  late final String fromId;
  late final String msg;
  late final String toId;

  Message.fromJson(Map<String, dynamic> json) {
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
    fromId = json['fromId'].toString();
    msg = json['msg'].toString();
    toId = json['told'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['read'] = read;
    data['type'] = type.name;
    data['sent'] = sent;
    data['fromId'] = fromId;
    data['msg'] = msg;
    data['told'] = toId;
    return data;
  }
}

enum Type { text, image }
