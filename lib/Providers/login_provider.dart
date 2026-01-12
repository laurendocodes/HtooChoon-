import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// ---------------- LOGIN ----------------
  Future<void> login({required String email, required String password}) async {
    try {
      _setLoading(true);
      _setError(null);

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError("Something went wrong");
    } finally {
      _setLoading(false);
    }
  }

  /// ---------------- REGISTER ----------------
  Future<void> register({
    required String email,
    required String password,
    required String role, // "volunteer" or "user"
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await _firestore.collection("users").doc(cred.user!.uid).set({
        "email": email.trim(),
        "role": role,
        "createdAt": FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError("Something went wrong");
    } finally {
      _setLoading(false);
    }
  }

  /// ---------------- FETCH USER DOC ----------------
  Future<DocumentSnapshot> fetchUserDocument(String uid) {
    return _firestore.collection("users").doc(uid).get();
  }

  /// ---------------- LOGOUT ----------------
  Future<void> logout() async {
    await _auth.signOut();
  }
}
