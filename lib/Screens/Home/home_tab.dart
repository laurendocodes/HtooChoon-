import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:htoochoon_flutter/Providers/user_provider.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (authProvider.isLoading && user == null) {
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

    final displayName = user.name;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // refined Appbar
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.space2xs),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.dashboard_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppTheme.spaceSm),
            Text(
              'Dashboard',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppTheme.getBorder(context)),
              ),
            ),
            icon: Icon(
              Icons.notifications_outlined,
              size: 20,
              color: AppTheme.getTextSecondary(context),
            ),
          ),
          const SizedBox(width: AppTheme.spaceXs),
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppTheme.getBorder(context)),
              ),
            ),
            icon: Icon(
              Icons.search,
              size: 20,
              color: AppTheme.getTextSecondary(context),
            ),
          ),
          const SizedBox(width: AppTheme.spaceMd),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spaceMd),

            // 1. Greeting & Streak Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Afternoon,',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.getTextSecondary(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        displayName,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spaceXs),
                      Text(
                        "You've completed 80% of your weekly goal. Keep it up!",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.getTextTertiary(context),
                        ),
                      ),
                    ],
                  ),
                ),
                // Spacer or additional action?
              ],
            ),

            const SizedBox(height: AppTheme.spaceLg),

            // 2. Premium Streak Card
            const _StreakCard(),

            const SizedBox(height: AppTheme.space2xl),

            // 3. Live Sessions
            _SectionHeader(
              title: 'Live Sessions',
              action: 'View Schedule',
              onActionTap: () {},
            ),
            const SizedBox(height: AppTheme.spaceMd),
            const _LiveSessionCard(
              title: 'Advanced Flutter Architecture',
              time: 'Starting in 5 mins',
              instructor: 'Dr. Angela Yu',
              isLive: true,
            ),

            const SizedBox(height: AppTheme.space2xl),

            // 4. Jump Back In -> Continue Learning
            _SectionHeader(title: 'Jump Back In'),
            const SizedBox(height: AppTheme.spaceMd),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                children: [
                  _CourseProgressCard(
                    title: 'Python for Data Science',
                    lesson: 'List Comprehensions',
                    progress: 0.75,
                    color: Colors.indigo,
                    icon: Icons.data_usage,
                  ),
                  const SizedBox(width: AppTheme.spaceMd),
                  _CourseProgressCard(
                    title: 'UI/UX Principles',
                    lesson: 'Color Theory 101',
                    progress: 0.30,
                    color: Colors.orange,
                    icon: Icons.palette,
                  ),
                  const SizedBox(width: AppTheme.spaceMd),
                  _CourseProgressCard(
                    title: 'Project Management',
                    lesson: 'Agile Methodologies',
                    progress: 0.10,
                    color: Colors.teal,
                    icon: Icons.view_kanban_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.space2xl),

            // 5. Quick Access Grid
            _SectionHeader(title: 'Quick Access'),
            const SizedBox(height: AppTheme.spaceMd),
            Row(
              children: [
                Expanded(
                  child: _QuickActionChip(
                    label: 'Assignments',
                    icon: Icons.assignment_outlined,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceSm),
                Expanded(
                  child: _QuickActionChip(
                    label: 'Recordings',
                    icon: Icons.video_library_outlined,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceSm),
                Expanded(
                  child: _QuickActionChip(
                    label: 'Grades',
                    icon: Icons.grade_outlined,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.space2xl),

            // 6. Announcements
            _SectionHeader(
              title: 'Announcements',
              action: 'View All',
              onActionTap: () {},
            ),
            const SizedBox(height: AppTheme.spaceMd),
            _AnnouncementCard(
              title: 'Mid-term Exam Schedule',
              date: '2 hours ago',
              preview:
                  'The schedule for the upcoming mid-term examinations has been finalized. Please check your personalized...',
              category: 'Important',
              isHighPriority: true,
            ),
            const SizedBox(height: AppTheme.spaceSm),
            _AnnouncementCard(
              title: 'New Python Material',
              date: 'Yesterday',
              preview:
                  "Instructor uploaded 'Advanced list comprehensions' and accompanying practice exercises.",
              category: 'Material',
            ),

            const SizedBox(height: AppTheme.space4xl), // Bottom padding
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// COMPONENTS
// -----------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onActionTap;

  const _SectionHeader({required this.title, this.action, this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              action!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [
                  const Color(0xFF2563EB),
                  const Color(0xFF1D4ED8),
                ], // Blue gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppTheme.borderRadiusXl,
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.blue).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: Streak Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.orangeAccent,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Keep it up!',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spaceSm),
                Text(
                  '7 Day Streak',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "You're learning faster than 85% of peers.",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // Right: Visual Indicator
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 4,
              ),
            ),
            child: Center(
              child: Text(
                '7',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveSessionCard extends StatelessWidget {
  final String title;
  final String time;
  final String instructor;
  final bool isLive;

  const _LiveSessionCard({
    required this.title,
    required this.time,
    required this.instructor,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context)),
        boxShadow: AppTheme.shadowSm(isDark),
      ),
      child: Column(
        children: [
          // Top: content
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: AppTheme.getSurfaceVariant(context),
                    child: Icon(
                      Icons.videocam_outlined,
                      color: AppTheme.getTextSecondary(context),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (isLive)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppTheme.error.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.error,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'LIVE NOW',
                                    style: TextStyle(
                                      color: AppTheme.error,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Text(
                            time,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppTheme.getTextTertiary(context),
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spaceXs),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'with $instructor',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.getTextSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, color: AppTheme.getBorder(context)),

          // Bottom: Action
          InkWell(
            onTap: () {},
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppTheme.radiusLg),
              bottomRight: Radius.circular(AppTheme.radiusLg),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: Text(
                'Join Session',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseProgressCard extends StatelessWidget {
  final String title;
  final String lesson;
  final double progress;
  final Color color;
  final IconData icon;

  const _CourseProgressCard({
    required this.title,
    required this.lesson,
    required this.progress,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 260,
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context)),
        boxShadow: AppTheme.shadowSm(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.getSurfaceVariant(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.getTextSecondary(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            lesson,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.getTextSecondary(context),
            ),
          ),
          const Spacer(),
          // Progress Bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.getSurfaceVariant(context),
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: AppTheme.spaceXs),
          InkWell(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Continue',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.getTextSecondary(context),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 12,
                  color: AppTheme.getTextSecondary(context),
                ),
              ],
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
  final Color color;

  const _QuickActionChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: AppTheme.borderRadiusMd,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: AppTheme.borderRadiusMd,
          border: Border.all(color: AppTheme.getBorder(context), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.getTextSecondary(context),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final String title;
  final String date;
  final String preview;
  final String category;
  final bool isHighPriority;

  const _AnnouncementCard({
    required this.title,
    required this.date,
    required this.preview,
    required this.category,
    this.isHighPriority = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusMd,
        border: Border.all(
          color: isHighPriority
              ? AppTheme.warning.withOpacity(0.5)
              : AppTheme.getBorder(context),
          width: isHighPriority ? 1.5 : 1,
        ),
        boxShadow: isHighPriority ? AppTheme.shadowSm(isDark) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isHighPriority
                      ? AppTheme.warning.withOpacity(0.1)
                      : AppTheme.getSurfaceVariant(context),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isHighPriority
                        ? Colors.orange[800]
                        : AppTheme.getTextSecondary(context),
                  ),
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
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            preview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.getTextSecondary(context),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
