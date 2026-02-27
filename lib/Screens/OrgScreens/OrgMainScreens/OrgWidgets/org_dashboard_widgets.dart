import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';

//
// void showCreateProgramDialog(BuildContext context, OrgProvider provider) {
//   final nameController = TextEditingController();
//   final descController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//
//   showGeneralDialog(
//     context: context,
//     barrierDismissible: true,
//     barrierLabel: '',
//     transitionDuration: const Duration(milliseconds: 300),
//     pageBuilder: (context, anim1, anim2) {
//       return Center(
//         child: Container(
//           width: MediaQuery.of(context).size.width > 600
//               ? 500
//               : double.infinity,
//           margin: const EdgeInsets.symmetric(horizontal: 20),
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.surface,
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(
//                   Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.1,
//                 ),
//                 blurRadius: 20,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Material(
//             // Required for TextFields inside Dialog
//             color: Colors.transparent,
//             child: Form(
//               key: formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Create New Program",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: Icon(
//                           Icons.close,
//                           color: Theme.of(
//                             context,
//                           ).colorScheme.onSurface.withOpacity(0.5),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Group your courses into a high-level program like 'Pre-GED' or 'Computer Science'.",
//                     style: TextStyle(
//                       color: Theme.of(
//                         context,
//                       ).colorScheme.onSurface.withOpacity(0.6),
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Program Name Field
//                   Text(
//                     "Program Name",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: nameController,
//                     validator: (v) => v!.isEmpty ? "Name is required" : null,
//                     decoration: const InputDecoration(
//                       hintText: "e.g. Computer Science Department",
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Description Field
//                   Text(
//                     "Description",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: descController,
//                     maxLines: 3,
//                     decoration: const InputDecoration(
//                       hintText: "What is this program about?",
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//
//                   // Actions
//                   SizedBox(
//                     width: double.infinity,
//                     height: 54,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         if (formKey.currentState!.validate()) {
//                           try {
//                             await provider.createProgram(
//                               nameController.text,
//                               descController.text,
//                             );
//                             print("calling");
//                             if (provider.isLoading) {
//                               CircularProgressIndicator();
//                             } else {
//                               if (context.mounted) Navigator.pop(context);
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                     "Program created successfully!",
//                                   ),
//                                 ),
//                               );
//                             }
//                           } catch (e) {
//                             // Handle error
//                           }
//                         }
//                       },
//                       child: provider.isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text(
//                               "Create Program",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     },
//     transitionBuilder: (context, anim1, anim2, child) {
//       return FadeTransition(
//         opacity: anim1,
//         child: ScaleTransition(
//           scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
//           child: child,
//         ),
//       );
//     },
//   );
// }
//
// /// Show dialog to invite a student to the organization
// /// Students need to be assigned to specific courses/classes
// void showInviteStudentDialog(BuildContext context, OrgProvider provider) {
//   final emailController = TextEditingController();
//   Map<String, dynamic>? selectedUser;
//   String? selectedClassId;
//   List<String> selectedCourseIds = [];
//   bool isSearching = false;
//   List<Map<String, dynamic>> suggestions = [];
//
//   showDialog(
//     context: context,
//     builder: (ctx) => StatefulBuilder(
//       builder: (ctx, setState) {
//         final bool isFormValid =
//             selectedUser != null &&
//             selectedCourseIds.isNotEmpty &&
//             (selectedCourseIds.length > 1 ||
//                 (selectedCourseIds.length == 1 && selectedClassId != null));
//         Future<void> onSearch(String value) async {
//           setState(() {
//             isSearching = true;
//             selectedUser = null;
//           });
//
//           final result = await provider.searchUsersByEmail(value.trim());
//
//           if (ctx.mounted) {
//             setState(() {
//               suggestions = result;
//               isSearching = false;
//             });
//           }
//         }
//
//         return AlertDialog(
//           title: const Text('Invite Student'),
//           content: SizedBox(
//             width: 500,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Email Search
//                   TextField(
//                     controller: emailController,
//                     onChanged: onSearch,
//                     decoration: InputDecoration(
//                       labelText: 'Student Email',
//                       hintText: 'search@example.com',
//                       suffixIcon: isSearching
//                           ? const Padding(
//                               padding: EdgeInsets.all(AppTheme.spaceSm),
//                               child: SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                 ),
//                               ),
//                             )
//                           : const Icon(Icons.search, size: 20),
//                     ),
//                   ),
//
//                   // Search Results
//                   if (suggestions.isNotEmpty) ...[
//                     const SizedBox(height: AppTheme.spaceMd),
//                     Container(
//                       constraints: const BoxConstraints(maxHeight: 200),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: AppTheme.getBorder(context)),
//                         borderRadius: AppTheme.borderRadiusMd,
//                       ),
//                       child: ListView.separated(
//                         shrinkWrap: true,
//                         itemCount: suggestions.length,
//                         separatorBuilder: (_, __) => Divider(
//                           height: 1,
//                           color: AppTheme.getBorder(context),
//                         ),
//                         itemBuilder: (_, i) {
//                           final user = suggestions[i];
//                           return ListTile(
//                             leading: CircleAvatar(
//                               backgroundColor: Theme.of(
//                                 context,
//                               ).colorScheme.primary.withOpacity(0.1),
//                               child: Text(
//                                 user['email'][0].toUpperCase(),
//                                 style: TextStyle(
//                                   color: Theme.of(context).colorScheme.primary,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                             title: Text(user['email']),
//                             subtitle: Text(
//                               user['name'] ?? user['username'] ?? '',
//                               style: Theme.of(context).textTheme.bodySmall,
//                             ),
//                             onTap: () {
//                               setState(() {
//                                 selectedUser = user;
//                                 emailController.text = user['email'];
//                                 suggestions.clear();
//                               });
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//
//                   // Only show course/class selection if user is selected
//                   if (selectedUser != null) ...[
//                     const SizedBox(height: AppTheme.spaceLg),
//
//                     // Divider with text
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Divider(color: AppTheme.getBorder(context)),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: AppTheme.spaceSm,
//                           ),
//                           child: Text(
//                             'ENROLLMENT OPTIONS',
//                             style: Theme.of(context).textTheme.labelSmall
//                                 ?.copyWith(
//                                   color: AppTheme.getTextTertiary(context),
//                                   letterSpacing: 1.2,
//                                 ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Divider(color: AppTheme.getBorder(context)),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: AppTheme.spaceLg),
//
//                     // Course Selection
//                     StreamBuilder<QuerySnapshot>(
//                       stream: FirebaseFirestore.instance
//                           .collection('organizations')
//                           .doc(provider.currentOrgId)
//                           .collection('courses')
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         if (!snapshot.hasData) {
//                           return const LinearProgressIndicator();
//                         }
//
//                         final courses = snapshot.data!.docs;
//
//                         if (courses.isEmpty) {
//                           return Container(
//                             padding: const EdgeInsets.all(AppTheme.spaceMd),
//                             decoration: BoxDecoration(
//                               color: AppTheme.warning.withOpacity(0.1),
//                               borderRadius: AppTheme.borderRadiusMd,
//                               border: Border.all(
//                                 color: AppTheme.warning.withOpacity(0.3),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.info_outline,
//                                   size: 20,
//                                   color: AppTheme.warning,
//                                 ),
//                                 const SizedBox(width: AppTheme.spaceSm),
//                                 Expanded(
//                                   child: Text(
//                                     'No courses available. Create courses first.',
//                                     style: Theme.of(context).textTheme.bodySmall
//                                         ?.copyWith(color: AppTheme.warning),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }
//
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Select Courses (Optional)',
//                               style: Theme.of(context).textTheme.labelLarge
//                                   ?.copyWith(fontWeight: FontWeight.w600),
//                             ),
//                             const SizedBox(height: AppTheme.spaceXs),
//                             Text(
//                               'Student will have access to selected courses',
//                               style: Theme.of(context).textTheme.bodySmall
//                                   ?.copyWith(
//                                     color: AppTheme.getTextSecondary(context),
//                                   ),
//                             ),
//                             const SizedBox(height: AppTheme.spaceSm),
//                             Container(
//                               constraints: const BoxConstraints(maxHeight: 200),
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: AppTheme.getBorder(context),
//                                 ),
//                                 borderRadius: AppTheme.borderRadiusMd,
//                               ),
//                               child: ListView.builder(
//                                 shrinkWrap: true,
//                                 itemCount: courses.length,
//                                 itemBuilder: (_, index) {
//                                   final course = courses[index];
//                                   final courseId = course.id;
//                                   final isSelected = selectedCourseIds.contains(
//                                     courseId,
//                                   );
//
//                                   return CheckboxListTile(
//                                     value: isSelected,
//                                     // onChanged: (checked) {
//                                     //   setState(() {
//                                     //     if (checked == true) {
//                                     //       selectedCourseIds.add(courseId);
//                                     //     } else {
//                                     //       selectedCourseIds.remove(courseId);
//                                     //     }
//                                     //   });
//                                     // },
//                                     onChanged: (checked) {
//                                       setState(() {
//                                         if (checked == true) {
//                                           selectedCourseIds.add(courseId);
//                                         } else {
//                                           selectedCourseIds.remove(courseId);
//                                         }
//
//                                         selectedClassId = null;
//                                       });
//                                     },
//
//                                     title: Text(
//                                       course['title'] ?? 'Untitled Course',
//                                       style: Theme.of(
//                                         context,
//                                       ).textTheme.bodyMedium,
//                                     ),
//                                     subtitle: Text(
//                                       course['description'] ?? '',
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodySmall
//                                           ?.copyWith(
//                                             color: AppTheme.getTextSecondary(
//                                               context,
//                                             ),
//                                           ),
//                                     ),
//                                     controlAffinity:
//                                         ListTileControlAffinity.leading,
//                                     dense: true,
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//
//                     const SizedBox(height: AppTheme.spaceLg),
//
//                     if (selectedCourseIds.length == 1) ...[
//                       StreamBuilder<QuerySnapshot>(
//                         stream: FirebaseFirestore.instance
//                             .collection('organizations')
//                             .doc(provider.currentOrgId)
//                             .collection('classes')
//                             .where(
//                               'courseId',
//                               isEqualTo: selectedCourseIds.first,
//                             )
//                             .snapshots(),
//                         builder: (context, snapshot) {
//                           if (!snapshot.hasData) {
//                             return const SizedBox.shrink();
//                           }
//
//                           final classes = snapshot.data!.docs;
//
//                           if (classes.isEmpty) {
//                             return const SizedBox.shrink();
//                           }
//
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Select Specific Class (required) ',
//                                 style: Theme.of(context).textTheme.labelLarge
//                                     ?.copyWith(fontWeight: FontWeight.w600),
//                               ),
//                               const SizedBox(height: AppTheme.spaceXs),
//                               Text(
//                                 'student will have access to selected class',
//                                 style: Theme.of(context).textTheme.bodySmall
//                                     ?.copyWith(
//                                       color: AppTheme.getTextSecondary(context),
//                                     ),
//                               ),
//                               const SizedBox(height: AppTheme.spaceSm),
//                               DropdownButtonFormField<String>(
//                                 value: selectedClassId,
//                                 decoration: const InputDecoration(
//                                   labelText: 'Class',
//                                   hintText: 'Select a class',
//                                 ),
//                                 items: classes.map((doc) {
//                                   return DropdownMenuItem(
//                                     value: doc.id,
//                                     child: Text(doc['name'] ?? 'Untitled'),
//                                   );
//                                 }).toList(),
//                                 onChanged: (value) {
//                                   setState(() => selectedClassId = value);
//                                   // print('User: $selectedUser');
//                                   // print('Courses: $selectedCourseIds');
//                                   // print('Class: $selectedClassId');
//                                   // print("isformvalid ${isFormValid}");
//                                 },
//                               ),
//                               const SizedBox(height: AppTheme.spaceMd),
//                             ],
//                           );
//                         },
//                       ),
//                     ],
//                   ],
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: const Text('Cancel'),
//             ),
//             const SizedBox(width: AppTheme.spaceXs),
//             ElevatedButton(
//               onPressed: (isFormValid == false || provider.isLoading)
//                   ? null
//                   : () async {
//                       try {
//                         await provider.inviteStudent(
//                           selectedUser!['email'],
//                           classId: selectedClassId.toString(),
//                           title: 'Invitation to join our Learning Platform',
//                           body:
//                               'You have been invited to join our organization as a student.',
//                         );
//
//                         if (!ctx.mounted) return;
//                         Navigator.pop(ctx);
//
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               selectedCourseIds.length > 1
//                                   ? 'Student invited with ${selectedCourseIds.length} courses!'
//                                   : 'Student invited successfully!',
//                             ),
//                           ),
//                         );
//                       } catch (e) {
//                         if (!ctx.mounted) return;
//                         ScaffoldMessenger.of(
//                           context,
//                         ).showSnackBar(SnackBar(content: Text(e.toString())));
//                       }
//                     },
//               child: provider.isLoading
//                   ? const SizedBox(
//                       height: 18,
//                       width: 18,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     )
//                   : const Text('Send Invite'),
//             ),
//           ],
//         );
//       },
//     ),
//   );
// }
//
// void showInviteDialog(BuildContext context, OrgProvider provider) {
//   final emailController = TextEditingController();
//   List<Map<String, dynamic>> suggestions = [];
//   Map<String, dynamic>? selectedUser;
//   bool isSearching = false;
//
//   showDialog(
//     context: context,
//     builder: (ctx) => StatefulBuilder(
//       builder: (ctx, setState) {
//         Future<void> onSearch(String value) async {
//           setState(() {
//             isSearching = true;
//             selectedUser = null;
//           });
//
//           final result = await provider.searchUsersByEmail(value.trim());
//
//           if (ctx.mounted) {
//             setState(() {
//               suggestions = result;
//               isSearching = false;
//             });
//           }
//         }
//
//         return AlertDialog(
//           title: const Text("Invite Teacher"),
//           content: SizedBox(
//             width: 400,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextField(
//                   controller: emailController,
//                   onChanged: onSearch,
//                   decoration: InputDecoration(
//                     labelText: "Teacher Email",
//                     hintText: "search@example.com",
//                     suffixIcon: isSearching
//                         ? const Padding(
//                             padding: EdgeInsets.all(AppTheme.spaceSm),
//                             child: SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(strokeWidth: 2),
//                             ),
//                           )
//                         : const Icon(Icons.search),
//                   ),
//                 ),
//                 if (suggestions.isNotEmpty) ...[
//                   const SizedBox(height: AppTheme.spaceMd),
//                   Container(
//                     constraints: const BoxConstraints(maxHeight: 200),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: AppTheme.getBorder(context)),
//                       borderRadius: AppTheme.borderRadiusMd,
//                     ),
//                     child: ListView.separated(
//                       shrinkWrap: true,
//                       itemCount: suggestions.length,
//                       separatorBuilder: (_, __) => Divider(
//                         height: 1,
//                         color: AppTheme.getBorder(context),
//                       ),
//                       itemBuilder: (_, i) {
//                         final user = suggestions[i];
//                         return ListTile(
//                           leading: CircleAvatar(
//                             backgroundColor: Theme.of(
//                               context,
//                             ).colorScheme.primary.withOpacity(0.1),
//                             child: Text(
//                               user['email'][0].toUpperCase(),
//                               style: TextStyle(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                           title: Text(user['email']),
//                           onTap: () {
//                             setState(() {
//                               selectedUser = user;
//                               emailController.text = user['email'];
//                               suggestions.clear();
//                             });
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: const Text("Cancel"),
//             ),
//             const SizedBox(width: AppTheme.spaceXs),
//             ElevatedButton(
//               onPressed: selectedUser == null || provider.isLoading
//                   ? null
//                   : () async {
//                       try {
//                         await provider.inviteMember(
//                           selectedUser!['email'],
//                           'teacher',
//                           title: 'Invitation to join our LMS',
//                           body:
//                               'You have been invited to join our organization as a teacher.',
//                         );
//
//                         if (!ctx.mounted) return;
//                         Navigator.pop(ctx);
//
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Invitation sent successfully!"),
//                           ),
//                         );
//                       } catch (e) {
//                         if (!ctx.mounted) return;
//                         ScaffoldMessenger.of(
//                           context,
//                         ).showSnackBar(SnackBar(content: Text(e.toString())));
//                       }
//                     },
//               child: provider.isLoading
//                   ? const SizedBox(
//                       height: 18,
//                       width: 18,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     )
//                   : const Text("Send Invite"),
//             ),
//           ],
//         );
//       },
//     ),
//   );
// }
//
// void showCreateDialog(BuildContext context, String type, OrgProvider provider) {
//   final titleController = TextEditingController();
//   final descController = TextEditingController();
//   final priceController = TextEditingController();
//   final durationController = TextEditingController();
//   final classesController = TextEditingController();
//   final seatsController = TextEditingController();
//
//   String? selectedProgramId;
//   String selectedLevel = 'Beginner';
//   String selectedCategory = 'Computer Science';
//
//   final List<String> categories = [
//     'Computer Science',
//     'Math',
//     'Architecture',
//     'Design',
//     'Business',
//   ];
//
//   final List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];
//
//   showDialog(
//     context: context,
//     builder: (ctx) => StatefulBuilder(
//       builder: (_, setState) {
//         bool isCreating = false;
//
//         return AlertDialog(
//           title: Text("Create New $type"),
//           content: SizedBox(
//             width: 500,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   TextField(
//                     controller: titleController,
//                     decoration: InputDecoration(
//                       labelText: type == "Program"
//                           ? "Program Name"
//                           : "Course Title",
//                       hintText: "Enter a descriptive name",
//                     ),
//                   ),
//                   const SizedBox(height: AppTheme.spaceMd),
//                   TextField(
//                     controller: descController,
//                     maxLines: 3,
//                     decoration: const InputDecoration(
//                       labelText: "Description",
//                       hintText: "What will students learn?",
//                     ),
//                   ),
//                   if (type == "Course") ...[
//                     const SizedBox(height: AppTheme.spaceMd),
//                     StreamBuilder<QuerySnapshot>(
//                       stream: FirebaseFirestore.instance
//                           .collection('organizations')
//                           .doc(provider.currentOrgId)
//                           .collection('programs')
//                           .snapshots(),
//                       builder: (_, snapshot) {
//                         if (!snapshot.hasData) {
//                           return const LinearProgressIndicator();
//                         }
//                         return DropdownButtonFormField<String>(
//                           value: selectedProgramId,
//                           decoration: const InputDecoration(
//                             labelText: "Program (Optional)",
//                           ),
//                           items: snapshot.data!.docs.map((doc) {
//                             return DropdownMenuItem(
//                               value: doc.id,
//                               child: Text(doc['name']),
//                             );
//                           }).toList(),
//                           onChanged: (v) =>
//                               setState(() => selectedProgramId = v),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: AppTheme.spaceMd),
//                     DropdownButtonFormField<String>(
//                       value: selectedCategory,
//                       decoration: const InputDecoration(labelText: "Category"),
//                       items: categories
//                           .map(
//                             (c) => DropdownMenuItem(value: c, child: Text(c)),
//                           )
//                           .toList(),
//                       onChanged: (v) => setState(() => selectedCategory = v!),
//                     ),
//                     const SizedBox(height: AppTheme.spaceMd),
//                     DropdownButtonFormField<String>(
//                       value: selectedLevel,
//                       decoration: const InputDecoration(labelText: "Level"),
//                       items: levels
//                           .map(
//                             (l) => DropdownMenuItem(value: l, child: Text(l)),
//                           )
//                           .toList(),
//                       onChanged: (v) => setState(() => selectedLevel = v!),
//                     ),
//                     const SizedBox(height: AppTheme.spaceMd),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: priceController,
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               labelText: "Price",
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: AppTheme.spaceMd),
//                         Expanded(
//                           child: TextField(
//                             controller: durationController,
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               labelText: "Duration (weeks)",
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: AppTheme.spaceMd),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: classesController,
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               labelText: "Total Classes",
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: AppTheme.spaceMd),
//                         Expanded(
//                           child: TextField(
//                             controller: seatsController,
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               labelText: "Available Seats",
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: isCreating ? null : () => Navigator.pop(ctx),
//               child: const Text("Cancel"),
//             ),
//             const SizedBox(width: AppTheme.spaceXs),
//             ElevatedButton(
//               onPressed: isCreating
//                   ? null
//                   : () async {
//                       setState(() => isCreating = true);
//                       try {
//                         if (type == "Program") {
//                           await provider.createProgram(
//                             titleController.text.trim(),
//                             descController.text.trim(),
//                           );
//                         } else {
//                           await provider.createCourse(
//                             title: titleController.text.trim(),
//                             description: descController.text.trim(),
//                             programId: selectedProgramId,
//                             category: selectedCategory,
//                             level: selectedLevel,
//                             price: int.parse(priceController.text),
//                             durationWeeks: int.parse(durationController.text),
//                             totalClasses: int.parse(classesController.text),
//                             seats: int.parse(seatsController.text),
//                           );
//                         }
//
//                         if (ctx.mounted) Navigator.pop(ctx);
//                       } catch (e) {
//                         setState(() => isCreating = false);
//                         ScaffoldMessenger.of(
//                           context,
//                         ).showSnackBar(SnackBar(content: Text(e.toString())));
//                       }
//                     },
//               child: isCreating
//                   ? const SizedBox(
//                       width: 18,
//                       height: 18,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     )
//                   : const Text("Create"),
//             ),
//           ],
//         );
//       },
//     ),
//   );
// }
//
// // ============================================================
// // SUPPORTING WIDGETS
// // ============================================================
//
// class StatData {
//   final String label;
//   final String value;
//   final IconData icon;
//   final Color color;
//   final String trend;
//   final VoidCallback? onTap;
//
//   StatData({
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.color,
//     required this.trend,
//     this.onTap,
//   });
// }
//
// class StatsGrid extends StatelessWidget {
//   final List<StatData> stats;
//
//   const StatsGrid({required this.stats});
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         // Responsive: 2 columns on mobile, 4 on desktop
//         final crossAxisCount = constraints.maxWidth > 900 ? 4 : 2;
//
//         return GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: crossAxisCount,
//             mainAxisSpacing: AppTheme.spaceMd,
//             crossAxisSpacing: AppTheme.spaceMd,
//             childAspectRatio: 1.4,
//           ),
//           itemCount: stats.length,
//           itemBuilder: (context, index) {
//             final stat = stats[index];
//             return StatCard(stat: stat);
//           },
//         );
//       },
//     );
//   }
// }
//
// class StatCard extends StatefulWidget {
//   final StatData stat;
//
//   const StatCard({required this.stat});
//
//   @override
//   State<StatCard> createState() => StatCardState();
// }
//
// class StatCardState extends State<StatCard> {
//   bool _isHovered = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: GestureDetector(
//         onTap: widget.stat.onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           decoration: BoxDecoration(
//             color: Theme.of(context).cardColor,
//             borderRadius: AppTheme.borderRadiusLg,
//             border: Border.all(
//               color: _isHovered
//                   ? widget.stat.color.withOpacity(0.3)
//                   : AppTheme.getBorder(context),
//               width: 1,
//             ),
//             boxShadow: _isHovered ? AppTheme.shadowMd(isDark) : null,
//           ),
//           padding: const EdgeInsets.all(AppTheme.spaceLg),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(AppTheme.spaceXs),
//                     decoration: BoxDecoration(
//                       color: widget.stat.color.withOpacity(0.1),
//                       borderRadius: AppTheme.borderRadiusMd,
//                     ),
//                     child: Icon(
//                       widget.stat.icon,
//                       color: widget.stat.color,
//                       size: 20,
//                     ),
//                   ),
//                   if (widget.stat.onTap != null)
//                     Icon(
//                       Icons.arrow_forward,
//                       size: 16,
//                       color: AppTheme.getTextTertiary(context),
//                     ),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.stat.value,
//                     style: Theme.of(context).textTheme.displaySmall?.copyWith(
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: AppTheme.space2xs),
//                   Text(
//                     widget.stat.label,
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: AppTheme.getTextSecondary(context),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: AppTheme.space2xs),
//                   Text(
//                     widget.stat.trend,
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: AppTheme.getTextTertiary(context),
//                       fontSize: 11,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ActionCard extends StatefulWidget {
//   final IconData icon;
//   final String title;
//   final String description;
//   final Gradient gradient;
//   final VoidCallback onTap;
//
//   const ActionCard({
//     required this.icon,
//     required this.title,
//     required this.description,
//     required this.gradient,
//     required this.onTap,
//   });
//
//   @override
//   State<ActionCard> createState() => ActionCardState();
// }
//
// class ActionCardState extends State<ActionCard> {
//   bool _isHovered = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final gradient = widget.gradient as LinearGradient;
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: GestureDetector(
//         onTap: widget.onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           decoration: BoxDecoration(
//             color: Theme.of(context).cardColor,
//             borderRadius: AppTheme.borderRadiusLg,
//             border: Border.all(color: AppTheme.getBorder(context), width: 1),
//             boxShadow: _isHovered ? AppTheme.shadowLg(isDark) : null,
//           ),
//           child: Stack(
//             children: [
//               // Gradient background on hover
//               if (_isHovered)
//                 Positioned.fill(
//                   child: Opacity(
//                     opacity: 0.05,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: gradient.colors,
//                           stops: gradient.stops,
//                           begin: gradient.begin,
//                           end: gradient.end,
//                           transform: const GradientRotation(0.1),
//                         ),
//                         borderRadius: AppTheme.borderRadiusLg,
//                       ),
//                     ),
//                   ),
//                 ),
//
//               Padding(
//                 padding: const EdgeInsets.all(AppTheme.spaceLg),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(AppTheme.spaceSm),
//                       decoration: BoxDecoration(
//                         gradient: widget.gradient,
//                         borderRadius: AppTheme.borderRadiusMd,
//                       ),
//                       child: Icon(widget.icon, color: Colors.white, size: 24),
//                     ),
//                     const Spacer(),
//                     Text(
//                       widget.title,
//                       style: Theme.of(context).textTheme.headlineSmall
//                           ?.copyWith(fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: AppTheme.space2xs),
//                     Text(
//                       widget.description,
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                         color: AppTheme.getTextSecondary(context),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Arrow indicator
//               Positioned(
//                 top: AppTheme.spaceMd,
//                 right: AppTheme.spaceMd,
//                 child: AnimatedRotation(
//                   duration: const Duration(milliseconds: 200),
//                   turns: _isHovered ? -0.125 : 0,
//                   child: Icon(
//                     Icons.arrow_forward,
//                     size: 18,
//                     color: AppTheme.getTextTertiary(context),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ActivityItem extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final String subtitle;
//   final String time;
//
//   const ActivityItem({
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.subtitle,
//     required this.time,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(AppTheme.spaceMd),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(AppTheme.spaceXs),
//             decoration: BoxDecoration(
//               color: iconColor.withOpacity(0.1),
//               borderRadius: AppTheme.borderRadiusMd,
//             ),
//             child: Icon(icon, color: iconColor, size: 20),
//           ),
//           const SizedBox(width: AppTheme.spaceMd),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: Theme.of(
//                     context,
//                   ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
//                 ),
//                 const SizedBox(height: AppTheme.space2xs),
//                 Text(
//                   subtitle,
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: AppTheme.getTextSecondary(context),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             time,
//             style: Theme.of(context).textTheme.bodySmall?.copyWith(
//               color: AppTheme.getTextTertiary(context),
//               fontSize: 11,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
