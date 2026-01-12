import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/login_provider.dart';
import 'package:htoochoon_flutter/Screens/AdminScreens/admin_home_parent.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/login_screen.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/register_screen.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/org_core_home.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/org_super_home.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/org_upgrade_screen.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/organization_plus_home.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/apex_user_home.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/free_user_home.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/hyper_user_home.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/plan_selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//
// class LogisterParent extends StatefulWidget {
//   const LogisterParent({Key? key}) : super(key: key);
//
//   @override
//   State<LogisterParent> createState() => _LogisterParentState();
// }
//
// class _LogisterParentState extends State<LogisterParent> {
//   bool showLoginPage = true;
//   late LoginProvider loginProvider;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     loginProvider = context.read<LoginProvider>();
//   }
//
//   void togglePage() {
//     setState(() => showLoginPage = !showLoginPage);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, authSnapshot) {
//         if (authSnapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         final user = authSnapshot.data;
//
//         if (user == null) {
//           return showLoginPage
//               ? LoginScreen(ontap: togglePage)
//               : RegisterScreen(ontap: togglePage);
//         }
//
//         return FutureBuilder<DocumentSnapshot>(
//           future: loginProvider.fetchUserDocument(user.uid),
//           builder: (context, userDocSnapshot) {
//             if (userDocSnapshot.connectionState == ConnectionState.waiting) {
//               return const Scaffold(
//                 body: Center(child: CircularProgressIndicator()),
//               );
//             }
//
//             if (!userDocSnapshot.hasData || !userDocSnapshot.data!.exists) {
//               return const Scaffold(
//                 body: Center(child: Text("User data not found")),
//               );
//             }
//
//             final data = userDocSnapshot.data!.data() as Map<String, dynamic>;
//
//             final String role = data['role'];
//             final String accountType =
//                 data['accountType']; // user | organization
//             final String plan = data['plan']; // free | hyper | apex
//             final String? orgPlan = data['orgPlan']; // core | plus | super
//
//             // ---------------- ADMIN ----------------
//             if (role == "admin") {
//               return AdminHomeParent();
//             }
//
//             // ---------------- ORGANIZATION ----------------
//             if (accountType == "organization") {
//               switch (orgPlan) {
//                 case "core":
//                   return OrgCoreHome();
//                 case "plus":
//                   return OrganizationPlusHome();
//                 case "super":
//                   return OrgSuperHome();
//                 default:
//                   return OrgUpgradeScreen();
//               }
//             }
//
//             // ---------------- NORMAL USER ----------------
//             if (accountType == "user") {
//               switch (plan) {
//                 case "free": // Flow
//                   return FreeUserHome(role: role);
//
//                 case "hyper": // Most Popular
//                   return HyperUserHome(role: role);
//
//                 case "apex": // ACE
//                   return ApexUserHome(role: role);
//
//                 default:
//                   return PlanSelectionScreen(role: role);
//               }
//             }
//
//             return const Scaffold(
//               body: Center(child: Text("Invalid account configuration")),
//             );
//           },
//         );
//       },
//     );
//   }
// }
