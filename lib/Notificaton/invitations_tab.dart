import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/invitation_provider.dart';

import 'package:provider/provider.dart';

class InvitationsTab extends StatelessWidget {
  const InvitationsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<InvitationProvider>(
      builder: (context, provider, child) {
        if (provider.invitations.isEmpty) {
          return const Center(child: Text("No pending invitations"));
        }

        return ListView.builder(
          itemCount: provider.invitations.length,
          itemBuilder: (context, index) {
            print(provider.invitations.length);
            return InvitationTile(invite: provider.invitations[index]);
          },
        );
      },
    );
  }
}

class InvitationTile extends StatefulWidget {
  final QueryDocumentSnapshot invite;

  const InvitationTile({Key? key, required this.invite}) : super(key: key);

  @override
  State<InvitationTile> createState() => _InvitationTileState();
}

class _InvitationTileState extends State<InvitationTile> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.invite.data() as Map<String, dynamic>;
    final user = FirebaseAuth.instance.currentUser!;

    return Card(
      child: ListTile(
        title: Text(data['title'] ?? 'Invitation'),
        subtitle: Text(data['body'] ?? ''),
        trailing: _isProcessing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : ElevatedButton(
                onPressed: () async {
                  setState(() => _isProcessing = true);

                  try {
                    await context.read<InvitationProvider>().acceptInvitation(
                      orgId: data['orgId'],
                      inviteId: widget.invite.id,
                      userId: user.uid,
                      email: user.email!,
                      // role: data['role'],
                    );

                    // setState(() => _isProcessing = false);
                  } catch (e) {
                    setState(() => _isProcessing = false);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to accept invitation"),
                      ),
                    );
                  }
                },
                child: const Text("Accept"),
              ),
      ),
    );
  }
}
