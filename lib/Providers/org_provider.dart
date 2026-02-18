import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum OrgAction { none, switched, exited }

enum MemberFilter { all, owner, teacher, student }

/// Features:
/// - Organization CRUD operations
/// - Role-based access control (Admin, Moderator, Teacher, Student)
/// - Invitation system (Teachers, Students)
/// - Program/Course/Class management
/// - Member management
class OrgProvider extends ChangeNotifier {
  // ============================================================
  // PRIVATE FIELDS
  // ============================================================

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isDisposed = false;
  bool _isLoading = false;
  bool _orgIsLoading = false;
  bool _isMembersLoading = false;
  bool _justSwitched = false;
  bool _isCreating = false; // for org creation
  OrgAction _lastAction = OrgAction.none;
  MemberFilter _filter = MemberFilter.all;

  String? _currentOrgId;
  String? _currentUserId;
  String? _currentOrgName;
  String? _role;

  Map<String, dynamic>? _orgData;
  List<Map<String, dynamic>> _userOrgs = [];
  List<Map<String, dynamic>> _members = [];
  List<Map<String, dynamic>> _teachers = [];
  List<Map<String, dynamic>> _students = [];

  // ============================================================
  // GETTERS
  // ============================================================

  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get orgIsLoading => _orgIsLoading;
  bool get isMembersLoading => _isMembersLoading;
  bool get justSwitched => _justSwitched;
  bool get hasOrgLoaded => _orgData != null;

  OrgAction get lastAction => _lastAction;
  MemberFilter get filter => _filter;

  String? get currentOrgId => _currentOrgId;
  String? get currentUserId => _currentUserId;
  String? get currentOrgName => _currentOrgName;
  String? get role => _role;
  String get planType => _orgData?['plan']?['planId'] ?? 'none';

  Map<String, dynamic>? get orgData => _orgData;
  List<Map<String, dynamic>> get userOrgs => _userOrgs;
  List<Map<String, dynamic>> get members => _members;
  List<Map<String, dynamic>> get teachers => _teachers;
  List<Map<String, dynamic>> get students => _students;

  bool get hasActivePlan {
    try {
      _requireActivePlan();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ============================================================
  // INITIALIZATION
  // ============================================================

  Future<void> initializeApp() async {
    _isLoading = true;
    notifyListeners();

    final firebaseUser = _auth.currentUser;

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

  void printRole() {
    print("roleeeeee${_role}");
  }
  // ============================================================
  // ORGANIZATION OPERATIONS
  // ============================================================

  /// Create a new organization
  Future<void> createOrganization(String name, String description) async {
    final uid = _auth.currentUser!.uid;
    _isCreating = true;
    safeChangeNotifier();
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
      'email': _auth.currentUser!.email,
      'joinedAt': FieldValue.serverTimestamp(),
    });

    fetchUserOrgs();
    _isCreating = false;
    safeChangeNotifier();
  }

  /// Fetch all organizations user belongs to
  Future<void> fetchUserOrgs() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      List<Map<String, dynamic>> orgs = [];

      // Fetch organizations where user is the owner
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

      // Fetch organizations where user is a member
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

  /// Switch to a different organization
  Future<void> switchOrganization(
    String orgId,
    String name,
    String role,
  ) async {
    _orgIsLoading = true;
    _justSwitched = false;
    notifyListeners();

    _currentOrgId = orgId;
    _currentOrgName = name;
    _role = role;

    final doc = await _db.collection('organizations').doc(orgId).get();
    if (!doc.exists) {
      _orgIsLoading = false;
      notifyListeners();
      throw Exception("Organization not found");
    }

    _orgData = {'id': doc.id, ...doc.data()!};

    _orgIsLoading = false;
    _justSwitched = true;
    notifyListeners();
  }

  /// Leave the current organization
  Future<void> leaveOrganization() async {
    if (_orgIsLoading) return;

    _orgIsLoading = true;
    _lastAction = OrgAction.none;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    // TODO: Remove user from org members, clear caches, revoke permissions

    _currentOrgId = null;
    _currentOrgName = null;
    _role = null;
    _orgData = null;

    _orgIsLoading = false;
    _lastAction = OrgAction.exited;
    notifyListeners();
  }

  // ============================================================
  // PROGRAM/COURSE/CLASS OPERATIONS
  // ============================================================

  /// Create a program
  Future<void> createProgram(String name, String description) async {
    _requireActivePlan();
    safeChangeNotifier();
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
    safeChangeNotifier();
  }

  /// Create a course
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

    safeChangeNotifier();
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
    safeChangeNotifier();
  }

  /// Create a class
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

  /// Update course status
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

  // ============================================================
  // CLASS INTERIOR OPERATIONS
  // ============================================================

  /// Create assignment
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

  /// Create exam
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
        .add({'title': title, 'questions': questions, 'status': 'scheduled'});
  }

  /// Create live session
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
          'enableCheatDetection': enableAiCheatDetection,
        });
  }

  // ============================================================
  // INVITATION SYSTEM
  // ============================================================

  /// Invite member (teacher, admin, moderator)
  Future<void> inviteMember(
    String email,
    String role, {
    required String title,
    required String body,
  }) async {
    if (_currentOrgId == null) return;

    try {
      _isLoading = true;

      safeChangeNotifier();
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
            'orgName': _currentOrgName,
            'invitedBy': _currentUserId,
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

  /// Invite student to class
  Future<void> inviteStudent(
    String email, {
    required String classId,
    required String title,
    required String body,
  }) async {
    if (_currentOrgId == null) return;

    try {
      _isLoading = true;
      safeChangeNotifier();

      // 1. Check if user exists
      final userQuery = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception("User with this email does not exist");
      }

      // 2. Get class details
      final classDoc = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('classes')
          .doc(classId)
          .get();

      if (!classDoc.exists) {
        throw Exception("Class not found");
      }

      final className = classDoc.data()?['name'];
      final courseId = classDoc.data()?['courseId'];

      // 3. Prevent duplicate pending invite
      final existingInvite = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('invitations')
          .where('email', isEqualTo: email)
          .where('role', isEqualTo: 'student')
          .where('classId', isEqualTo: classId)
          .where('status', isEqualTo: 'pending')
          .limit(1)
          .get();

      if (existingInvite.docs.isNotEmpty) {
        throw Exception("Invitation already pending for this class");
      }

      // 4. Create invitation
      await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('invitations')
          .add({
            'orgId': _currentOrgId,
            'email': email,
            'role': 'student',
            'classId': classId,
            'courseId': courseId,
            'className': className,
            'title': title,
            'body': body,
            'status': 'pending',
            'orgName': _currentOrgName,
            'invitedBy': _currentUserId,
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

  /// Fetch user's pending invitations
  Stream<QuerySnapshot> fetchMyInvitations(String email) {
    return _db
        .collectionGroup('invitations')
        .where('email', isEqualTo: email)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  /// Fetch organization invitations by status
  Stream<QuerySnapshot> fetchOrgInvitations({required String status}) {
    if (_currentOrgId == null) {
      return const Stream.empty();
    }

    return _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('invitations')
        .where('status', isEqualTo: status)
        .snapshots();
  }

  /// Fetch pending invitations as list
  Future<List<Map<String, dynamic>>> fetchPendingInvitations() async {
    if (_currentOrgId == null) return [];

    try {
      final snapshot = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('invitations')
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Respond to invitation (accept/reject)
  Future<void> respondToInvitation(String invitationId, bool accepted) async {
    if (_currentOrgId == null) return;

    try {
      final inviteRef = _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('invitations')
          .doc(invitationId);

      final inviteDoc = await inviteRef.get();
      if (!inviteDoc.exists) {
        throw Exception("Invitation not found");
      }

      final inviteData = inviteDoc.data()!;
      final role = inviteData['role'];
      final email = inviteData['email'];

      // Update invitation status
      await inviteRef.update({
        'status': accepted ? 'accepted' : 'declined',
        'respondedAt': FieldValue.serverTimestamp(),
      });

      if (accepted) {
        // Get user ID
        final userQuery = await _db
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (userQuery.docs.isEmpty) return;

        final userId = userQuery.docs.first.id;

        if (role == 'student') {
          await _addStudentToClass(
            userId: userId,
            email: email,
            classId: inviteData['classId'],
          );
        } else {
          await _addMemberToOrg(userId: userId, email: email, role: role);
        }
      }

      safeChangeNotifier();
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel invitation
  Future<void> cancelInvitation({required String inviteId}) async {
    if (_currentOrgId == null) return;

    await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('invitations')
        .doc(inviteId)
        .delete();

    safeChangeNotifier();
  }

  // ============================================================
  // MEMBER MANAGEMENT
  // ============================================================

  /// Search users by email
  Future<List<Map<String, dynamic>>> searchUsersByEmail(String query) async {
    if (query.isEmpty) return [];

    final snap = await _db
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(6)
        .get();

    return snap.docs.map((d) {
      final data = d.data();
      return {
        'uid': d.id,
        'email': data['email'],
        'username': data['username'] ?? data['name'] ?? '',
        'photoUrl': data['photo'],
      };
    }).toList();
  }

  /// Set member filter
  void setFilter(MemberFilter filter) {
    _filter = filter;
    print("filter${filter.name}");
    fetchMembers();
  }

  /// Fetch Members with filter
  Future<void> fetchMembers() async {
    if (_currentOrgId == null) return;

    try {
      _isMembersLoading = true;
      notifyListeners();

      Query query = _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('members')
          .orderBy('joinedAt', descending: true);

      final role = _filter == MemberFilter.all ? null : _filter.name;

      if (role != null) {
        query = query.where('role', isEqualTo: role);
      }

      final snapshot = await query.get();

      _members = snapshot.docs.map((doc) {
        return {'id': doc.id, ...(doc.data() as Map<String, dynamic>)};
      }).toList();
    } catch (e) {
      debugPrint('Fetch members error: $e');
    } finally {
      _isMembersLoading = false;
      notifyListeners();
    }
  }

  /// Fetch organization members
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

  /// Fetch teachers
  Future<void> fetchTeacher(String orgId) async {
    final snapshot = await _db
        .collection('organizations')
        .doc(orgId)
        .collection('members')
        .where('role', isEqualTo: 'teacher')
        .orderBy('joinedAt', descending: true)
        .get();

    _teachers = snapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();

    safeChangeNotifier();
  }

  /// Fetch students
  Future<void> fetchStudents(String orgId) async {
    final snapshot = await _db
        .collection('organizations')
        .doc(orgId)
        .collection('members')
        .where('role', isEqualTo: 'student')
        .orderBy('joinedAt', descending: true)
        .get();

    _students = snapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();

    safeChangeNotifier();
  }

  /// Update student status
  Future<void> updateStudentStatus(String studentId, String status) async {
    await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('students')
        .doc(studentId)
        .update({'status': status});
  }

  // ============================================================
  // ACCESS CONTROL & ROLE-BASED QUERIES
  // ============================================================

  /// Get user's role in current organization
  Future<String?> getUserRoleInOrg(String userId) async {
    if (_currentOrgId == null) return null;

    try {
      // Check if member (admin, moderator, teacher)
      final memberDoc = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('members')
          .doc(userId)
          .get();

      if (memberDoc.exists) {
        return memberDoc.data()?['role'];
      }

      // Check if student in any class
      final classesSnapshot = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('classes')
          .get();

      for (final classDoc in classesSnapshot.docs) {
        final memberDoc = await classDoc.reference
            .collection('members')
            .doc(userId)
            .get();

        if (memberDoc.exists && memberDoc.data()?['role'] == 'student') {
          return 'student';
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error getting user role: $e');
      return null;
    }
  }

  /// Check if user can access a course
  Future<bool> canAccessCourse(String userId, String courseId) async {
    if (_currentOrgId == null) return false;

    final role = await getUserRoleInOrg(userId);

    // Admin and Moderator can access all courses
    if (role == 'admin' || role == 'moderator') return true;

    // Teachers: Check if assigned to this course
    if (role == 'teacher') {
      final teacherDoc = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('courses')
          .doc(courseId)
          .collection('teachers')
          .doc(userId)
          .get();

      return teacherDoc.exists;
    }

    // Students: Check if enrolled in any class for this course
    if (role == 'student') {
      return await studentHasAccessToCourse(userId, courseId);
    }

    return false;
  }

  /// Check if user can access a class
  Future<bool> canAccessClass(String userId, String classId) async {
    if (_currentOrgId == null) return false;

    final role = await getUserRoleInOrg(userId);

    // Admin and Moderator can access all classes
    if (role == 'admin' || role == 'moderator') return true;

    // Check if member of this class
    final memberDoc = await _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('classes')
        .doc(classId)
        .collection('members')
        .doc(userId)
        .get();

    if (memberDoc.exists) return true;

    // Check if teacher is primary teacher
    if (role == 'teacher') {
      final classDoc = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('classes')
          .doc(classId)
          .get();

      return classDoc.data()?['teacherId'] == userId;
    }

    return false;
  }

  /// Check if user can edit course
  Future<bool> canEditCourse(String userId, String courseId) async {
    final role = await getUserRoleInOrg(userId);

    // Admins can edit all courses
    if (role == 'admin') return true;

    // Teachers can edit their assigned courses
    if (role == 'teacher') {
      final teacherDoc = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('courses')
          .doc(courseId)
          .collection('teachers')
          .doc(userId)
          .get();

      return teacherDoc.exists && teacherDoc.data()?['canEdit'] == true;
    }

    return false;
  }

  /// Check if student has access to course via class membership
  Future<bool> studentHasAccessToCourse(String userId, String courseId) async {
    if (_currentOrgId == null) return false;

    try {
      // Get all classes for this course
      final classesSnapshot = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('classes')
          .where('courseId', isEqualTo: courseId)
          .get();

      // Check if student is in any of these classes
      for (final classDoc in classesSnapshot.docs) {
        final memberDoc = await classDoc.reference
            .collection('members')
            .doc(userId)
            .get();

        if (memberDoc.exists &&
            memberDoc.data()?['role'] == 'student' &&
            memberDoc.data()?['status'] == 'active') {
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('Error checking course access: $e');
      return false;
    }
  }

  /// Get all classes a teacher is assigned to
  Future<List<Map<String, dynamic>>> getTeacherClasses(String teacherId) async {
    if (_currentOrgId == null) return [];

    try {
      final classes = <Map<String, dynamic>>[];
      final addedIds = <String>{};

      // Get classes where teacher is primary teacher
      final primaryClasses = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('classes')
          .where('teacherId', isEqualTo: teacherId)
          .get();

      for (final doc in primaryClasses.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        data['isPrimary'] = true;
        classes.add(data);
        addedIds.add(doc.id);
      }

      // Get classes where teacher is additional member
      final allClasses = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('classes')
          .get();

      for (final classDoc in allClasses.docs) {
        if (addedIds.contains(classDoc.id)) continue;

        final memberDoc = await classDoc.reference
            .collection('members')
            .doc(teacherId)
            .get();

        if (memberDoc.exists && memberDoc.data()?['role'] == 'teacher') {
          final data = classDoc.data();
          data['id'] = classDoc.id;
          data['isPrimary'] = false;
          classes.add(data);
        }
      }

      return classes;
    } catch (e) {
      debugPrint('Error getting teacher classes: $e');
      return [];
    }
  }

  /// Get all courses a teacher is assigned to
  Future<List<Map<String, dynamic>>> getTeacherCourses(String teacherId) async {
    if (_currentOrgId == null) return [];

    try {
      final courses = <Map<String, dynamic>>[];

      final coursesSnapshot = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('courses')
          .get();

      for (final courseDoc in coursesSnapshot.docs) {
        final teacherDoc = await courseDoc.reference
            .collection('teachers')
            .doc(teacherId)
            .get();

        if (teacherDoc.exists) {
          final data = courseDoc.data();
          data['id'] = courseDoc.id;
          data['permissions'] = teacherDoc.data();
          courses.add(data);
        }
      }

      return courses;
    } catch (e) {
      debugPrint('Error getting teacher courses: $e');
      return [];
    }
  }

  /// Get all students across all classes a teacher teaches
  Future<List<Map<String, dynamic>>> getTeacherStudents(
    String teacherId,
  ) async {
    if (_currentOrgId == null) return [];

    try {
      final students = <Map<String, dynamic>>[];
      final studentIds = <String>{};

      final classes = await getTeacherClasses(teacherId);

      for (final classData in classes) {
        final classId = classData['id'];
        final classStudents = await getClassStudents(classId);

        for (final student in classStudents) {
          final studentId = student['uid'];
          if (!studentIds.contains(studentId)) {
            studentIds.add(studentId);
            student['classId'] = classId;
            student['className'] = classData['name'];
            students.add(student);
          }
        }
      }

      return students;
    } catch (e) {
      debugPrint('Error getting teacher students: $e');
      return [];
    }
  }

  /// Get all students in a class
  Future<List<Map<String, dynamic>>> getClassStudents(String classId) async {
    if (_currentOrgId == null) return [];

    try {
      final studentsSnapshot = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('classes')
          .doc(classId)
          .collection('members')
          .where('role', isEqualTo: 'student')
          .where('status', isEqualTo: 'active')
          .get();

      final students = <Map<String, dynamic>>[];

      for (final doc in studentsSnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        // Optionally fetch user details
        try {
          final userDoc = await _db.collection('users').doc(doc.id).get();

          if (userDoc.exists) {
            data['userData'] = userDoc.data();
          }
        } catch (e) {
          debugPrint('Error fetching user data for ${doc.id}: $e');
        }

        students.add(data);
      }

      return students;
    } catch (e) {
      debugPrint('Error getting class students: $e');
      return [];
    }
  }

  /// Get all classes a student is enrolled in
  Future<List<Map<String, dynamic>>> getStudentClasses(String userId) async {
    if (_currentOrgId == null) return [];

    try {
      final classes = <Map<String, dynamic>>[];

      final classesSnapshot = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('classes')
          .get();

      for (final classDoc in classesSnapshot.docs) {
        final memberDoc = await classDoc.reference
            .collection('members')
            .doc(userId)
            .get();

        if (memberDoc.exists && memberDoc.data()?['role'] == 'student') {
          final classData = classDoc.data();
          classData['id'] = classDoc.id;
          classData['memberData'] = memberDoc.data();
          classes.add(classData);
        }
      }

      return classes;
    } catch (e) {
      debugPrint('Error getting student classes: $e');
      return [];
    }
  }

  /// Get all programs (admin/moderator only)
  Future<List<Map<String, dynamic>>> getAllPrograms(String userId) async {
    if (_currentOrgId == null) return [];

    final role = await getUserRoleInOrg(userId);

    if (role != 'admin' && role != 'moderator') {
      throw Exception('Insufficient permissions');
    }

    try {
      final programsSnapshot = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('programs')
          .get();

      return programsSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      debugPrint('Error getting programs: $e');
      return [];
    }
  }

  /// Get all courses (admin/moderator only)
  Future<List<Map<String, dynamic>>> getAllCourses(String userId) async {
    if (_currentOrgId == null) return [];

    final role = await getUserRoleInOrg(userId);

    if (role != 'admin' && role != 'moderator') {
      throw Exception('Insufficient permissions');
    }

    try {
      final coursesSnapshot = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('courses')
          .get();

      return coursesSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      debugPrint('Error getting courses: $e');
      return [];
    }
  }

  /// Assign teacher to course (admin only)
  Future<void> assignTeacherToCourse({
    required String teacherId,
    required String courseId,
    bool canEdit = true,
    bool canGrade = true,
  }) async {
    if (_currentOrgId == null) return;

    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) throw Exception('Not authenticated');

    final role = await getUserRoleInOrg(currentUserId);
    if (role != 'admin') {
      throw Exception('Only admins can assign teachers');
    }

    try {
      _isLoading = true;
      safeChangeNotifier();

      final teacherDoc = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('members')
          .doc(teacherId)
          .get();

      if (!teacherDoc.exists || teacherDoc.data()?['role'] != 'teacher') {
        throw Exception('User is not a teacher in this organization');
      }

      final teacherEmail = teacherDoc.data()?['email'];

      await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('courses')
          .doc(courseId)
          .collection('teachers')
          .doc(teacherId)
          .set({
            'uid': teacherId,
            'email': teacherEmail,
            'canEdit': canEdit,
            'canGrade': canGrade,
            'assignedAt': FieldValue.serverTimestamp(),
            'assignedBy': currentUserId,
          });

      _isLoading = false;
      safeChangeNotifier();
    } catch (e) {
      _isLoading = false;
      safeChangeNotifier();
      rethrow;
    }
  }

  /// Assign teacher to class (admin only)
  Future<void> assignTeacherToClass({
    required String teacherId,
    required String classId,
    bool isPrimary = false,
  }) async {
    if (_currentOrgId == null) return;

    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) throw Exception('Not authenticated');

    final role = await getUserRoleInOrg(currentUserId);
    if (role != 'admin') {
      throw Exception('Only admins can assign teachers');
    }

    try {
      _isLoading = true;
      safeChangeNotifier();

      final teacherDoc = await _db
          .collection('organizations')
          .doc(_currentOrgId)
          .collection('members')
          .doc(teacherId)
          .get();

      if (!teacherDoc.exists || teacherDoc.data()?['role'] != 'teacher') {
        throw Exception('User is not a teacher in this organization');
      }

      final teacherEmail = teacherDoc.data()?['email'];
      final batch = _db.batch();

      if (isPrimary) {
        final classRef = _db
            .collection('organizations')
            .doc(_currentOrgId)
            .collection('classes')
            .doc(classId);

        batch.update(classRef, {
          'teacherId': teacherId,
          'teacherEmail': teacherEmail,
        });
      } else {
        final memberRef = _db
            .collection('organizations')
            .doc(_currentOrgId)
            .collection('classes')
            .doc(classId)
            .collection('members')
            .doc(teacherId);

        batch.set(memberRef, {
          'uid': teacherId,
          'email': teacherEmail,
          'role': 'teacher',
          'status': 'active',
          'joinedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      _isLoading = false;
      safeChangeNotifier();
    } catch (e) {
      _isLoading = false;
      safeChangeNotifier();
      rethrow;
    }
  }

  /// Get dashboard data based on user role
  Future<Map<String, dynamic>> getDashboardData(String userId) async {
    if (_currentOrgId == null) {
      return {'role': null, 'data': null};
    }

    final role = await getUserRoleInOrg(userId);

    switch (role) {
      case 'admin':
      case 'moderator':
        return {
          'role': role,
          'programs': await getAllPrograms(userId),
          'courses': await getAllCourses(userId),
        };

      case 'teacher':
        return {
          'role': role,
          'classes': await getTeacherClasses(userId),
          'courses': await getTeacherCourses(userId),
          'students': await getTeacherStudents(userId),
        };

      case 'student':
        return {'role': role, 'classes': await getStudentClasses(userId)};

      default:
        return {'role': null, 'data': null};
    }
  }

  // ============================================================
  // PRIVATE HELPER METHODS
  // ============================================================

  /// Add student to class
  Future<void> _addStudentToClass({
    required String userId,
    required String email,
    required String classId,
  }) async {
    if (_currentOrgId == null) return;

    final batch = _db.batch();

    // Add to class members
    final classMemberRef = _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('classes')
        .doc(classId)
        .collection('members')
        .doc(userId);

    batch.set(classMemberRef, {
      'uid': userId,
      'email': email,
      'role': 'student',
      'status': 'active',
      'joinedAt': FieldValue.serverTimestamp(),
    });

    // Add organization to user's organizations
    final userOrgRef = _db
        .collection('users')
        .doc(userId)
        .collection('organizations')
        .doc(_currentOrgId);

    batch.set(userOrgRef, {
      'organizationId': _currentOrgId,
      'organizationName': _currentOrgName,
      'role': 'student',
      'joinedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  /// Add member to organization
  Future<void> _addMemberToOrg({
    required String userId,
    required String email,
    required String role,
  }) async {
    if (_currentOrgId == null) return;

    final batch = _db.batch();

    // Add to members collection
    final memberRef = _db
        .collection('organizations')
        .doc(_currentOrgId)
        .collection('members')
        .doc(userId);

    batch.set(memberRef, {
      'uid': userId,
      'email': email,
      'role': role,
      'status': 'active',
      'joinedAt': FieldValue.serverTimestamp(),
    });

    // Add organization to user's organizations
    final userOrgRef = _db
        .collection('users')
        .doc(userId)
        .collection('organizations')
        .doc(_currentOrgId);

    batch.set(userOrgRef, {
      'organizationId': _currentOrgId,
      'organizationName': _currentOrgName,
      'role': role,
      'joinedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  /// Require active plan
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

  /// Require specific feature
  void _requireFeature(String featureKey) {
    final features = _orgData?['plan']?['featuresSnapshot'];
    if (features?[featureKey] != true) {
      throw Exception("This feature is not included in your plan.");
    }
  }

  // ============================================================
  // UTILITY METHODS
  // ============================================================

  void clearLastAction() {
    _lastAction = OrgAction.none;
  }

  void clearJustSwitched() {
    _justSwitched = false;
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
