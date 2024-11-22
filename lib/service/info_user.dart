import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InfoUser {
  Future<String?> infoMazzeh() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return null; // Tidak ada user yang login

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return doc['nama']; // Ambil nama user
    } catch (e) {
      print('Error: ${e.toString()}');
      return null;
    }
  }
}
