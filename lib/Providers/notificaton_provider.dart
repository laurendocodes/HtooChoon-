import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationProvider extends ChangeNotifier {
  late TabController tabController;
  bool isDisposed = false;

  void safeChangeNotifier() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot> invitations = [];
  List<QueryDocumentSnapshot> announcements = [];

  StreamSubscription? _invitationSub;

  void init({required TickerProvider vsync, required String email}) {
    tabController = TabController(length: 2, vsync: vsync);

    _listenToInvitations(email);
    fetchAnnouncements();
  }

  void _listenToInvitations(String? email) {
    if (email == null) return;

    _invitationSub?.cancel();

    _invitationSub = _db
        .collectionGroup('invitations')
        .where('email', isEqualTo: email)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
          invitations = snapshot.docs;
          notifyListeners();
        });
  }

  // void _listenToInvitations(String email) {
  //   _invitationSub?.cancel();
  //   print("print email: $email from _listenToInvitations");
  //
  //   _invitationSub = _db
  //       .collectionGroup('invitations')
  //       .where('email', isEqualTo: email)
  //       .where('status', isEqualTo: 'pending')
  //       .snapshots()
  //       .listen((snapshot) {
  //         invitations = snapshot.docs;
  //         notifyListeners();
  //       });
  //   safeChangeNotifier();
  // }

  Future<void> fetchAnnouncements() async {
    final snapshot = await _db
        .collection('announcements')
        .orderBy('createdAt', descending: true)
        .get();

    announcements = snapshot.docs;
    notifyListeners();
  }

  Future<void> rejectInvitation({
    required String orgId,
    required String inviteId,
  }) async {
    await _db
        .collection('organizations')
        .doc(orgId)
        .collection('invitations')
        .doc(inviteId)
        .update({
          'status': 'rejected',
          'respondedAt': FieldValue.serverTimestamp(),
        });
  }

  @override
  void dispose() {
    _invitationSub?.cancel();
    tabController.dispose();
    super.dispose();
  }
}
