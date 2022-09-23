import 'dart:developer';

import 'package:chat_app/services/app_firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked_annotations.dart';

import '../app/locator.dart';

@lazySingleton
class AuthService {
  final fService = locator<AppFirebaseService>();

  final _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;

  Future<bool> isUserLoggedIn() async {
    if (_auth.currentUser == null) {
      return false;
    } else {
      await _auth.signOut();
      return false;
    }
    // return true;
  }

  Future<void> signInUser(String email, String pass) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      throw (e.message.toString());
    }
  }

  Future<void> signUpUser(String email, String pass) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      await fService.setupNewUser(user!.uid, email);
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      throw (e.message.toString());
    }
  }
}
