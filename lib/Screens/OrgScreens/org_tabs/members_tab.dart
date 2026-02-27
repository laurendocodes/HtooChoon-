import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:provider/provider.dart';

//
// class MemberFilterScreen extends StatelessWidget {
//   const MemberFilterScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<OrgProvider>();
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Members')),
//       body: Column(
//         children: [
//           const SizedBox(height: 12),
//
//           /// Filter Chips
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _filterChip(context, 'All', MemberFilter.all),
//               _filterChip(context, 'Admin', MemberFilter.owner),
//               _filterChip(context, 'Teachers', MemberFilter.teacher),
//               _filterChip(context, 'Students', MemberFilter.student),
//             ],
//           ),
//
//           const SizedBox(height: 12),
//
//           /// Members List
//           Expanded(
//             child: provider.isMembersLoading
//                 ? Center(child: const CircularProgressIndicator())
//                 : provider.members.isEmpty
//                 ? const Center(child: Text('No members found'))
//                 : ListView.builder(
//                     itemCount: provider.members.length,
//                     itemBuilder: (_, index) {
//                       return MemberCard(member: provider.members[index]);
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _filterChip(BuildContext context, String label, MemberFilter filter) {
//     final provider = context.watch<OrgProvider>();
//     final isSelected = provider.filter == filter;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 6),
//       child: ChoiceChip(
//         label: Text(
//           label,
//           style: isSelected
//               ? TextStyle(color: Theme.of(context).colorScheme.inversePrimary)
//               : TextStyle(color: Theme.of(context).colorScheme.tertiary),
//         ),
//         selected: isSelected,
//         onSelected: (_) => context.read<OrgProvider>().setFilter(filter),
//       ),
//     );
//   }
// }
//
// class MemberCard extends StatelessWidget {
//   final Map<String, dynamic> member;
//
//   const MemberCard({super.key, required this.member});
//
//   @override
//   Widget build(BuildContext context) {
//     final role = member['role'] ?? 'member';
//
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Row(
//           children: [
//             /// Profile Picture
//             CircleAvatar(
//               radius: 26,
//               backgroundImage: member['photoUrl'] != null
//                   ? NetworkImage(member['photoUrl'])
//                   : null,
//               child: member['photoUrl'] == null
//                   ? const Icon(Icons.person, size: 30)
//                   : null,
//             ),
//
//             const SizedBox(width: 14),
//
//             /// Info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     member['name'] ?? member['email'] ?? 'Unknown',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//
//                   const SizedBox(height: 4),
//
//                   Text(
//                     role.toUpperCase(),
//                     style: TextStyle(
//                       color: _roleColor(role),
//                       fontWeight: FontWeight.w600,
//                       fontSize: 12,
//                     ),
//                   ),
//
//                   if (role == 'teacher' && member['specialization'] != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 6),
//                       child: Text(
//                         'Instructor • ${member['specialization']}',
//                         style: const TextStyle(fontSize: 13),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//
//             /// Optional action
//             if (role == 'teacher')
//               Icon(Icons.school, color: Colors.blue.shade400),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Color _roleColor(String role) {
//     switch (role) {
//       case 'teacher':
//         return Colors.blue;
//       case 'admin':
//         return Colors.orange;
//       case 'student':
//         return Colors.green;
//       case 'owner':
//         return Colors.deepPurple;
//       default:
//         return Colors.grey;
//     }
//   }
// }
