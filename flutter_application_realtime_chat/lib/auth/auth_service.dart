import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User get user => auth.currentUser!;
  Future<UserCredential> signInWithEmailPasword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<bool> isEmailTaken(String email) async {
    try {
      // Truy vấn Firestore để kiểm tra xem email đã được sử dụng hay chưa
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .get();

      // Nếu có tài liệu trả về từ truy vấn, email đã tồn tại
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'id': user.uid,
        'name': email.split('@')[0],
        'create_at': '',
        'email': email,
        'about': 'Empty bio',
        'image':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSf3BIf6JrzgRhjWjvDPa8_XWjwZaEqqy1DELvkHJ0tlg&s',
        'push_token': '',
        'is_online': false,
        'last_active': '',
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await auth.signOut();
  }
}
