import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthViewModel() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  bool get isAuthenticated => _user != null;
  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Handling specific Firebase exceptions
      if (e.code == 'weak-password') {
        throw 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        throw 'The email address is not valid.';
      } else {
        throw 'Signup failed: ${e.message}';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }


  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
