import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum MemberFilter { all, teacher, student }

class OrgProvider extends ChangeNotifier {
  bool isDisposed = false;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // ignore: unused_field
  Map<String, dynamic>? _orgData;
  Map<String, dynamic>? get orgData => _orgData;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _teachers = [];
  List<Map<String, dynamic>> get teachers => _teachers;
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> get students => _students;
  String? _currentOrgId;
  String? _currentUserId;
  String? _currentOrgName;
  bool _isLoading = false;
  bool _isMembersLoading = false;

  bool get isLoading => _isLoading;
  bool get isMembersLoading => _isMembersLoading;
  String? get currentOrgId => _currentOrgId;
  String? get currentUserId => _currentUserId;
  String? get currentOrgName => _currentOrgName;

  String? _role;
  String? get role => _role;

  List<Map<String, dynamic>> _userOrgs = [];
  List<Map<String, dynamic>> get userOrgs => _userOrgs;
  bool get hasOrgLoaded => _orgData != null;

  bool get hasActivePlan {
    try {
      _requireActivePlan();
      return true;
    } catch (_) {
      return false;
    }
  }

  String get planType => _orgData?['plan']?['planId'] ?? 'none';

  //Filter member

  MemberFilter _filter = MemberFilter.all;
  List<Map<String, dynamic>> _members = [];

  MemberFilter get filter => _filter;
  List<Map<String, dynamic>> get members => _members;

  void setFilter(MemberFilter filter) {
    _filter = filter;
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    if (_currentOrgId == null) return;

    try {
      _isMembersLoading = true;
      notifyListeners();

      Query query = _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('members');

      if (_filter != MemberFilter.all) {
        query = query.where('role', isEqualTo: _filter.name);
      }

      final snapshot = await query.get();

      _members = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          return {'id': doc.id, ...data};
        } else {
          return {'id': doc.id};
        }
      }).toList();
    } catch (e) {
      debugPrint('Fetch members error: $e');
    } finally {
      _isMembersLoading = false;
      notifyListeners();
    }
  }

  Future<void> initializeApp() async {
    _isLoading = true;
    notifyListeners();

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _currentUserId = firebaseUser.uid;

    final userDoc = await _db.collection('users').doc(_currentUserId).get();

    if (userDoc.exists) {
      _role = userDoc.data()?['role'];
    }

    await fetchUserOrgs();

    _isLoading = false;
    notifyListeners();
  }

  // Create a new Organization
  Future<void> createOrganization(String name, String description) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final orgRef = await _db.collection('organizations').add({
      'name': name,
      'description': description,
      'logoUrl': '',
      'ownerId': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'plan': {
        'planId': 'trial',
        'status': 'trial',
        'paymentType': 'free',
        'startAt': FieldValue.serverTimestamp(),
        'endAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 14)),
        ),
        'limitsSnapshot': {
          'programs': 3,
          'courses': 5,
          'classes': 5,
          'teachers': 2,
          'students': 50,
        },
        'featuresSnapshot': {
          'liveSessions': false,
          'assignments': true,
          'analytics': false,
        },
      },
    });

    await orgRef.collection('members').doc(uid).set({
      'uid': uid,
      'role': 'owner',
      'email': FirebaseAuth.instance.currentUser!.email,
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  // Future<void> createOrganization(
  //   String name,
  //   String plan,
  //   String planStatus,
  //   bool verify,
  // ) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return;
  //
  //   try {
  //     _isLoading = true;
  //     notifyListeners();
  //
  //     DocumentReference orgRef = await _db.collection('organizations').add({
  //       'name': name,
  //       'verify': verify,
  //       'ownerId': user.uid,
  //       'planType': plan, // 'free', 'plus', 'super'
  //       'planStatus': planStatus, // 'active', 'due', 'cancelled'
  //       'createdAt': FieldValue.serverTimestamp(),
  //       'isActive': true,
  //     });
  //
  //     // Add user as OWNER member of this org
  //     await orgRef.collection('members').doc(user.uid).set({
  //       'uid': user.uid,
  //       'role': 'owner', // Creator is owner
  //       'email': user.email,
  //       'joinedAt': FieldValue.serverTimestamp(),
  //     });
  //
  //     // Switch to this new org context immediately
  //     await switchOrganization(orgRef.id, name, 'owner');
  //
  //     // Refresh org list
  //     await fetchUserOrgs();
  //
  //     _isLoading = false;
  //     notifyListeners();
  //   } catch (e) {
  //     _isLoading = false;
  //     notifyListeners();
  //     rethrow;
  //   }
  // }

  // --- 1. Program Management ---
  // Future<void> createProgram(String name, String description) async {
  //   if (_currentOrgId == null) return;
  //   try {
  //     _isLoading = true;
  //     notifyListeners();
  //     await _db
  //         .collection('organizations')
  //         .doc(_currentOrgId)
  //         .collection('programs')
  //         .add({
  //           'name': name,
  //           'description': description,
  //           'createdAt': FieldValue.serverTimestamp(),
  //         });
  //     print("created program  $name");
  //     _isLoading = false;
  //     notifyListeners();
  //   } catch (e) {
  //     _isLoading = false;
  //     notifyListeners();
  //     rethrow;
  //   }
  // }

  Future<void> createProgram(String name, String description) async {
    _requireActivePlan();

    await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('programs')
        .add({
          'name': name,
          'description': description,
          'coverImage': '',
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': _currentUserId,
          'isArchived': false,
        });
  }

  // Future<void> createCourse(
  //   String title,
  //
  //   String? programId,
  //   String syllabus, {
  //   List<String>? categories,
  // }) async {
  //   if (_currentOrgId == null) return;
  //
  //   try {
  //     await _db
  //         .collection('organizations')
  //         .doc(_currentOrgId)
  //         .collection('courses')
  //         .add({
  //           'title': title,
  //           'programId': programId,
  //           'syllabus': syllabus,
  //           'categories': categories ?? [],
  //           'status': 'DRAFT',
  //           'createdAt': FieldValue.serverTimestamp(),
  //         });
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  void _requireActivePlan() {
    final plan = _orgData?['plan'];

    if (plan == null) {
      throw Exception("No plan found. Please upgrade.");
    }

    final status = plan['status'];
    if (status != 'active' && status != 'trial') {
      throw Exception("Your plan is inactive. Please upgrade.");
    }

    final endAt = plan['endAt'];
    if (endAt != null &&
        (endAt as Timestamp).toDate().isBefore(DateTime.now())) {
      throw Exception("Your plan has expired. Please upgrade.");
    }
  }

  void _requireFeature(String featureKey) {
    final features = _orgData?['plan']?['featuresSnapshot'];
    if (features?[featureKey] != true) {
      throw Exception("This feature is not included in your plan.");
    }
  }

  Future<void> createCourse({
    required String title,
    required String description,
    String? programId,
    required String category,
    required String level,
    required int price,
    required int durationWeeks,
    required int totalClasses,
    required int seats,
  }) async {
    _requireActivePlan();

    await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('courses')
        .add({
          'title': title,
          'description': description,
          'programId': programId,
          'thumbnailUrl': '',
          'category': category,
          'level': level,
          'language': 'English',
          'price': price,
          'durationWeeks': durationWeeks,
          'totalClasses': totalClasses,
          'seats': seats,
          'status': 'draft',
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': _currentUserId,
        });
  }

  Future<void> createClass({
    required String courseId,
    required String className,
    required String teacherId,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> days,
    required String time,
    required int maxStudents,
  }) async {
    _requireActivePlan();

    await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('classes')
        .add({
          'name': className,
          'courseId': courseId,
          'teacherId': teacherId,
          'startDate': Timestamp.fromDate(startDate),
          'endDate': Timestamp.fromDate(endDate),
          'schedule': {'days': days, 'time': time},
          'status': 'upcoming',
          'studentCount': 0,
          'maxStudents': maxStudents,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  Future<void> fetchUserOrgs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      List<Map<String, dynamic>> orgs = [];

      // First, fetch organizations where user is the owner

      //Todo add different screen where the user is a mod or a teacher
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
    _isLoading = true;
    notifyListeners();

    _currentOrgId = orgId;
    _currentOrgName = name;
    _role = role;

    final doc = await _db.collection('organizations').doc(orgId).get();

    if (!doc.exists) {
      throw Exception("Organization not found");
    }

    _orgData = {'id': doc.id, ...doc.data()!};

    _isLoading = false;
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

      // 1. Check if user exists
      final userQuery = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception("User with this email does not exist");
      }

      // 2. Prevent duplicate pending invite
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

      // 3. Create invitation
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
      safeChangeNotifier();
    } catch (e) {
      _isLoading = false;
      safeChangeNotifier();
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

  /// Teacher Filter Screen
  Future<void> fetchTeacher(String orgId) async {
    final snapshot = await _db
        .collection('organizations')
        .doc(orgId)
        .collection('members')
        .where('role', isEqualTo: 'teacher')
        .orderBy('createdAt', descending: true)
        .get();

    _teachers = snapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();

    safeChangeNotifier();
  }

  /// Student Filter Screen
  Future<void> fetchStudents(String orgId) async {
    final snapshot = await _db
        .collection('organizations')
        .doc(orgId)
        .collection('members')
        .where('role', isEqualTo: 'student')
        .orderBy('createdAt', descending: true)
        .get();

    _students = snapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();

    safeChangeNotifier();
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
