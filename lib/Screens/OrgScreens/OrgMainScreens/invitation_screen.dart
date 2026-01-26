import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:provider/provider.dart';

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Invitations"),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            InvitationsList(status: 'pending'),
            InvitationsList(status: 'accepted'),
            InvitationsList(status: 'rejected'),
          ],
        ),
      ),
    );
  }
}

class InvitationsList extends StatelessWidget {
  final String status;

  const InvitationsList({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrgProvider>();

    return StreamBuilder<QuerySnapshot>(
      stream: provider.fetchOrgInvitations(status: status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No $status invitations"));
        }

        final invites = snapshot.data!.docs;

        return ListView.builder(
          itemCount: invites.length,
          itemBuilder: (context, index) {
            final data = invites[index].data() as Map<String, dynamic>;

            return ListTile(
              title: Text(data['email']),
              subtitle: Text("${data['role']} • ${data['title']}"),
              trailing: status == 'pending'
                  ? PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'cancel') {
                          provider.cancelInvitation(
                            inviteId: invites[index].id,
                          );
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'cancel', child: Text('Cancel')),
                      ],
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}
