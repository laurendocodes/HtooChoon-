import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Api/api_service/api_service.dart';
import 'package:htoochoon_flutter/Api/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final ApiService apiService;

  UserProvider(this.apiService);

  /// ---------------- STATE ----------------
  List<StudentClass> classes = [];
  ClassContent? content;

  bool isLoading = false;
  String? error;
  String? success;

  /// ---------------- HELPERS ----------------
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    error = message;
    success = null;
    notifyListeners();
  }

  void _setSuccess(String message) {
    success = message;
    error = null;
    notifyListeners();
  }

  /// ---------------- METHODS ----------------

  Future<void> fetchClasses() async {
    try {
      _setLoading(true);

      classes = await apiService.getStudentClasses();

      _setSuccess("Classes loaded");
    } catch (e) {
      _setError("Failed to fetch classes");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> joinClass(String classId) async {
    try {
      _setLoading(true);

      await apiService.joinClass(JoinClassRequest(classId: classId));

      await fetchClasses(); // refresh list

      _setSuccess("Joined class successfully");
    } catch (e) {
      _setError("Failed to join class");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchContent(String classId) async {
    try {
      _setLoading(true);

      content = await apiService.getClassContent(classId);

      _setSuccess("Content loaded");
    } catch (e) {
      _setError("Failed to load content");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> submit(SubmitRequest request) async {
    try {
      _setLoading(true);

      await apiService.submitAssignment(request);

      _setSuccess("Submission successful");
    } catch (e) {
      _setError("Submission failed");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> respondInvitation(String id, String status) async {
    try {
      _setLoading(true);

      await apiService.handleInvitation(id, status);

      _setSuccess("Invitation updated");
    } catch (e) {
      _setError("Failed to respond to invitation");
    } finally {
      _setLoading(false);
    }
  }
}

class StudentClass {
  final String id;
  final String name;

  StudentClass({required this.id, required this.name});

  factory StudentClass.fromJson(Map<String, dynamic> json) {
    return StudentClass(id: json['id'], name: json['name']);
  }
}

class ClassContent {
  final List<dynamic> assignments;

  ClassContent({required this.assignments});

  factory ClassContent.fromJson(Map<String, dynamic> json) {
    return ClassContent(assignments: json['assignments'] ?? []);
  }
}
