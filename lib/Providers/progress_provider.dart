import 'package:flutter/material.dart';

class ProgressProvider extends ChangeNotifier {
  // Mock data for student progress
  Map<String, double> _classProgress = {
    'class_1': 0.75, // 75%
    'class_2': 0.40, // 40%
  };

  double getProgress(String classId) => _classProgress[classId] ?? 0.0;
  
  // For teacher view
  List<Map<String, dynamic>> _studentProgressList = [];
  List<Map<String, dynamic>> get studentProgressList => _studentProgressList;

  Future<void> fetchClassProgress(String classId) async {
    // Mock fetch
    await Future.delayed(const Duration(milliseconds: 500));
    _studentProgressList = List.generate(10, (index) => {
      'studentName': 'Student ${index + 1}',
      'progress': (index * 10) / 100, // 0.0 to 0.9
      'lastActive': '2 days ago',
    });
    notifyListeners();
  }
}
