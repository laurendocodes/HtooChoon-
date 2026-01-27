import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StructureProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _programs = [];
  List<Map<String, dynamic>> _courses = [];
  List<Map<String, dynamic>> _classes = [];

  List<Map<String, dynamic>> get programs => _programs;
  List<Map<String, dynamic>> get courses => _courses;
  List<Map<String, dynamic>> get classes => _classes;

  /// Create a new Program within an organization
  Future<void> createProgram(String orgId, String name, String description) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _db
          .collection('organizations')
          .doc(orgId)
          .collection('programs')
          .add({
        'name': name,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      await fetchPrograms(orgId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error creating program: $e");
      rethrow;
    }
  }

  /// Fetch all programs for an organization
  Future<void> fetchPrograms(String orgId) async {
    try {
      final snapshot = await _db
          .collection('organizations')
          .doc(orgId)
          .collection('programs')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      _programs = snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching programs: $e");
    }
  }

  /// Create a new Course within a Program
  Future<void> createCourse(String orgId, String programId, String name, String description) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _db
          .collection('organizations')
          .doc(orgId)
          .collection('programs')
          .doc(programId)
          .collection('courses')
          .add({
        'name': name,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      await fetchCourses(orgId, programId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error creating course: $e");
      rethrow;
    }
  }

  /// Fetch all courses for a program
  Future<void> fetchCourses(String orgId, String programId) async {
    try {
      final snapshot = await _db
          .collection('organizations')
          .doc(orgId)
          .collection('programs')
          .doc(programId)
          .collection('courses')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      _courses = snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching courses: $e");
    }
  }

  /// Create a new Class within a Course
  Future<void> createClass({
    required String orgId,
    required String programId,
    required String courseId,
    required String name,
    required String teacherId,
    String? schedule,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _db
          .collection('organizations')
          .doc(orgId)
          .collection('programs')
          .doc(programId)
          .collection('courses')
          .doc(courseId)
          .collection('classes')
          .add({
        'name': name,
        'teacherId': teacherId,
        'schedule': schedule,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      await fetchClasses(orgId, programId, courseId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error creating class: $e");
      rethrow;
    }
  }

  /// Fetch all classes for a course
  Future<void> fetchClasses(String orgId, String programId, String courseId) async {
    try {
      final snapshot = await _db
          .collection('organizations')
          .doc(orgId)
          .collection('programs')
          .doc(programId)
          .collection('courses')
          .doc(courseId)
          .collection('classes')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      _classes = snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching classes: $e");
    }
  }

  /// Clear all cached structure data (useful when switching orgs)
  void clearStructureData() {
    _programs = [];
    _courses = [];
    _classes = [];
    notifyListeners();
  }
}
