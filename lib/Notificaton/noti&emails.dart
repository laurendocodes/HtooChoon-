import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Notificaton/announcements_widget.dart';

import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Notificaton/invitations_tab.dart';
import 'package:htoochoon_flutter/Providers/notificaton_provider.dart';
import 'package:provider/provider.dart';

class NotiAndEmails extends StatefulWidget {
  const NotiAndEmails({Key? key}) : super(key: key);

  @override
  State<NotiAndEmails> createState() => _NotiAndEmailsState();
}

class _NotiAndEmailsState extends State<NotiAndEmails>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      context.read<NotificationProvider>().init(
        vsync: this,
        email: user.email!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        bottom: TabBar(
          controller: provider.tabController,
          tabs: const [
            Tab(text: 'Invitations'),
            Tab(text: 'Announcements'),
          ],
        ),
      ),
      body: TabBarView(
        controller: provider.tabController,
        children: const [InvitationsTab(), AnnouncementsTab()],
      ),
    );
  }
}
