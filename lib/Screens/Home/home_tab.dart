import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:htoochoon_flutter/Providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.userData;

    if (userProvider.isLoading && user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.getTextTertiary(context),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            Text(
              'Unable to load profile',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.getTextSecondary(context),
              ),
            ),
          ],
        ),
      );
    }

    final displayName = user['name'] ?? user['username'] ?? 'Unknown User';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        title: Row(
          children: [
            const SizedBox(width: AppTheme.spaceXs),
            Text(
              'Dashboard  ',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, size: 22),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 22),
          ),
          const SizedBox(width: AppTheme.spaceXs),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              'Good Afternoon, $displayName',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppTheme.space2xs),
            Text(
              "Here's what's on your schedule today.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.getTextSecondary(context),
              ),
            ),

            const SizedBox(height: AppTheme.space2xl),

            // Up Next
            _SectionHeader(title: 'Up Next'),
            const SizedBox(height: AppTheme.spaceMd),
            _ClassCard(
              title: 'Python for Beginners',
              time: '10:00 AM - 11:30 AM',
              status: 'Live Now',
              isLive: true,
            ),

            const SizedBox(height: AppTheme.space2xl),

            // Quick Access
            _SectionHeader(title: 'Quick Access'),
            const SizedBox(height: AppTheme.spaceMd),
            Row(
              children: [
                Expanded(
                  child: _QuickActionChip(
                    label: 'Assignments',
                    icon: Icons.assignment_outlined,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceSm),
                Expanded(
                  child: _QuickActionChip(
                    label: 'Recordings',
                    icon: Icons.video_library_outlined,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceSm),
                Expanded(
                  child: _QuickActionChip(
                    label: 'Grades',
                    icon: Icons.grade_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.space2xl),

            // Announcements
            _SectionHeader(title: 'Announcements'),
            const SizedBox(height: AppTheme.spaceMd),
            _AnnouncementCard(
              title: 'Exam Schedule Released',
              date: '2 hours ago',
              preview:
                  'The final exam schedule for the Fall semester has been posted...',
            ),
            const SizedBox(height: AppTheme.spaceSm),
            _AnnouncementCard(
              title: 'New Python Material',
              date: 'Yesterday',
              preview: "Instructor uploaded 'Advanced list comprehensions'...",
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppTheme.getTextTertiary(context),
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  final String title;
  final String time;
  final String status;
  final bool isLive;

  const _ClassCard({
    required this.title,
    required this.time,
    required this.status,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(
          color: isLive
              ? AppTheme.error.withOpacity(0.3)
              : AppTheme.getBorder(context),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isLive
                  ? AppTheme.error.withOpacity(0.1)
                  : AppTheme.getSurfaceVariant(context),
              borderRadius: AppTheme.borderRadiusMd,
            ),
            child: Icon(
              Icons.code,
              color: isLive
                  ? AppTheme.error
                  : AppTheme.getTextSecondary(context),
              size: 24,
            ),
          ),
          const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppTheme.space2xs),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          if (isLive)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spaceXs,
                vertical: AppTheme.space2xs,
              ),
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
              child: Text(
                'LIVE',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.error,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _QuickActionChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusMd,
        border: Border.all(color: AppTheme.getBorder(context), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: AppTheme.spaceXs),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final String title;
  final String date;
  final String preview;

  const _AnnouncementCard({
    required this.title,
    required this.date,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusMd,
        border: Border.all(color: AppTheme.getBorder(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                date,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.getTextTertiary(context),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.space2xs),
          Text(
            preview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
