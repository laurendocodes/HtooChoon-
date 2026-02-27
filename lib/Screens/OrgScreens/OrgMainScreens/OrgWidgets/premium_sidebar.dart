// import 'package:flutter/material.dart';
//
// import 'package:htoochoon_flutter/Providers/org_provider.dart';
// import 'package:htoochoon_flutter/Providers/theme_provider.dart';
// import 'package:htoochoon_flutter/Screens/MainLayout/main_scaffold.dart';
// import 'package:htoochoon_flutter/Theme/themedata.dart';
// import 'package:provider/provider.dart';
//
// /// Premium Sidebar Navigation
// /// Features:
// /// - Smooth transitions
// /// - Icon-first design
// /// - Clear visual hierarchy
// /// - Contextual user profile
// class PremiumSidebar extends StatelessWidget {
//   final int selectedIndex;
//   final ValueChanged<int> onDestinationSelected;
//   final bool isExtended;
//   final String? orgImageUrl;
//   final String orgName;
//   final String? role;
//
//   const PremiumSidebar({
//     super.key,
//     required this.selectedIndex,
//     required this.onDestinationSelected,
//     this.orgImageUrl,
//     required this.orgName,
//     required this.isExtended,
//     required this.role,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     // Define tabs per role
//     final List<Widget> navItems = role == 'teacher'
//         ? [
//             _NavItem(
//               icon: Icons.dashboard_outlined,
//               selectedIcon: Icons.dashboard,
//               label: 'Dashboard',
//               isSelected: selectedIndex == 0,
//               isExtended: isExtended,
//               onTap: () => onDestinationSelected(0),
//             ),
//             _NavItem(
//               icon: Icons.class_outlined,
//               selectedIcon: Icons.class_,
//               label: 'Classrooms',
//               isSelected: selectedIndex == 1,
//               isExtended: isExtended,
//               onTap: () => onDestinationSelected(1),
//             ),
//             _NavItem(
//               icon: Icons.people_outline,
//               selectedIcon: Icons.people,
//               label: 'Students',
//               isSelected: selectedIndex == 2,
//               isExtended: isExtended,
//               onTap: () => onDestinationSelected(2),
//             ),
//             _NavItem(
//               icon: Icons.bar_chart_outlined,
//               selectedIcon: Icons.bar_chart,
//               label: 'Performance',
//               isSelected: selectedIndex == 3,
//               isExtended: isExtended,
//               onTap: () => onDestinationSelected(3),
//             ),
//             _NavItem(
//               icon: Icons.book_outlined,
//               selectedIcon: Icons.book,
//               label: 'Courses',
//               isSelected: selectedIndex == 4,
//               isExtended: isExtended,
//               onTap: () => onDestinationSelected(4),
//             ),
//             _NavItem(
//               icon: Icons.calendar_today_outlined,
//               selectedIcon: Icons.calendar_today,
//               label: 'Calendar',
//               isSelected: selectedIndex == 5,
//               isExtended: isExtended,
//               onTap: () => onDestinationSelected(5),
//             ),
//             _NavItem(
//               icon: Icons.emoji_events_outlined,
//               selectedIcon: Icons.emoji_events,
//               label: 'Leaderboard',
//               isSelected: selectedIndex == 6,
//               isExtended: isExtended,
//               onTap: () => onDestinationSelected(6),
//             ),
//           ]
//         : [
//             // Admin / default tabs (your existing ones)
//             _NavItem(
//               icon: Icons.home_outlined,
//               selectedIcon: Icons.home,
//               label: 'Dashboard',
//               isSelected: selectedIndex == 0,
//               isExtended: isExtended,
//               onTap: () => onDestinationSelected(0),
//             ),
//             _NavItem(
//               icon: Icons.layers_outlined,
//               selectedIcon: Icons.layers,
//               label: 'Programs',
//               isSelected: selectedIndex == 1,
//               isExtended: isExtended,
//               onTap: () => onDestinationSelected(1),
//             ),
//             _NavItem(
//               icon: Icons.people_outline,
//               selectedIcon: Icons.people,
//               label: 'All Members',
//               isSelected: selectedIndex == 2,
//               isExtended: isExtended,
//               onTap: () => onDestinationSelected(2),
//             ),
//             _NavItem(
//               icon: Icons.school_outlined,
//               selectedIcon: Icons.school,
//               label: 'Teachers',
//               isSelected: selectedIndex == 3,
//               isExtended: isExtended,
//               onTap: () => onDestinationSelected(3),
//             ),
//             _NavItem(
//               icon: Icons.person_outline,
//               selectedIcon: Icons.person,
//               label: 'Students',
//               isSelected: selectedIndex == 4,
//               isExtended: isExtended,
//               onTap: () => onDestinationSelected(4),
//             ),
//           ];
//
//     return Container(
//       width: isExtended ? 280 : 72,
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         border: Border(
//           right: BorderSide(color: AppTheme.getBorder(context), width: 1),
//         ),
//       ),
//       child: Column(
//         children: [
//           _buildHeader(
//             context,
//             isExtended,
//             (orgImageUrl == null)
//                 ? 'assets/images/logos/main_logo.jpeg'
//                 : orgImageUrl.toString(),
//             orgName,
//           ),
//           const SizedBox(height: AppTheme.spaceLg),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceSm),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: navItems,
//               ),
//             ),
//           ),
//           const Divider(height: 1),
//           _buildFooter(context, isExtended, role.toString()),
//         ],
//       ),
//     );
//   }
// }
//
// Widget _buildHeader(
//   BuildContext context,
//   bool isExtended,
//   String orgImageUrl,
//   String orgName,
// ) {
//   return Container(
//     padding: EdgeInsets.all(isExtended ? AppTheme.spaceLg : AppTheme.spaceMd),
//     child: Row(
//       mainAxisAlignment: isExtended
//           ? MainAxisAlignment.start
//           : MainAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(AppTheme.spaceXs),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
//             ),
//             borderRadius: AppTheme.borderRadiusMd,
//           ),
//           child: (orgImageUrl == null)
//               ? const Icon(Icons.school, color: Colors.white, size: 24)
//               : Image.asset(orgImageUrl.toString(), height: 65),
//         ),
//         if (isExtended) ...[
//           const SizedBox(width: AppTheme.spaceSm),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   orgName,
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 Text(
//                   'Learning Platform',
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: AppTheme.getTextSecondary(context),
//                     fontSize: 11,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ],
//     ),
//   );
// }
//
// Widget _buildFooter(BuildContext context, bool isExtended, String role) {
//   final themeProvider = Provider.of<ThemeProvider>(context);
//   final orgProvider = Provider.of<OrgProvider>(context, listen: false);
//
//   return Padding(
//     padding: const EdgeInsets.all(AppTheme.spaceMd),
//     child: Column(
//       children: [
//         // Theme Toggle
//         _FooterButton(
//           icon: themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
//           label: themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
//           isExtended: isExtended,
//           onTap: () => themeProvider.toggleTheme(),
//           trailing: isExtended
//               ? Switch(
//                   value: themeProvider.isDarkMode,
//                   onChanged: (_) => themeProvider.toggleTheme(),
//                   activeColor: Theme.of(context).colorScheme.primary,
//                 )
//               : null,
//         ),
//
//         const SizedBox(height: AppTheme.spaceXs),
//
//         // Settings
//         _FooterButton(
//           icon: Icons.settings_outlined,
//           label: 'Settings',
//           isExtended: isExtended,
//           onTap: () {},
//         ),
//
//         const SizedBox(height: AppTheme.spaceMd),
//
//         // User Profile
//         _UserProfileCard(isExtended: isExtended, role: role),
//
//         const SizedBox(height: AppTheme.spaceMd),
//
//         // Exit Organization
//         _FooterButton(
//           icon: Icons.logout,
//           label: 'Exit Organization',
//           isExtended: isExtended,
//           onTap: () => orgProvider.leaveOrganization(),
//           color: AppTheme.warning,
//         ),
//       ],
//     ),
//   );
// }
//
// class _NavItem extends StatefulWidget {
//   final IconData icon;
//   final IconData selectedIcon;
//   final String label;
//   final bool isSelected;
//   final bool isExtended;
//   final VoidCallback onTap;
//
//   const _NavItem({
//     required this.icon,
//     required this.selectedIcon,
//     required this.label,
//     required this.isSelected,
//     required this.isExtended,
//     required this.onTap,
//   });
//
//   @override
//   State<_NavItem> createState() => _NavItemState();
// }
//
// class _NavItemState extends State<_NavItem> {
//   bool _isHovered = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final color = widget.isSelected
//         ? Theme.of(context).colorScheme.primary
//         : AppTheme.getTextSecondary(context);
//
//     final backgroundColor = widget.isSelected
//         ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
//         : _isHovered
//         ? AppTheme.getSurfaceVariant(context)
//         : Colors.transparent;
//
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 2),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: widget.onTap,
//             borderRadius: AppTheme.borderRadiusMd,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               padding: EdgeInsets.symmetric(
//                 horizontal: widget.isExtended
//                     ? AppTheme.spaceMd
//                     : AppTheme.spaceSm,
//                 vertical: AppTheme.spaceSm,
//               ),
//               decoration: BoxDecoration(
//                 color: backgroundColor,
//                 borderRadius: AppTheme.borderRadiusMd,
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     widget.isSelected ? widget.selectedIcon : widget.icon,
//                     color: color,
//                     size: 22,
//                   ),
//                   if (widget.isExtended) ...[
//                     const SizedBox(width: AppTheme.spaceSm),
//                     Expanded(
//                       child: Text(
//                         widget.label,
//                         overflow: TextOverflow.clip,
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: color,
//                           fontWeight: widget.isSelected
//                               ? FontWeight.w600
//                               : FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _FooterButton extends StatefulWidget {
//   final IconData icon;
//   final String label;
//   final bool isExtended;
//   final VoidCallback onTap;
//   final Color? color;
//   final Widget? trailing;
//
//   const _FooterButton({
//     required this.icon,
//     required this.label,
//     required this.isExtended,
//     required this.onTap,
//     this.color,
//     this.trailing,
//   });
//
//   @override
//   State<_FooterButton> createState() => _FooterButtonState();
// }
//
// class _FooterButtonState extends State<_FooterButton> {
//   bool _isHovered = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final color = widget.color ?? AppTheme.getTextSecondary(context);
//
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: widget.onTap,
//           borderRadius: AppTheme.borderRadiusMd,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             padding: EdgeInsets.symmetric(
//               horizontal: widget.isExtended
//                   ? AppTheme.spaceMd
//                   : AppTheme.spaceSm,
//               vertical: AppTheme.spaceSm,
//             ),
//             decoration: BoxDecoration(
//               color: _isHovered
//                   ? AppTheme.getSurfaceVariant(context)
//                   : Colors.transparent,
//               borderRadius: AppTheme.borderRadiusMd,
//             ),
//             child: Row(
//               children: [
//                 Icon(widget.icon, color: color, size: 20),
//                 if (widget.isExtended) ...[
//                   const SizedBox(width: AppTheme.spaceSm),
//                   Expanded(
//                     child: Text(
//                       widget.label,
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                         color: color,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//                 if (widget.trailing != null) widget.trailing!,
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _UserProfileCard extends StatelessWidget {
//   final bool isExtended;
//   final String? role;
//
//   const _UserProfileCard({required this.isExtended, required this.role});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(isExtended ? AppTheme.spaceSm : AppTheme.spaceXs),
//       decoration: BoxDecoration(
//         color: AppTheme.getSurfaceVariant(context),
//         borderRadius: AppTheme.borderRadiusMd,
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
//               ),
//               borderRadius: BorderRadius.circular(AppTheme.radiusMd),
//             ),
//             child: const Center(
//               child: Text(
//                 'AD',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//           if (isExtended) ...[
//             const SizedBox(width: AppTheme.spaceSm),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     (role == 'teacher') ? 'Teacher' : 'Admin User',
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Text(
//                     'View profile',
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: Theme.of(context).colorScheme.primary,
//                       fontSize: 11,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.chevron_right,
//               size: 16,
//               color: AppTheme.getTextTertiary(context),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
