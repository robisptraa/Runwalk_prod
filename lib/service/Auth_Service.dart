import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:track_lari/pages/dashboard_page.dart';
import 'package:track_lari/pages/login_page.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> register({
    required String email,
    required String password,
    required String nama,
    required BuildContext context,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _fireStore.collection('users').doc(credential.user!.uid).set({
        'nama': nama,
        'email': email,
        'uid': credential.user!.uid,
      });

      Fluttertoast.showToast(msg: 'Akun berhasil dibuat!');

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } on FirebaseAuthException catch (e) {
      String pesan = '';
      if (e.code == 'weak-password') {
        pesan = 'meuni lemah pw teh';
      } else if (e.code == 'email-already-in-use') {
        pesan = 'geus di pake emailna blog';
      } else {
        pesan = 'lu yang bener napa';
      }
      Fluttertoast.showToast(
        msg: pesan,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {}
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Fluttertoast.showToast(msg: 'login berhasill anjay!');
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashboardPage()));
    } on FirebaseAuthException catch (e) {
      String pesan = '';
      if (e.code == 'user-not-found') {
        pesan = 'user teu kapanggih';
      } else if (e.code == 'wrong-password') {
        pesan = 'password salah blog';
      } else if (e.code == 'invalid-email') {
        pesan = 'email teu baleg blog.';
      } else if (e.code == 'user-disabled') {
        pesan = 'Akun dinonaktifkan buahaha.';
      } else {
        pesan = 'aya nu salah ma pren.';
      }
      Fluttertoast.showToast(
        msg: pesan,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {}
  }

  Future<void> keluar() async {
    await _auth.signOut();
  }
}
