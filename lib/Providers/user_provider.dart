import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;

  /// Fetches the user document from Firestore and caches critical data.
  /// Should be called ONCE at app startup or after login.
  Future<void> fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _userData = null;
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        _userData = doc.data();
        await _cacheUserData(_userData!);
      } else {
        debugPrint("User document not found for ${user.uid}");
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Caches critical user data to SharedPreferences
  Future<void> _cacheUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', FirebaseAuth.instance.currentUser?.uid ?? '');
    if (data['plan'] != null) {
      await prefs.setString('userPlan', data['plan']);
    }
    await prefs.setString('userName', data['name'] ?? data['username'] ?? '');
  }

  Future<void> updateProfilePhoto(File imageFile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final ref = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(user.uid)
          .child('profile.jpg');

      await ref.putFile(imageFile);

      final photoUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'photoUrl': photoUrl},
      );

      _userData?['photoUrl'] = photoUrl;
      await _cacheUserData(_userData!);
    } catch (e) {
      debugPrint("Profile photo update failed: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates user profile in Firestore and local state
  Future<void> updateProfile({String? name, String? photoUrl}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (photoUrl != null) updates['photo'] = photoUrl;

      if (updates.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(updates);

        // Update local state
        _userData?.addAll(updates);
        await _cacheUserData(_userData!);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error updating profile: $e");
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
