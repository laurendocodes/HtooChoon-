import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:htoochoon_flutter/Providers/structure_provider.dart';
import 'package:htoochoon_flutter/Widgets/role_guard.dart';
import 'package:provider/provider.dart';

//
// /// Example screen demonstrating RBAC usage
// class OrgManagementScreen extends StatelessWidget {
//   const OrgManagementScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final orgProvider = Provider.of<OrgProvider>(context);
//     final structureProvider = Provider.of<StructureProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(orgProvider.currentOrgName ?? 'Organization'),
//         actions: [
//           // Only owners and admins can see settings
//           RoleGuard(
//             allowedRoles: PermissionHelper.adminRoles,
//             child: IconButton(
//               icon: const Icon(Icons.settings),
//               onPressed: () {
//                 // Navigate to settings
//               },
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Admin-only section
//             RoleGuard(
//               allowedRoles: PermissionHelper.adminRoles,
//               child: Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Admin Controls',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       ElevatedButton.icon(
//                         onPressed: () =>
//                             _showInviteMemberDialog(context, orgProvider),
//                         icon: const Icon(Icons.person_add),
//                         label: const Text('Invite Member'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Teachers and above can create programs
//             RoleGuard(
//               allowedRoles: PermissionHelper.teacherRoles,
//               child: Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Content Management',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Wrap(
//                         spacing: 8,
//                         children: [
//                           ElevatedButton.icon(
//                             onPressed: () => _showCreateProgramDialog(
//                               context,
//                               orgProvider,
//                               structureProvider,
//                             ),
//                             icon: const Icon(Icons.add),
//                             label: const Text('Create Program'),
//                           ),
//                           ElevatedButton.icon(
//                             onPressed: () {
//                               // Create course
//                             },
//                             icon: const Icon(Icons.add),
//                             label: const Text('Create Course'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Everyone can see this
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         const Text('My Role: ', style: TextStyle(fontSize: 16)),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Theme.of(
//                               context,
//                             ).primaryColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             (orgProvider.role ?? 'None').toUpperCase(),
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Permissions: ${_getPermissionDescription(orgProvider.role)}',
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _getPermissionDescription(String? role) {
//     if (role == null) return 'None';
//     if (PermissionHelper.isOwner(role)) {
//       return 'Full control over organization';
//     }
//     if (PermissionHelper.canManageOrg(role)) {
//       return 'Can manage members and settings';
//     }
//     if (PermissionHelper.canCreateContent(role)) {
//       return 'Can create and manage content';
//     }
//     return 'Can view and participate in classes';
//   }
//
//   void _showInviteMemberDialog(BuildContext context, OrgProvider provider) {
//     final emailController = TextEditingController();
//     String selectedRole = 'student';
//
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: const Text('Invite Member'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email Address',
//                   prefixIcon: Icon(Icons.email),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 value: selectedRole,
//                 decoration: const InputDecoration(
//                   labelText: 'Role',
//                   prefixIcon: Icon(Icons.badge),
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: 'student', child: Text('Student')),
//                   DropdownMenuItem(value: 'teacher', child: Text('Teacher')),
//                   DropdownMenuItem(
//                     value: 'moderator',
//                     child: Text('Moderator'),
//                   ),
//                   DropdownMenuItem(value: 'admin', child: Text('Admin')),
//                 ],
//                 onChanged: (value) {
//                   setState(() => selectedRole = value!);
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await provider.inviteMember(
//                     emailController.text.trim(),
//                     'teacher',
//                     title: 'Invitation to join our LMS',
//                     body:
//                         'You have been invited to join our organization as a teacher.',
//                   );
//
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Invitation Sent!")),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         e.toString().contains('not found')
//                             ? 'User with this email does not exist'
//                             : 'Failed to send invitation',
//                       ),
//                     ),
//                   );
//                 }
//               },
//               child: const Text("Send Invite"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showCreateProgramDialog(
//     BuildContext context,
//     OrgProvider orgProvider,
//     StructureProvider structureProvider,
//   ) {
//     final nameController = TextEditingController();
//     final descController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Create Program'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Program Name',
//                 hintText: 'e.g. Computer Science',
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: descController,
//               decoration: const InputDecoration(labelText: 'Description'),
//               maxLines: 3,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (nameController.text.isNotEmpty &&
//                   orgProvider.currentOrgId != null) {
//                 try {
//                   await structureProvider.createProgram(
//                     orgProvider.currentOrgId!,
//                     nameController.text,
//                     descController.text,
//                   );
//                   if (context.mounted) {
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Program created successfully'),
//                       ),
//                     );
//                   }
//                 } catch (e) {
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Error: ${e.toString()}')),
//                     );
//                   }
//                 }
//               }
//             },
//             child: const Text('Create'),
//           ),
//         ],
//       ),
//     );
//   }
// }
