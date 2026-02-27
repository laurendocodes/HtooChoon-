// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class StudentClassroomProvider extends ChangeNotifier {
//   bool isDisposed = false;
//   List<Map<String, dynamic>> joinedClasses = [];
//
//   bool isLoadingClasses = false;
//
//   String? errorMessage;
//
//   /// Get joined classrooms/ prograss bar / tr name / days time
//   /// Get assignments/tests/
//   /// Get live schedules
//   ///  Get own assignmenttodo and deadlines/ reminders
//   ///  comment session (after mvp)
//   /// Show same people filter
//
//   // org members
//   // "role": "student",
//   // "joinedAt": "2026-02-10T09:02:57.840000+00:00",
//   // "status": "active",
//   // "uid": "Z4hajjjhd7MqtY9Nf4kAPMcmKBV2",
//   // "email": "lauren@gmail.com"
//
//   Future<List<String>> getStudentOrganizations(studentId) async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('organizations')
//         .get();
//     final List<String> orgIds = [];
//
//     for (var doc in snapshot.docs) {
//       final members = doc.data()['members'] as Map<String, dynamic>?;
//       if (members != null && members.containsKey(studentId)) {
//         if (members[studentId]["role"] == 'student') {
//           orgIds.add(doc.id);
//         }
//       }
//     }
//     return orgIds;
//   }
//
//   Future<void> fetchJoinedClasses(String studentId) async {
//     try {
//       print("Loading classes");
//       isLoadingClasses = true;
//       safeChangeNotifier();
//       final orgIds = await getStudentOrganizations(studentId);
//       print("got orgIds classes ${orgIds.length}");
//       List<Map<String, dynamic>> studentClasses = [];
//
//       for (String orgId in orgIds) {
//         final orgDoc = await FirebaseFirestore.instance
//             .collection('organizations')
//             .doc(orgId)
//             .get();
//
//         final classes = orgDoc.data()?['classes'] as Map<String, dynamic>?;
//
//         if (classes == null) continue;
//
//         classes.forEach((classId, classData) {
//           final members = classData['members'] as Map<String, dynamic>?;
//
//           if (members != null && members.containsKey(studentId)) {
//             studentClasses.add({
//               "orgId": orgId,
//               "classId": classId,
//               ...classData,
//             });
//           }
//         });
//         print(studentClasses.length);
//       }
//       joinedClasses = studentClasses;
//     } catch (e) {
//       errorMessage = e.toString();
//     } finally {
//       isLoadingClasses = false;
//       safeChangeNotifier();
//     }
//   }
//
//   Future<Map<String, dynamic>?> getCourseForClass(
//     String orgId,
//     String courseId,
//   ) async {
//     final doc = await FirebaseFirestore.instance
//         .collection('organizations')
//         .doc(orgId)
//         .get();
//
//     final courses = doc.data()?['courses'] as Map<String, dynamic>?;
//
//     if (courses == null || !courses.containsKey(courseId)) {
//       return null;
//     }
//
//     return courses[courseId];
//   }
//
//   Future<Map<String, dynamic>?> getTeacherInfo(String teacherId) async {
//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(teacherId)
//         .get();
//
//     return doc.data();
//   }
//
//   double calculateClassProgress(Map<String, dynamic> classData) {
//     final totalClasses = classData['totalClasses'] ?? 0;
//     final completed = classData['completedClasses'] ?? 0;
//
//     if (totalClasses == 0) return 0;
//
//     return completed / totalClasses;
//   }
//
//   void safeChangeNotifier() {
//     if (!isDisposed) {
//       notifyListeners();
//     }
//   }
//
//   @override
//   void dispose() {
//     isDisposed = true;
//     super.dispose();
//   }
// }
