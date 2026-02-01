import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/login_provider.dart';

import 'package:htoochoon_flutter/Screens/AdminScreens/admin_home_parent.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/login_screen.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/register_screen.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/org_core_home.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/org_super_home.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/org_upgrade_screen.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/organization_plus_home.dart';

import 'package:htoochoon_flutter/Screens/UserScreens/apex_user_home.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/free_user_home.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/hyper_user_home.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/plan_selection_screen.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/student_o_teacher.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogisterParent extends StatefulWidget {
  const LogisterParent({Key? key}) : super(key: key);

  @override
  State<LogisterParent> createState() => _LogisterParentState();
}

class _LogisterParentState extends State<LogisterParent> {
  late LoginProvider loginProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const _FullScreenLoader();
        }

        if (authSnapshot.hasError) {
          return _ErrorScreen(authSnapshot.error.toString());
        }

        final user = authSnapshot.data;

        // 🔐 Not logged in
        if (user == null) {
          return const LoginScreen();
        }

        // 🔐 Logged in → fetch user doc
        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: loginProvider.fetchUserDocument(user.uid),
          builder: (context, userDocSnapshot) {
            if (userDocSnapshot.connectionState == ConnectionState.waiting) {
              return const _FullScreenLoader();
            }

            if (userDocSnapshot.hasError) {
              return const _ErrorScreen("Failed to load user profile");
            }

            final data = userDocSnapshot.data?.data();
            if (data == null) {
              return const _ErrorScreen("User data not found");
            }

            final role = data['role'] ?? 'user';
            final userType = data['userType'];

            // 🧠 ROUTING DECISION (NO NAVIGATION)
            if (role == 'org') {
              return const MainDashboardWrapper();
            }

            if (role == 'user') {
              if (userType == 'student' || userType == 'teacher') {
                return const FreeUserHome();
              }
              return const StudentORTeacherPage();
            }

            return const LoginScreen();
          },
        );
      },
    );
  }
}

class _FullScreenLoader extends StatelessWidget {
  const _FullScreenLoader();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _ErrorScreen extends StatelessWidget {
  final String message;
  const _ErrorScreen(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(message)));
  }
}
