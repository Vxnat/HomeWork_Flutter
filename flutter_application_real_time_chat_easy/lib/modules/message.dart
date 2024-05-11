// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timeStamp;
  Message({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.message,
    required this.timeStamp,
  });

 Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sender_id'] = senderID;
    data['sender_email'] = senderEmail;
    data['receiver_id'] = receiverID;
    data['message'] = message;
    data['time_stamp'] = timeStamp;
    return data;
  } 
}
