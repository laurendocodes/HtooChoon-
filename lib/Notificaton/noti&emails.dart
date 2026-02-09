import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Notificaton/announcements_widget.dart';

import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Notificaton/invitations_tab.dart';
import 'package:htoochoon_flutter/Providers/notificaton_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:htoochoon_flutter/Theme/themedata.dart';

class NotiAndEmails extends StatefulWidget {
  NotiAndEmails({super.key});

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Notifications',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        bottom: TabBar(
          controller: provider.tabController,
          labelStyle: Theme.of(context).textTheme.labelLarge,
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

class InvitationsTab extends StatelessWidget {
  const InvitationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final invites = provider.invitations;

    if (invites.isEmpty) {
      print("invitation count: ${invites.length}");
      return const Center(child: Text('No invitations'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      itemCount: invites.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spaceMd),
      itemBuilder: (context, index) {
        return InvitationCard(invite: provider.invitations[index]);
      },
    );
  }
}

class InvitationCard extends StatefulWidget {
  final QueryDocumentSnapshot invite;

  const InvitationCard({super.key, required this.invite});
  @override
  State<InvitationCard> createState() => _InvitationCardState();
}

class _InvitationCardState extends State<InvitationCard> {
  bool _isProcessing = false;
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.invite.data() as Map<String, dynamic>;
    final status =
        (data['status'] as String?)?.trim().toLowerCase() ?? 'pending';
    final user = FirebaseAuth.instance.currentUser!;
    final orgName = data['organizationName'] as String? ?? 'Organization';
    final role = data['role'] as String? ?? 'member';
    final invitedBy = data['invitedBy'] as String?;
    final isAccepted = status == 'accepted';
    final isRejected = status == 'rejected';
    final isFinal = isAccepted || isRejected;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Header ----
          Row(
            children: [
              Icon(
                Icons.mail_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppTheme.spaceMd),
              Expanded(
                child: Text(
                  orgName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spaceSm),

          Text('Invited as $role'),

          if (invitedBy != null)
            Text('Invited by $invitedBy')
          else
            Text('Invited by system'),

          const SizedBox(height: AppTheme.spaceMd),

          // ---- Buttons ----
          // Row(
          //   children: [
          //     Expanded(
          //       child: OutlinedButton(
          //         onPressed: _isProcessing
          //             ? null
          //             : () {
          //                 context.read<NotificationProvider>().rejectInvitation(
          //                   inviteId: widget.invite.id,
          //                   orgId: data['orgId'],
          //                 );
          //               },
          //         child: const Text('Decline'),
          //       ),
          //     ),
          //     const SizedBox(width: AppTheme.spaceSm),
          //     Expanded(
          //       child: ElevatedButton(
          //         onPressed: _isProcessing
          //             ? null
          //             : () async {
          //                 setState(() => _isProcessing = true);
          //
          //                 try {
          //                   await context
          //                       .read<NotificationProvider>()
          //                       .acceptInvitation(
          //                         orgId: data['orgId'],
          //                         inviteId: widget.invite.id,
          //                         userId: user.uid,
          //                         email: user.email!,
          //                         role: data['role'],
          //                       );
          //                   setState(() {
          //                     _isProcessing = false;
          //                     _isAccepted = true;
          //                   });
          //                 } catch (e) {
          //                   setState(() => _isProcessing = false);
          //
          //                   ScaffoldMessenger.of(context).showSnackBar(
          //                     const SnackBar(
          //                       content: Text('Failed to accept invitation'),
          //                     ),
          //                   );
          //                 }
          //               },
          //         child: _isProcessing
          //             ? const SizedBox(
          //                 height: 18,
          //                 width: 18,
          //                 child: CircularProgressIndicator(strokeWidth: 2),
          //               )
          //             : const Text('Accept'),
          //       ),
          //     ),
          //   ],
          // ),
          if (_isAccepted)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'Accepted',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isProcessing
                        ? null
                        : () {
                            context
                                .read<NotificationProvider>()
                                .rejectInvitation(
                                  inviteId: widget.invite.id,
                                  orgId: data['orgId'],
                                );
                          },
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceSm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isProcessing
                        ? null
                        : () async {
                            setState(() => _isProcessing = true);

                            try {
                              await context
                                  .read<NotificationProvider>()
                                  .acceptInvitation(
                                    orgId: data['orgId'],
                                    inviteId: widget.invite.id,
                                    userId: user.uid,
                                    email: user.email!,

                                    role: data['role'],
                                  );

                              setState(() {
                                _isProcessing = false;
                                _isAccepted = true;
                              });
                            } catch (e) {
                              setState(() => _isProcessing = false);
                            }
                          },
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Announcements Tab - Show system and organization announcements
class AnnouncementsTab extends StatelessWidget {
  const AnnouncementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Connect to actual announcement data from NotificationProvider
    // This is a placeholder implementation

    return ListView(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      children: [
        _AnnouncementCard(
          title: 'System Maintenance',
          message:
              'The platform will be down for maintenance on Sunday from 2-4 AM.',
          type: AnnouncementType.system,
          date: '3 hours ago',
        ),
        const SizedBox(height: AppTheme.spaceMd),
        _AnnouncementCard(
          title: 'New Course Available',
          message:
              'Advanced Python Programming is now available for enrollment.',
          type: AnnouncementType.info,
          date: 'Yesterday',
        ),
        const SizedBox(height: AppTheme.spaceMd),
        _AnnouncementCard(
          title: 'Exam Schedule',
          message:
              'Final exams will be held next week. Please check your schedule.',
          type: AnnouncementType.important,
          date: '2 days ago',
        ),
      ],
    );
  }
}

enum AnnouncementType { system, info, important }

class _AnnouncementCard extends StatelessWidget {
  final String title;
  final String message;
  final AnnouncementType type;
  final String date;

  const _AnnouncementCard({
    required this.title,
    required this.message,
    required this.type,
    required this.date,
  });

  Color _getTypeColor(BuildContext context) {
    switch (type) {
      case AnnouncementType.system:
        return AppTheme.info;
      case AnnouncementType.info:
        return AppTheme.success;
      case AnnouncementType.important:
        return AppTheme.warning;
    }
  }

  IconData _getTypeIcon() {
    switch (type) {
      case AnnouncementType.system:
        return Icons.settings;
      case AnnouncementType.info:
        return Icons.info_outline;
      case AnnouncementType.important:
        return Icons.priority_high;
    }
  }

  String _getTypeLabel() {
    switch (type) {
      case AnnouncementType.system:
        return 'SYSTEM';
      case AnnouncementType.info:
        return 'INFO';
      case AnnouncementType.important:
        return 'IMPORTANT';
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor(context);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceXs),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: AppTheme.borderRadiusMd,
                ),
                child: Icon(_getTypeIcon(), color: typeColor, size: 20),
              ),
              const SizedBox(width: AppTheme.spaceSm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceXs,
                  vertical: AppTheme.space2xs,
                ),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: AppTheme.borderRadiusSm,
                ),
                child: Text(
                  _getTypeLabel(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: typeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.getTextTertiary(context),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppTheme.space2xs),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
