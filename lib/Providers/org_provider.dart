import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrgProvider extends ChangeNotifier {
  bool isDisposed = false;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _currentOrgId;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get currentOrgId => _currentOrgId;
  String? _role;

  String? get role => _role;

  Future<void> initializeApp() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        _role = userDoc['role'];

        if (_role == 'org') {
          _currentOrgId = userDoc['orgId'];
        }
      }
    } catch (e) {
      debugPrint("Init Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initAdmin(String orgId) async {
    _currentOrgId = orgId;
    notifyListeners();
  }

  // --- 1. Program Management ---
  Future<void> createProgram(String name, String description) async {
    if (_currentOrgId == null) return;
    try {
      _isLoading = true;
      notifyListeners();
      await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('programs')
          .add({
            'name': name,
            'description': description,
            'createdAt': FieldValue.serverTimestamp(),
          });
      print("created program  $name");
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // --- 2. Course Management (Lifecycle: Draft -> Ready -> Live) ---
  Future<void> createCourse(
    String title,
    String? programId,
    String syllabus,
  ) async {
    if (_currentOrgId == null) return;
    try {
      await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('courses')
          .add({
            'title': title,
            'programId': programId,
            'syllabus': syllabus,
            'status': 'DRAFT', // Default status
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStudentStatus(String studentId, String status) async {
    await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('students')
        .doc(studentId)
        .update({'status': status});
  }

  // Update Course Status (e.g., Live, Archived)
  Future<void> updateCourseStatus(String courseId, String newStatus) async {
    if (_currentOrgId == null) return;
    await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('courses')
        .doc(courseId)
        .update({'status': newStatus});
    notifyListeners();
  }

  // --- 3. Class Management ---
  Future<void> createClass({
    required String courseId,
    required String teacherId,
    required String className,
    required DateTime startDate,
  }) async {
    if (_currentOrgId == null) return;
    // Create the class document
    await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('classes')
        .add({
          'name': className,
          'courseId': courseId,
          'teacherId': teacherId,
          'startDate': startDate,
          'status': 'upcoming',
          'studentCount': 0,
        });
  }

  // --- 4. Class Interiors: Assignments, Exams, Live Sessions ---

  // Create Assignment
  Future<void> createAssignment(
    String classId,
    String title,
    String description,
    DateTime dueDate,
  ) async {
    await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('classes')
        .doc(classId)
        .collection('assignments')
        .add({
          'title': title,
          'description': description,
          'dueDate': dueDate,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  // Create Exam (with basic questions array)
  Future<void> createExam(
    String classId,
    String title,
    List<Map<String, dynamic>> questions,
  ) async {
    await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('classes')
        .doc(classId)
        .collection('exams')
        .add({
          'title': title,
          'questions':
              questions, // Array of {question: "", options: [], correct: ""}
          'status': 'scheduled',
        });
  }

  // Schedule Live Session (With AI Cheat Detection Toggle)
  Future<void> createLiveSession({
    required String classId,
    required String title,
    required DateTime startTime,
    required String meetingLink,
    required bool enableAiCheatDetection,
  }) async {
    await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('classes')
        .doc(classId)
        .collection('sessions')
        .add({
          'title': title,
          'startTime': startTime,
          'meetingLink': meetingLink,
          'isLive': false,
          // Admin controls this. If true, student app activates camera/AI logic
          'enableCheatDetection': enableAiCheatDetection,
        });
  }

  // --- 5. People (Teachers/Students) ---

  // Invite Student
  Future<void> inviteStudent(String email, String? classId) async {
    if (_currentOrgId == null) return;
    await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('invites')
        .add({
          'email': email,
          'role': 'student',
          'targetClassId': classId, // Optional: Invite directly to a class
          'status': 'pending',
        });
  }

  // Invite Teacher (Request to work)
  Future<void> inviteTeacher(String email) async {
    if (_currentOrgId == null) return;
    await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('invites')
        .add({'email': email, 'role': 'teacher', 'status': 'pending'});
  }

  //TODO create courses like edx (DRAFT → READY → LIVE → COMPLETED → ARCHIVED) but only live learning sessions and recordings

  //TODO create programs (GED/ CS) / courses then classes

  //TODO request teachers to work on their orgnisaton

  //TODO invite students to study in their orgnisaton or accept the request to be their students

  //TODO to make the  a exam form

  //TODO create live learning sessions for students and teachers which include CV/AI from hugging face model cheat detection by expression /looking at phone/ tab moves (admin can turn on and turn off cheat detection during class since students might need to check pdf files or find something in google)

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
