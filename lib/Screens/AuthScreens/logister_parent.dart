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
  bool showLoginPage = true;
  late LoginProvider loginProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginProvider = Provider.of<LoginProvider>(context);
  }

  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        User? user = snapshot.data;

        if (user != null) {
          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: loginProvider.fetchUserDocument(user.uid),
            builder: (context, userDocSnapshot) {
              if (userDocSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (userDocSnapshot.hasError || !userDocSnapshot.hasData) {
                return Scaffold(
                  body: Center(child: Text('Error loading user data')),
                );
              }

              final data = userDocSnapshot.data?.data();
              if (data == null) {
                return Scaffold(
                  body: Center(child: Text('User data not found')),
                );
              }

              String role = data['role'] ?? 'user';
              String plan = data['plan'] ?? 'free';
              String? userType = data['userType'];

              // Decide where to navigate
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (role == 'org') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => MainDashboardWrapper()),
                  );
                } else if (role == 'user') {
                  if (userType == "student" || userType == "teacher") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => FreeUserHome()),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => StudentORTeacherPage()),
                    );
                  }
                }
              });

              // RETURN a temporary widget while navigating
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
