import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? user;
  AuthService() {
    user = _firebaseAuth.currentUser;
  }
  Future<String?> signIn(String email, String password) async {
    try {
      user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
    } catch (e) {
      if (kDebugMode) {
        print('Error: Giriş işleminde Hata!: $e');
      }
    }
    return user?.uid;
  }

  Future<String?> signUp(String email, String password) async {
    user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user?.uid;
  }

  void signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    await user?.sendEmailVerification();
  }

  Future<bool?> isEmailVerified() async {
    return user?.emailVerified;
  }

  Future<String?> getUserEmail() async {
    return user?.email;
  }

  Future<String?> getUserUid() async {
    return user?.uid;
  }

  /*Future<bool> checkPassword(String email, String password) async {
    String userId;
    try {
      userId = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user
          .uid;
      return true;
    } catch (e) {
      return false;
    }
    //print("UserId: " + userId);
    return true;
  }*/

  void sendPasswordResetEmail(String email) {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
