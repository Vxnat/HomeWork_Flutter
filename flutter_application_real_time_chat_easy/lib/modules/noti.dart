// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Noti {
  late String senderID;
  late String receiverID;
  late Timestamp timeStamp;
  late String kindOfNoti;

  Noti(
      {required this.senderID,
      required this.receiverID,
      required this.timeStamp,
      required this.kindOfNoti});

  Noti.fromJson(Map<String, dynamic> json) {
    senderID = json['sender_id'];
    receiverID = json['receiver_id'];
    timeStamp = json['time_stamp'];
    kindOfNoti = json['kind_of_noti'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sender_id'] = senderID;
    data['receiver_id'] = receiverID;
    data['time_stamp'] = timeStamp;
    data['kind_of_noti'] = kindOfNoti;
    return data;
  }
}

enum typeNoti { addFriend }
