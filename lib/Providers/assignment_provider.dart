import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _assignments = [];
  List<Map<String, dynamic>> get assignments => _assignments;

  Future<void> fetchAssignments(String classId) async {
    // Placeholder logic
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1)); // Mock network
    _assignments = [
      {
        'id': '1',
        'title': 'Essay on Hamlet',
        'description': 'Write a 500 word essay...',
        'dueDate': Timestamp.now(),
        'status': 'pending', 
        'points': 100,
      },
      {
         'id': '2',
         'title': 'Math Quiz',
         'description': 'Chapter 5 problems',
         'dueDate': Timestamp.now(),
         'status': 'submitted',
          'points': 50,
      }
    ]; // Mock data
    _isLoading = false;
    notifyListeners();
  }

  Future<void> submitAssignment(String assignmentId, String content) async {
    // Placeholder
  }

  Future<void> gradeAssignment(String submissionId, double grade, String feedback) async {
    // Placeholder
  }
}
