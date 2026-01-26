import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificatonProvider extends ChangeNotifier {
  late TabController tabController;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot> invitations = [];
  List<QueryDocumentSnapshot> announcements = [];

  void init(TickerProvider vsync) {
    tabController = TabController(length: 2, vsync: vsync);
    fetchInvitations();
    fetchAnnouncements();
  }

  /// Fetch invitations
  Future<void> fetchInvitations() async {
    final snapshot = await _db
        .collection('invitations')
        .orderBy('createdAt', descending: true)
        .get();

    invitations = snapshot.docs;
    notifyListeners();
  }

  /// Fetch announcements
  Future<void> fetchAnnouncements() async {
    final snapshot = await _db
        .collection('announcements')
        .orderBy('createdAt', descending: true)
        .get();

    announcements = snapshot.docs;
    notifyListeners();
  }

  /// Invite user as Student or Teacher
  Future<void> inviteUser({
    required String orgId,
    required String email,
    required String role,
    required String title,
    required String body,
  }) async {
    await _db.collection('invitations').add({
      'orgId': orgId,
      'email': email,
      'role': role,
      'title': title,
      'body': body,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptInvitation({
    required String orgId,
    required String inviteId,
    required String userId,
    required String email,
    required String role,
  }) async {
    final batch = _db.batch();

    final inviteRef = _db
        .collection('organizations')
        .doc(orgId)
        .collection('invitations')
        .doc(inviteId);

    final memberRef = _db
        .collection('organizations')
        .doc(orgId)
        .collection('members')
        .doc(userId);

    batch.update(inviteRef, {
      'status': 'accepted',
      'respondedAt': FieldValue.serverTimestamp(),
    });

    batch.set(memberRef, {
      'uid': userId,
      'email': email,
      'role': role,
      'status': 'active',
      'joinedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
