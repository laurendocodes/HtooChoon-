import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:htoochoon_flutter/Screens/MainLayout/main_scaffold.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/OrgWidgets/premium_sidebar.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/org_core_home.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/org_tabs/members_tab.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:htoochoon_flutter/Screens/Teacher/Widgets/teacher_widgets.dart';
import 'package:provider/provider.dart';

//
// class TeacherDashboardScreen extends StatefulWidget {
//   final String? currentOrgID;
//   final String? currentOrgName;
//   final String? role;
//
//   const TeacherDashboardScreen({
//     super.key,
//     required this.currentOrgID,
//     required this.currentOrgName,
//     required this.role,
//   });
//
//   @override
//   State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
// }
//
// class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
//   int _selectedIndex = 0;
//
//   late final List<Widget> _pages = [
//     const Dash(),
//     const AllProgramsScreen(),
//     const MemberFilterScreen(),
//     const TeachersListScreen(),
//     const StudentsListScreen(),
//   ];
//
//   void _onSelect(int index) {
//     setState(() => _selectedIndex = index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (constraints.maxWidth > 900) {
//           return _DesktopLayout(
//             selectedIndex: _selectedIndex,
//             pages: _pages,
//             onSelect: _onSelect,
//           );
//         } else {
//           return _MobileLayout(
//             selectedIndex: _selectedIndex,
//             pages: _pages,
//             onSelect: _onSelect,
//           );
//         }
//       },
//     );
//   }
// }
//
// // -----------------------------------------------------------------------------
// // DESKTOP LAYOUT
// // -----------------------------------------------------------------------------
// class _DesktopLayout extends StatefulWidget {
//   final int selectedIndex;
//   final List<Widget> pages;
//   final Function(int) onSelect;
//
//   const _DesktopLayout({
//     required this.selectedIndex,
//     required this.pages,
//     required this.onSelect,
//   });
//
//   @override
//   State<_DesktopLayout> createState() => _DesktopLayoutState();
// }
//
// class _DesktopLayoutState extends State<_DesktopLayout> {
//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> _pages = [
//       const Dash(),
//       const AllProgramsScreen(),
//       const MemberFilterScreen(),
//       const TeachersListScreen(),
//       const StudentsListScreen(),
//     ];
//     final theme = Theme.of(context);
//     final isExtended = MediaQuery.of(context).size.width > 1200;
//     final orgProvider = context.watch<OrgProvider>();
//
//     // Handle organization exit
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (orgProvider.lastAction == OrgAction.exited) {
//         orgProvider.clearLastAction();
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (_) => MainScaffold()),
//           (route) => false,
//         );
//       }
//     });
//
//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           body: Row(
//             children: [
//               // Sidebar Navigation
//               PremiumSidebar(
//                 orgName: orgProvider.currentOrgName.toString(),
//                 selectedIndex: widget.selectedIndex,
//                 onDestinationSelected: widget.onSelect,
//                 isExtended: isExtended,
//                 role: orgProvider.role,
//               ),
//
//               // Main Content Area
//               Expanded(
//                 child: IndexedStack(
//                   index: widget.selectedIndex,
//                   children: _pages,
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         // Loading Overlay
//         GlobalOrgSwitchOverlay(loadingText: "Exiting organization…"),
//       ],
//     );
//   }
// }
//
// // -----------------------------------------------------------------------------
// // MOBILE LAYOUT
// // -----------------------------------------------------------------------------
// class _MobileLayout extends StatelessWidget {
//   final int selectedIndex;
//   final List<Widget> pages;
//   final Function(int) onSelect;
//
//   const _MobileLayout({
//     required this.selectedIndex,
//     required this.pages,
//     required this.onSelect,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//
//       appBar: AppBar(
//         title: Text(_getTitle(selectedIndex)),
//         backgroundColor: theme.cardColor,
//         elevation: 0,
//       ),
//
//       drawer: Drawer(
//         backgroundColor: theme.cardColor,
//         child: SafeArea(
//           child: _SidebarContent(
//             selectedIndex: selectedIndex,
//             onTap: (index) {
//               onSelect(index);
//               Navigator.pop(context); // close drawer
//             },
//           ),
//         ),
//       ),
//
//       body: pages[selectedIndex],
//     );
//   }
//
//   String _getTitle(int index) {
//     switch (index) {
//       case 0:
//         return "Dashboard";
//       case 1:
//         return "Programs";
//       case 2:
//         return "Members";
//       case 3:
//         return "Teachers";
//       case 4:
//         return "Students";
//       default:
//         return "Dashboard";
//     }
//   }
// }
//
// class _SidebarContent extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onTap;
//
//   const _SidebarContent({required this.selectedIndex, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         const DrawerHeader(
//           child: Text(
//             "Teacher Panel",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         _tile(Icons.dashboard, "Dashboard", 0),
//         _tile(Icons.school, "Programs", 1),
//         _tile(Icons.group, "Members", 2),
//         _tile(Icons.person, "Teachers", 3),
//         _tile(Icons.groups, "Students", 4),
//       ],
//     );
//   }
//
//   Widget _tile(IconData icon, String title, int index) {
//     return Builder(
//       builder: (context) {
//         return ListTile(
//           selected: selectedIndex == index,
//           leading: Icon(icon),
//           title: Text(title),
//           onTap: () => onTap(index),
//         );
//       },
//     );
//   }
// }
//
// // -----------------------------------------------------------------------------
// // SECTIONS & WIDGETS
// // -----------------------------------------------------------------------------
//
// class _DashboardHeader extends StatelessWidget {
//   final bool isMobile;
//   const _DashboardHeader({this.isMobile = false});
//
//   @override
//   Widget build(BuildContext context) {
//     if (isMobile) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Welcome back, Mr. John 👋',
//             style: Theme.of(
//               context,
//             ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Here is your daily summary.',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: AppTheme.getTextTertiary(context),
//             ),
//           ),
//         ],
//       );
//     }
//
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: AppTheme.spaceLg,
//         vertical: AppTheme.spaceMd,
//       ),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         border: Border(bottom: BorderSide(color: AppTheme.getBorder(context))),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Welcome back, Mr. John 👋',
//                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.event_available,
//                     size: 14,
//                     color: AppTheme.getTextTertiary(context),
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     '3 Classes Today',
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Icon(
//                     Icons.warning_amber_rounded,
//                     size: 14,
//                     color: AppTheme.warning,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     '12 Unmarked',
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: AppTheme.warning,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.notifications_none),
//               ),
//               const SizedBox(width: AppTheme.spaceMd),
//               ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: const Icon(Icons.add, size: 18),
//                 label: const Text('Create New'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).colorScheme.primary,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 16,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _MetricsSection extends StatelessWidget {
//   final bool isMobile;
//   const _MetricsSection({this.isMobile = false});
//
//   @override
//   Widget build(BuildContext context) {
//     // Return a Grid or Row based on layout
//     List<Widget> cards = [
//       const StatCard(
//         label: 'Total Students',
//         value: '142',
//         icon: Icons.people,
//         color: Colors.blue,
//         trend: '+12%',
//         trendUp: true,
//       ),
//       const StatCard(
//         label: 'Avg Performance',
//         value: '78%',
//         icon: Icons.bar_chart,
//         color: Colors.green,
//         trend: '+5%',
//         trendUp: true,
//       ),
//       const StatCard(
//         label: 'Unmarked',
//         value: '12',
//         icon: Icons.rate_review,
//         color: Colors.orange,
//         trend: '-2',
//         trendUp: false,
//       ), // Trend down is good for unmarked? Let's say false means red arrow down.
//       const StatCard(
//         label: 'Active Today',
//         value: '89%',
//         icon: Icons.verified_user,
//         color: Colors.teal,
//         trend: 'stable',
//         trendUp: true,
//       ),
//     ];
//
//     if (isMobile) {
//       return Column(
//         children: cards
//             .map(
//               (c) =>
//                   Padding(padding: const EdgeInsets.only(bottom: 12), child: c),
//             )
//             .toList(),
//       );
//     }
//
//     return Row(
//       children: cards
//           .map(
//             (c) => Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 16),
//                 child: c,
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }
// }
//
// class _ActionRequiredSection extends StatelessWidget {
//   final bool isMobile;
//   const _ActionRequiredSection({this.isMobile = false});
//
//   @override
//   Widget build(BuildContext context) {
//     final children = [
//       ActionRequiredCard(
//         title: 'Mark Assignments',
//         subtitle: '12 pending in "Python 101"',
//         icon: Icons.edit_note,
//         color: AppTheme.warning,
//         onTap: () {},
//       ),
//       if (isMobile)
//         const SizedBox(height: AppTheme.spaceMd)
//       else
//         const SizedBox(width: AppTheme.spaceMd),
//       ActionRequiredCard(
//         title: 'Missing Submissions',
//         subtitle: '4 students late for "Midterm"',
//         icon: Icons.access_time_filled,
//         color: AppTheme.error,
//         onTap: () {},
//       ),
//       if (isMobile)
//         const SizedBox(height: AppTheme.spaceMd)
//       else
//         const SizedBox(width: AppTheme.spaceMd),
//       const SmartInsightCard(
//         message: 'Engagement dropped in "Biology".',
//         trend: '-15%',
//         positive: false,
//       ),
//     ];
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'ACTION REQUIRED',
//           style: Theme.of(context).textTheme.labelSmall?.copyWith(
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1.2,
//             color: AppTheme.getTextTertiary(context),
//           ),
//         ),
//         const SizedBox(height: AppTheme.spaceMd),
//         isMobile
//             ? Column(children: children)
//             : Row(
//                 children:
//                     children
//                         .whereType<Widget>()
//                         .where(
//                           (w) =>
//                               w is ActionRequiredCard || w is SmartInsightCard,
//                         )
//                         .map((e) => Expanded(child: e))
//                         .expand(
//                           (element) => [
//                             element,
//                             const SizedBox(width: AppTheme.spaceMd),
//                           ],
//                         )
//                         .toList()
//                       ..removeLast(), // Quick hack to add spacing, but simpler to just rebuild list
//               ),
//       ],
//     );
//   }
// }
//
// class _TodaysClassesSection extends StatelessWidget {
//   const _TodaysClassesSection();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(AppTheme.spaceLg),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: AppTheme.borderRadiusLg,
//         border: Border.all(color: AppTheme.getBorder(context)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Today\'s Classes',
//                 style: Theme.of(
//                   context,
//                 ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//               ),
//               TextButton(onPressed: () {}, child: const Text('View All')),
//             ],
//           ),
//           const SizedBox(height: AppTheme.spaceMd),
//           ListView(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             children: [
//               ClassScheduleCard(
//                 className: 'Advanced Physics',
//                 time: '09:00 - 10:30',
//                 studentCount: 32,
//                 status: 'Live',
//                 onAction: () {},
//               ),
//               const SizedBox(height: AppTheme.spaceMd),
//               ClassScheduleCard(
//                 className: 'Introduction to Python',
//                 time: '11:00 - 12:30',
//                 studentCount: 45,
//                 status: 'Upcoming',
//                 onAction: () {},
//               ),
//               const SizedBox(height: AppTheme.spaceMd),
//               ClassScheduleCard(
//                 className: 'Data Structures',
//                 time: '14:00 - 15:30',
//                 studentCount: 28,
//                 status: 'Upcoming',
//                 onAction: () {},
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _LeaderboardSection extends StatelessWidget {
//   const _LeaderboardSection();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(AppTheme.spaceLg),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: AppTheme.borderRadiusLg,
//         border: Border.all(color: AppTheme.getBorder(context)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Top Students',
//                 style: Theme.of(
//                   context,
//                 ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//               ),
//               Icon(Icons.more_horiz, color: AppTheme.getTextTertiary(context)),
//             ],
//           ),
//           const SizedBox(height: AppTheme.spaceMd),
//           const LeaderboardRow(
//             rank: 1,
//             name: 'Emma Wilson',
//             score: '98%',
//             trendUp: true,
//           ),
//           const Divider(),
//           const LeaderboardRow(
//             rank: 2,
//             name: 'James Rodriguez',
//             score: '96%',
//             trendUp: true,
//           ),
//           const Divider(),
//           const LeaderboardRow(
//             rank: 3,
//             name: 'Sarah Chen',
//             score: '95%',
//             trendUp: false,
//           ),
//           const Divider(),
//           const LeaderboardRow(
//             rank: 4,
//             name: 'Michael Brown',
//             score: '92%',
//             trendUp: true,
//           ),
//           const Divider(),
//           const LeaderboardRow(
//             rank: 5,
//             name: 'Emily Davis',
//             score: '91%',
//             trendUp: true,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _StudentStatusSection extends StatelessWidget {
//   const _StudentStatusSection();
//
//   @override
//   Widget build(BuildContext context) {
//     // Placeholder for tabs
//     return Container(
//       height: 300,
//       padding: const EdgeInsets.all(AppTheme.spaceLg),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: AppTheme.borderRadiusLg,
//         border: Border.all(color: AppTheme.getBorder(context)),
//       ),
//       child: DefaultTabController(
//         length: 2,
//         child: Column(
//           children: [
//             TabBar(
//               labelColor: Theme.of(context).colorScheme.primary,
//               unselectedLabelColor: AppTheme.getTextTertiary(context),
//               indicatorColor: Theme.of(context).colorScheme.primary,
//               tabs: const [
//                 Tab(text: 'Unmarked'),
//                 Tab(text: 'Recently Marked'),
//               ],
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   Center(
//                     child: Text(
//                       'List of unmarked students...',
//                       style: TextStyle(
//                         color: AppTheme.getTextTertiary(context),
//                       ),
//                     ),
//                   ),
//                   Center(
//                     child: Text(
//                       'List of recently marked students...',
//                       style: TextStyle(
//                         color: AppTheme.getTextTertiary(context),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _CalendarSectionPlaceholder extends StatelessWidget {
//   const _CalendarSectionPlaceholder();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 300,
//       padding: const EdgeInsets.all(AppTheme.spaceLg),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: AppTheme.borderRadiusLg,
//         border: Border.all(color: AppTheme.getBorder(context)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Calendar',
//             style: Theme.of(
//               context,
//             ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: AppTheme.spaceMd),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).scaffoldBackgroundColor,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Center(
//                 child: Icon(Icons.calendar_month, size: 48, color: Colors.grey),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class Dash extends StatelessWidget {
//   const Dash({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = MediaQuery.of(context).size.width > 900;
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return SingleChildScrollView(
//           padding: EdgeInsets.all(isDesktop ? 32 : 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               _DashboardHeader(isMobile: !isDesktop),
//
//               const SizedBox(height: 24),
//
//               // Metrics Section
//               _ResponsiveMetrics(isDesktop: isDesktop),
//
//               const SizedBox(height: 24),
//
//               // Action Required
//               _ActionRequiredSection(isMobile: !isDesktop),
//
//               const SizedBox(height: 24),
//
//               // Classes + Leaderboard side by side on desktop
//               isDesktop
//                   ? Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Expanded(child: _TodaysClassesSection()),
//                         SizedBox(width: 24),
//                         Expanded(child: _LeaderboardSection()),
//                       ],
//                     )
//                   : Column(
//                       children: const [
//                         _TodaysClassesSection(),
//                         SizedBox(height: 24),
//                         _LeaderboardSection(),
//                       ],
//                     ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class _ResponsiveMetrics extends StatelessWidget {
//   final bool isDesktop;
//
//   const _ResponsiveMetrics({required this.isDesktop});
//
//   @override
//   Widget build(BuildContext context) {
//     if (isDesktop) {
//       return GridView.count(
//         crossAxisCount: 4,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         mainAxisSpacing: 16,
//         crossAxisSpacing: 16,
//         childAspectRatio: 1.8,
//         children: const [
//           _MetricCard(title: "Students", value: "120"),
//           _MetricCard(title: "Teachers", value: "8"),
//           _MetricCard(title: "Programs", value: "5"),
//           _MetricCard(title: "Attendance", value: "92%"),
//         ],
//       );
//     } else {
//       return Column(
//         children: const [
//           _MetricCard(title: "Students", value: "120"),
//           SizedBox(height: 16),
//           _MetricCard(title: "Teachers", value: "8"),
//           SizedBox(height: 16),
//           _MetricCard(title: "Programs", value: "5"),
//           SizedBox(height: 16),
//           _MetricCard(title: "Attendance", value: "92%"),
//         ],
//       );
//     }
//   }
// }
//
// class _MetricCard extends StatelessWidget {
//   final String title;
//   final String value;
//
//   const _MetricCard({required this.title, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(title, style: theme.textTheme.bodyMedium),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: theme.textTheme.headlineMedium?.copyWith(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
