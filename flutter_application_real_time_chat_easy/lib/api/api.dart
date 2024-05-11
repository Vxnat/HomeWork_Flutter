import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_real_time_chat_easy/modules/message.dart';
import 'package:flutter_application_real_time_chat_easy/modules/chat_user.dart';
import 'package:flutter_application_real_time_chat_easy/modules/noti.dart';

class Api {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;
  static late ChatUser me;

  // Get all User
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // Get all User
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyInfo() {
    return firestore
        .collection('users')
        .where('id', isEqualTo: user.uid)
        .limit(1)
        .snapshots();
  }

  // static Stream<QuerySnapshot<Map<String,dynamic>>> getNotiUser(){

  // }

  static Future<void> getSelfInfor() async {
    return await firestore
        .collection('users')
        .doc(user.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      }
    });
  }

  // Get another User
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAnotherUser(
      String anotherID) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: anotherID)
        .snapshots();
  }

  // Send Message
  static Future<void> sendMessage(String receiverID, String message) async {
    final String currentUserID = user.uid;
    final String currentUserEmail = user.email!;
    final Timestamp timeStamp = Timestamp.now();

    final newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timeStamp: timeStamp);

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toJson());
  }

  // Get message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      String userId, otherUserID) {
    List<String> ids = [userId, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('time_stamp', descending: false)
        .snapshots();
  }

  // Get last message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String userId, otherUserID) {
    List<String> ids = [userId, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('time_stamp', descending: true)
        .limit(1)
        .snapshots();
  }

  // Update Active Status
  static Future<void> updateActiveStatus(bool isActive) async {
    firestore.collection('users').doc(user.uid).update({'is_online': isActive});
  }

  // Update Last Active
  static Future<void> updateLastActive() async {
    final int lastActive = DateTime.now().millisecondsSinceEpoch;
    firestore
        .collection('users')
        .doc(user.uid)
        .update({'last_active': lastActive});
  }

  // Add To List Friend
  static Future<void> addToListFriend(String userId, String otherUserID) async {
    final userRef = firestore.collection('users').doc(user.uid);
    final otherUserRef = firestore.collection('users').doc(otherUserID);
    await userRef.update({
      'list_friends': FieldValue.arrayUnion([otherUserID])
    });
    await otherUserRef.update({
      'list_friends': FieldValue.arrayUnion([userId])
    });
  }

  // Remove From List Friend
  static Future<void> removeFromListFriend(
      String userId, String otherUserID) async {
    final userRef = firestore.collection('users').doc(user.uid);
    final otherUserRef = firestore.collection('users').doc(otherUserID);
    await userRef.update({
      'list_friends': FieldValue.arrayRemove([otherUserID])
    });
    await otherUserRef.update({
      'list_friends': FieldValue.arrayRemove([userId])
    });
  }

  // Send Noti Add Friend
  static Future<void> sendNotiAddFriend(
      String userId, String receiverID) async {
    final Timestamp timeStamp = Timestamp.now();
    final newInvite = Noti(
        senderID: userId,
        receiverID: receiverID,
        timeStamp: timeStamp,
        kindOfNoti: typeNoti.addFriend.toString());
    await firestore
        .collection('friend_invitation/$userId/noties/')
        .doc()
        .set(newInvite.toJson());
    await firestore
        .collection('friend_invitation/$receiverID/noties/')
        .doc()
        .set(newInvite.toJson());
  }

  // Delete Noti Add Friend
  static Future<void> deleteNotiAddFriend(
      String userId, String receiverID) async {
    final selfNotiRef =
        firestore.collection('friend_invitation/$userId/noties/');
    final anotherNotiRef =
        firestore.collection('friend_invitation/$receiverID/noties/');
    QuerySnapshot<Map<String, dynamic>> selfQuerySnapshot = await selfNotiRef
        .where('sender_id', isEqualTo: userId)
        .where('receiver_id', isEqualTo: receiverID)
        .where('kind_of_noti', isEqualTo: typeNoti.addFriend.toString())
        .get();
    QuerySnapshot<Map<String, dynamic>> anotherQuerySnapshot =
        await anotherNotiRef
            .where('sender_id', isEqualTo: userId)
            .where('receiver_id', isEqualTo: receiverID)
            .where('kind_of_noti', isEqualTo: typeNoti.addFriend.toString())
            .get();
    if (selfQuerySnapshot.docs.isNotEmpty) {
      final QueryDocumentSnapshot seflItemDoc = selfQuerySnapshot.docs.first;
      await selfNotiRef.doc(seflItemDoc.id).delete();
    }

    if (anotherQuerySnapshot.docs.isNotEmpty) {
      final QueryDocumentSnapshot anotherItemDoc =
          anotherQuerySnapshot.docs.first;
      await anotherNotiRef.doc(anotherItemDoc.id).delete();
    }
  }

  // Get noties
  static Stream<QuerySnapshot<Map<String, dynamic>>> getSelfNoti() {
    return firestore
        .collection('friend_invitation/${user.uid}/noties/')
        .snapshots();
  }
}
