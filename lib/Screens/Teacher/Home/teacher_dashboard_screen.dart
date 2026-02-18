import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/OrgWidgets/premium_sidebar.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:htoochoon_flutter/Screens/Teacher/Widgets/teacher_widgets.dart';
import 'package:provider/provider.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive Layout Wrapper
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return _DesktopLayout();
        } else {
          return _MobileLayout();
        }
      },
    );
  }
}

// -----------------------------------------------------------------------------
// DESKTOP LAYOUT
// -----------------------------------------------------------------------------
class _DesktopLayout extends StatefulWidget {
  _DesktopLayout();

  @override
  State<_DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<_DesktopLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExtended = MediaQuery.of(context).size.width > 1200;

    return Consumer<OrgProvider>(
      builder: (context, orgProvider, child) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Row(
          children: [
            // 1. Sidebar
            Container(
              width: 260,
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border(
                  right: BorderSide(color: AppTheme.getBorder(context)),
                ),
              ),
              child: PremiumSidebar(
                role: orgProvider.role,
                orgName: orgProvider.currentOrgName.toString(),
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() => _selectedIndex = index);
                },
                isExtended: isExtended,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const _DashboardHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppTheme.spaceLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quick Stats Row
                          const _MetricsSection(),
                          const SizedBox(height: AppTheme.spaceLg),

                          // Action Required
                          const _ActionRequiredSection(),
                          const SizedBox(height: AppTheme.spaceLg),

                          // Main Grid (Classes | Leaderboard)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: const _TodaysClassesSection(),
                              ),
                              const SizedBox(width: AppTheme.spaceLg),
                              Expanded(
                                flex: 1,
                                child: const _LeaderboardSection(),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppTheme.spaceLg),

                          // Secondary Grid (Student Status | Calendar placeholder)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: const _StudentStatusSection(),
                              ),
                              const SizedBox(width: AppTheme.spaceLg),
                              Expanded(
                                flex: 1,
                                child: const _CalendarSectionPlaceholder(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MOBILE LAYOUT
// -----------------------------------------------------------------------------
class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: theme.cardColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.getTextSecondary(context)),
      ),
      drawer: Drawer(
        backgroundColor: theme.cardColor,
        child: const _SidebarContent(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _DashboardHeader(isMobile: true),
            const SizedBox(height: AppTheme.spaceMd),
            const _MetricsSection(isMobile: true),
            const SizedBox(height: AppTheme.spaceMd),
            const _ActionRequiredSection(isMobile: true),
            const SizedBox(height: AppTheme.spaceMd),
            const _TodaysClassesSection(),
            const SizedBox(height: AppTheme.spaceMd),
            const _LeaderboardSection(),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SECTIONS & WIDGETS
// -----------------------------------------------------------------------------

class _SidebarContent extends StatelessWidget {
  const _SidebarContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        // Logo Placeholder
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'EduDash',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 48),

        // Navigation Items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              SidebarItem(
                icon: Icons.dashboard_outlined,
                label: 'Dashboard',
                isSelected: true,
                onTap: () {},
              ),
              SidebarItem(
                icon: Icons.class_outlined,
                label: 'Classrooms',
                isSelected: false,
                onTap: () {},
              ),
              SidebarItem(
                icon: Icons.people_outline,
                label: 'Students',
                isSelected: false,
                onTap: () {},
              ),
              SidebarItem(
                icon: Icons.bar_chart_outlined,
                label: 'Performance',
                isSelected: false,
                onTap: () {},
              ),
              SidebarItem(
                icon: Icons.book_outlined,
                label: 'Courses',
                isSelected: false,
                onTap: () {},
              ),
              SidebarItem(
                icon: Icons.calendar_today_outlined,
                label: 'Calendar',
                isSelected: false,
                onTap: () {},
              ),
              SidebarItem(
                icon: Icons.emoji_events_outlined,
                label: 'Leaderboard',
                isSelected: false,
                onTap: () {},
              ),
            ],
          ),
        ),

        // User Profile
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppTheme.getBorder(context))),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 16,
                child: const Text(
                  'MJ',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mr. John',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Teacher',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.getTextTertiary(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final bool isMobile;
  const _DashboardHeader({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, Mr. John 👋',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Here is your daily summary.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.getTextTertiary(context),
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceLg,
        vertical: AppTheme.spaceMd,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(bottom: BorderSide(color: AppTheme.getBorder(context))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, Mr. John 👋',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.event_available,
                    size: 14,
                    color: AppTheme.getTextTertiary(context),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '3 Classes Today',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 14,
                    color: AppTheme.warning,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '12 Unmarked',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none),
              ),
              const SizedBox(width: AppTheme.spaceMd),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Create New'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricsSection extends StatelessWidget {
  final bool isMobile;
  const _MetricsSection({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    // Return a Grid or Row based on layout
    List<Widget> cards = [
      const StatCard(
        label: 'Total Students',
        value: '142',
        icon: Icons.people,
        color: Colors.blue,
        trend: '+12%',
        trendUp: true,
      ),
      const StatCard(
        label: 'Avg Performance',
        value: '78%',
        icon: Icons.bar_chart,
        color: Colors.green,
        trend: '+5%',
        trendUp: true,
      ),
      const StatCard(
        label: 'Unmarked',
        value: '12',
        icon: Icons.rate_review,
        color: Colors.orange,
        trend: '-2',
        trendUp: false,
      ), // Trend down is good for unmarked? Let's say false means red arrow down.
      const StatCard(
        label: 'Active Today',
        value: '89%',
        icon: Icons.verified_user,
        color: Colors.teal,
        trend: 'stable',
        trendUp: true,
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards
            .map(
              (c) =>
                  Padding(padding: const EdgeInsets.only(bottom: 12), child: c),
            )
            .toList(),
      );
    }

    return Row(
      children: cards
          .map(
            (c) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: c,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ActionRequiredSection extends StatelessWidget {
  final bool isMobile;
  const _ActionRequiredSection({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final children = [
      ActionRequiredCard(
        title: 'Mark Assignments',
        subtitle: '12 pending in "Python 101"',
        icon: Icons.edit_note,
        color: AppTheme.warning,
        onTap: () {},
      ),
      if (isMobile)
        const SizedBox(height: AppTheme.spaceMd)
      else
        const SizedBox(width: AppTheme.spaceMd),
      ActionRequiredCard(
        title: 'Missing Submissions',
        subtitle: '4 students late for "Midterm"',
        icon: Icons.access_time_filled,
        color: AppTheme.error,
        onTap: () {},
      ),
      if (isMobile)
        const SizedBox(height: AppTheme.spaceMd)
      else
        const SizedBox(width: AppTheme.spaceMd),
      const SmartInsightCard(
        message: 'Engagement dropped in "Biology".',
        trend: '-15%',
        positive: false,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACTION REQUIRED',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: AppTheme.getTextTertiary(context),
          ),
        ),
        const SizedBox(height: AppTheme.spaceMd),
        isMobile
            ? Column(children: children)
            : Row(
                children:
                    children
                        .whereType<Widget>()
                        .where(
                          (w) =>
                              w is ActionRequiredCard || w is SmartInsightCard,
                        )
                        .map((e) => Expanded(child: e))
                        .expand(
                          (element) => [
                            element,
                            const SizedBox(width: AppTheme.spaceMd),
                          ],
                        )
                        .toList()
                      ..removeLast(), // Quick hack to add spacing, but simpler to just rebuild list
              ),
      ],
    );
  }
}

class _TodaysClassesSection extends StatelessWidget {
  const _TodaysClassesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Classes',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMd),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ClassScheduleCard(
                className: 'Advanced Physics',
                time: '09:00 - 10:30',
                studentCount: 32,
                status: 'Live',
                onAction: () {},
              ),
              const SizedBox(height: AppTheme.spaceMd),
              ClassScheduleCard(
                className: 'Introduction to Python',
                time: '11:00 - 12:30',
                studentCount: 45,
                status: 'Upcoming',
                onAction: () {},
              ),
              const SizedBox(height: AppTheme.spaceMd),
              ClassScheduleCard(
                className: 'Data Structures',
                time: '14:00 - 15:30',
                studentCount: 28,
                status: 'Upcoming',
                onAction: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LeaderboardSection extends StatelessWidget {
  const _LeaderboardSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Students',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Icon(Icons.more_horiz, color: AppTheme.getTextTertiary(context)),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMd),
          const LeaderboardRow(
            rank: 1,
            name: 'Emma Wilson',
            score: '98%',
            trendUp: true,
          ),
          const Divider(),
          const LeaderboardRow(
            rank: 2,
            name: 'James Rodriguez',
            score: '96%',
            trendUp: true,
          ),
          const Divider(),
          const LeaderboardRow(
            rank: 3,
            name: 'Sarah Chen',
            score: '95%',
            trendUp: false,
          ),
          const Divider(),
          const LeaderboardRow(
            rank: 4,
            name: 'Michael Brown',
            score: '92%',
            trendUp: true,
          ),
          const Divider(),
          const LeaderboardRow(
            rank: 5,
            name: 'Emily Davis',
            score: '91%',
            trendUp: true,
          ),
        ],
      ),
    );
  }
}

class _StudentStatusSection extends StatelessWidget {
  const _StudentStatusSection();

  @override
  Widget build(BuildContext context) {
    // Placeholder for tabs
    return Container(
      height: 300,
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context)),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: AppTheme.getTextTertiary(context),
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: const [
                Tab(text: 'Unmarked'),
                Tab(text: 'Recently Marked'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: Text(
                      'List of unmarked students...',
                      style: TextStyle(
                        color: AppTheme.getTextTertiary(context),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'List of recently marked students...',
                      style: TextStyle(
                        color: AppTheme.getTextTertiary(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarSectionPlaceholder extends StatelessWidget {
  const _CalendarSectionPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calendar',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.calendar_month, size: 48, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
