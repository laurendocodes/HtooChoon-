import 'package:flutter/material.dart';

class StudentClassroomProvider extends ChangeNotifier {
  bool isDisposed = false;

  /// Get joined classrooms/ prograss bar / tr name / days time
  /// Get assignments/tests/
  /// Get live schedules
  ///  Get own assignmenttodo and deadlines/ reminders
  ///  comment session (after mvp)
  /// Show same people filter

  void safeChangeNotifier() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
