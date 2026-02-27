import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';

import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/OrgWidgets/create_widgets.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/OrgWidgets/org_dashboard_widgets.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/invitation_screen.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/org_dashboard_wrapper.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:provider/provider.dart';

//
// class PremiumOrgDashboardScreen extends StatefulWidget {
//   const PremiumOrgDashboardScreen({super.key});
//
//   @override
//   State<PremiumOrgDashboardScreen> createState() =>
//       _PremiumOrgDashboardScreenState();
// }
//
// class _PremiumOrgDashboardScreenState extends State<PremiumOrgDashboardScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final orgProvider = Provider.of<OrgProvider>(context);
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: CustomScrollView(
//         slivers: [
//           // Header
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(
//                 AppTheme.space3xl,
//                 AppTheme.space2xl,
//                 AppTheme.space3xl,
//                 AppTheme.spaceLg,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Dashboard',
//                     style: Theme.of(context).textTheme.displayLarge,
//                   ),
//                   const SizedBox(height: AppTheme.spaceXs),
//                   Text(
//                     'Manage your organization, courses, and members',
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: AppTheme.getTextSecondary(context),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Stats Cards
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: AppTheme.space3xl),
//             sliver: SliverToBoxAdapter(
//               child: StatsGrid(
//                 stats: [
//                   StatData(
//                     label: 'Active Classes',
//                     value: '8',
//                     icon: Icons.class_outlined,
//                     color: const Color(0xFF3B82F6),
//                     trend: '+2 this week',
//                     onTap: () => _navigateToInvitations(context),
//                   ),
//                   StatData(
//                     label: 'Total Students',
//                     value: '124',
//                     icon: Icons.people_outline,
//                     color: const Color(0xFF10B981),
//                     trend: '+12 this month',
//                     onTap: () => _navigateToInvitations(context),
//                   ),
//                   StatData(
//                     label: 'Pending Invites',
//                     value: '3',
//                     icon: Icons.mail_outline,
//                     color: const Color(0xFFF59E0B),
//                     trend: 'Needs attention',
//                     onTap: () => _navigateToInvitations(context),
//                   ),
//                   StatData(
//                     label: 'Active Teachers',
//                     value: '12',
//                     icon: Icons.school_outlined,
//                     color: const Color(0xFF8B5CF6),
//                     trend: 'All verified',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SliverToBoxAdapter(child: SizedBox(height: AppTheme.space3xl)),
//
//           // Quick Actions Section
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: AppTheme.space3xl,
//               ),
//               child: Row(
//                 children: [
//                   Text(
//                     'Quick Actions',
//                     style: Theme.of(context).textTheme.headlineSmall,
//                   ),
//                   const Spacer(),
//                   TextButton.icon(
//                     onPressed: () {},
//                     icon: const Icon(Icons.tune, size: 18),
//                     label: const Text('Customize'),
//                     style: TextButton.styleFrom(
//                       foregroundColor: AppTheme.getTextSecondary(context),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spaceLg)),
//
//           // Quick Actions Grid
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: AppTheme.space3xl),
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                 maxCrossAxisExtent: 280,
//                 mainAxisSpacing: AppTheme.spaceMd,
//                 crossAxisSpacing: AppTheme.spaceMd,
//                 childAspectRatio: 1.4,
//               ),
//               delegate: SliverChildListDelegate([
//                 ActionCard(
//                   icon: Icons.create_new_folder_outlined,
//                   title: 'Create Program',
//                   description: 'Set up a new learning program',
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
//                   ),
//                   onTap: () => showCreateProgramDialog(context, orgProvider),
//                 ),
//                 ActionCard(
//                   icon: Icons.library_books_outlined,
//                   title: 'Add Course',
//                   description: 'Create a new course module',
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF10B981), Color(0xFF059669)],
//                   ),
//                   onTap: () => showCreateDialog(context, 'Course', orgProvider),
//                 ),
//                 ActionCard(
//                   icon: Icons.person_add_outlined,
//                   title: 'Invite Teacher',
//                   description: 'Add a new instructor',
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
//                   ),
//                   onTap: () => showInviteDialog(context, orgProvider),
//                 ),
//                 ActionCard(
//                   icon: Icons.group_add_outlined,
//                   title: 'Invite Students',
//                   description: 'Bulk invite students',
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
//                   ),
//                   onTap: () => showInviteStudentDialog(context, orgProvider),
//                 ),
//               ]),
//             ),
//           ),
//
//           const SliverToBoxAdapter(child: SizedBox(height: AppTheme.space3xl)),
//
//           // Recent Activity Section
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: AppTheme.space3xl,
//               ),
//               child: Text(
//                 'Recent Activity',
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//             ),
//           ),
//
//           const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spaceLg)),
//
//           // Activity List
//           SliverPadding(
//             padding: const EdgeInsets.fromLTRB(
//               AppTheme.space3xl,
//               0,
//               AppTheme.space3xl,
//               AppTheme.space3xl,
//             ),
//             sliver: SliverToBoxAdapter(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).cardColor,
//                   borderRadius: AppTheme.borderRadiusLg,
//                   border: Border.all(
//                     color: AppTheme.getBorder(context),
//                     width: 1,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     ActivityItem(
//                       icon: Icons.person_add,
//                       iconColor: const Color(0xFF10B981),
//                       title: 'New teacher joined',
//                       subtitle: 'John Doe accepted the invitation',
//                       time: '2 hours ago',
//                     ),
//                     Divider(height: 1, color: AppTheme.getBorder(context)),
//                     ActivityItem(
//                       icon: Icons.class_,
//                       iconColor: const Color(0xFF3B82F6),
//                       title: 'Class created',
//                       subtitle: 'Introduction to Python - Batch A',
//                       time: '5 hours ago',
//                     ),
//                     Divider(height: 1, color: AppTheme.getBorder(context)),
//                     ActivityItem(
//                       icon: Icons.assignment_turned_in,
//                       iconColor: const Color(0xFF8B5CF6),
//                       title: 'Assignment submitted',
//                       subtitle: '24 students completed Math Quiz 3',
//                       time: '1 day ago',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _navigateToInvitations(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const InvitationsScreen()),
//     );
//   }
// }
