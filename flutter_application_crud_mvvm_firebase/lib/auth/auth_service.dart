import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_crud_mvvm/modules/sample_item.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  User get user => auth.currentUser!;

  // Lay Du Lieu Tat Ca Item
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllSampleItem() {
    return firestore.collection('samples').snapshots();
  }

  // Lay Du Lieu Sap Xep Theo Ngay Thang
  static Stream<QuerySnapshot<Map<String, dynamic>>> getReserveSampleItem() {
    return firestore
        .collection('samples')
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Lay Du Lieu 1 Item , Dung Cho Item Detail
  static Stream<QuerySnapshot<Map<String, dynamic>>> getSampleItem(String id) {
    return firestore
        .collection('samples')
        .where('id', isEqualTo: id)
        .limit(1)
        .snapshots();
  }

  // Them Item Moi
  Future<void> addNewItem(SampleItem sampleItem) async {
    final jsonItem = sampleItem.toJson();
    final ref = firestore.collection('samples');
    await ref.doc().set(jsonItem);
  }

  // Cap Nhat Name Hoac Description
  Future<void> updateItem(String id, String name, String description) async {
    try {
      final querySnapshot = await firestore
          .collection('samples')
          .where('id', isEqualTo: id)
          .limit(1)
          .get();
      final documentSnapshot = querySnapshot.docs.first;
      await documentSnapshot.reference
          .update({'name': name, 'description': description});
    } catch (e) {
      rethrow;
    }
  }

  // Xoa Item
  Future<void> deleteItem(String id) async {
    try {
      final querySnapshot = await firestore
          .collection('samples')
          .where('id', isEqualTo: id)
          .limit(1)
          .get();
      final documentSnapshot = querySnapshot.docs.first;
      await documentSnapshot.reference.delete();
    } catch (e) {
      rethrow;
    }
  }
}
