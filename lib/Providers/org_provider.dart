import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrgProvider extends ChangeNotifier {
  bool isDisposed = false;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _currentOrgId;
  String? _currentUserId;
  String? _currentOrgName;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get currentOrgId => _currentOrgId;
  String? get currentUserId => _currentUserId;
  String? get currentOrgName => _currentOrgName;

  String? _role;
  String? get role => _role;

  List<Map<String, dynamic>> _userOrgs = [];
  List<Map<String, dynamic>> get userOrgs => _userOrgs;

  Future<void> initializeApp() async {
    _isLoading = true;
    notifyListeners();

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    // ✅ SET CURRENT USER ID
    _currentUserId = firebaseUser.uid;

    // Optional but recommended
    final userDoc = await _db.collection('users').doc(_currentUserId).get();

    if (userDoc.exists) {
      _role = userDoc.data()?['role'];
    }

    // Fetch orgs user belongs to
    await fetchUserOrgs();

    _isLoading = false;
    notifyListeners();
  }

  // Create a new Organization
  Future<void> createOrganization(String name, String plan) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      DocumentReference orgRef = await _db.collection('organizations').add({
        'name': name,
        'ownerId': user.uid,
        'plan': plan, // 'free', 'plus', 'super'
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      // Add user as OWNER member of this org
      await orgRef.collection('members').doc(user.uid).set({
        'uid': user.uid,
        'role': 'owner', // Creator is owner
        'email': user.email,
        'joinedAt': FieldValue.serverTimestamp(),
      });

      // Switch to this new org context immediately
      await switchOrganization(orgRef.id, name, 'owner');

      // Refresh org list
      await fetchUserOrgs();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchUserOrgs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      List<Map<String, dynamic>> orgs = [];

      // WORKAROUND: First, fetch organizations where user is the owner
      // This doesn't require a collectionGroup index
      final ownedOrgs = await _db
          .collection('organizations')
          .where('ownerId', isEqualTo: user.uid)
          .get();

      for (var orgDoc in ownedOrgs.docs) {
        orgs.add({
          'id': orgDoc.id,
          'name': orgDoc.get('name') ?? 'Unnamed Organization',
          'role': 'owner',
          'joinedAt': orgDoc.get('createdAt'),
        });
      }

      // OPTIONAL: Try to fetch memberships via collectionGroup
      // This will fail if the index doesn't exist, but we'll catch the error
      try {
        final memberships = await _db
            .collectionGroup('members')
            .where('uid', isEqualTo: user.uid)
            .get();

        for (var memberDoc in memberships.docs) {
          final orgRef = memberDoc.reference.parent.parent;
          if (orgRef != null) {
            final orgDoc = await orgRef.get();
            if (orgDoc.exists) {
              // Check if we already have this org (from owned orgs)
              final existingOrg = orgs.firstWhere(
                (org) => org['id'] == orgDoc.id,
                orElse: () => <String, dynamic>{},
              );

              if (existingOrg.isEmpty) {
                orgs.add({
                  'id': orgDoc.id,
                  'name': orgDoc.get('name') ?? 'Unnamed Organization',
                  'role': memberDoc.get('role') ?? 'student',
                  'joinedAt': memberDoc.get('joinedAt'),
                });
              }
            }
          }
        }
      } catch (indexError) {
        debugPrint(
          "CollectionGroup query failed (index may not exist): $indexError",
        );
        debugPrint("Showing only owned organizations for now.");
      }

      _userOrgs = orgs;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error fetching orgs: $e");
    }
  }

  Future<void> switchOrganization(
    String orgId,
    String name,
    String role,
  ) async {
    _currentOrgId = orgId;
    _currentOrgName = name;
    _role = role;
    notifyListeners();
  }

  Future<void> leaveOrganization() async {
    _currentOrgId = null;
    _currentOrgName = null;
    _role = null;
    notifyListeners();
  }

  Future<void> inviteMember(
    String email,
    String role, {
    required String title,
    required String body,
  }) async {
    if (_currentOrgId == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      // 1️⃣ Check if user exists
      final userQuery = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception("User with this email does not exist");
      }

      // 2️⃣ Prevent duplicate pending invite
      final existingInvite = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('invitations')
          .where('email', isEqualTo: email)
          .where('status', isEqualTo: 'pending')
          .limit(1)
          .get();

      if (existingInvite.docs.isNotEmpty) {
        throw Exception("Invitation already pending");
      }

      // 3️⃣ Create invitation
      await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('invitations')
          .add({
            'orgId': _currentOrgId,
            'email': email,
            'role': role,
            'title': title,
            'body': body,
            'status': 'pending',
            'invitedBy': _currentUserId, // IMPORTANT
            'createdAt': FieldValue.serverTimestamp(),
            'respondedAt': null,
          });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Stream<QuerySnapshot> fetchOrgInvitations({required String status}) {
    print('Fetching invites');
    print('OrgId: $_currentOrgId');
    print('Status: $status');

    if (_currentOrgId == null) {
      print('OrgId is NULL');
      return const Stream.empty();
    }

    return _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('invitations')
        .where('status', isEqualTo: status)
        .snapshots();
  }

  Future<void> cancelInvitation({required String inviteId}) async {
    if (_currentOrgId == null) return;

    await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('invitations')
        .doc(inviteId)
        .delete();
  }

  Stream<QuerySnapshot> fetchMyInvitations(String email) {
    return _db
        .collectionGroup('invitations')
        .where('email', isEqualTo: email)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  /// Fetch members of the current organization
  Future<List<Map<String, dynamic>>> fetchOrgMembers() async {
    if (_currentOrgId == null) return [];
    try {
      final query = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('members')
          .get();

      return query.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint("Error fetching members: $e");
      return [];
    }
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
