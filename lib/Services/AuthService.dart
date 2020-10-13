import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User user;

  Future<String> signIn(String email, String password) async {
    try {
      user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
    } catch (e) {
      print('Error: Giriş işleminde Hata!: $e');
    }
    return user?.uid;
  }

  Future<String> signUp(String email, String password) async {
    user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  void signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    return user.emailVerified;
  }

  Future<String> getUserEmail() async {
    return user.email;
  }

  Future<String> getUserUid() async {
    return user?.uid;
  }

  Future<bool> checkPassword(String email, String password) async {
    String userId;
    try {
      userId = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user
          .uid;
    } catch (e) {
      return false;
    }
    if (userId != null) {
      //print("UserId: " + userId);
      return true;
    } else
      return false;
  }

  void sendPasswordResetEmail(String email) {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }
}
