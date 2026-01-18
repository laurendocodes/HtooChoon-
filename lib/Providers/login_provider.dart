import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/login_screen.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/org_core_home.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/org_super_home.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/organization_plus_home.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/StudentScreens/free_student_home.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/apex_user_home.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/free_user_home.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/plan_selection_screen.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/student_o_teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  bool isDisposed = false;
  bool isLoading = false;
  String? errormessage;
  void safeChangeNotifier() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  Future<void> updateUserType(String userId, String userType) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'userType': userType,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', userType);
      print("User type updated to $userType");
    } catch (e) {
      print("Failed to update user type: $e");
    }
  }

  //GetToken
  Future<void> getAuthToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = await user.getIdToken();
      print("Firebase Auth Token: $token");
      prefs.setString('authToken', token.toString());
    } else {
      print("No user is logged in.");
    }
  }

  //FORGOT PASSWORD
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print("Password reset email sent.");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchUserDocument(
    String userId,
  ) async {
    int attempts = 0;
    DocumentSnapshot<Map<String, dynamic>>? userDoc;

    while (attempts < 3) {
      try {
        userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get(const GetOptions(source: Source.server))
            .timeout(const Duration(seconds: 30));

        if (userDoc.exists) {
          return userDoc;
        }
      } catch (e) {
        attempts++;
        print("Attempt $attempts failed: $e");
        if (attempts >= 3) rethrow;
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    throw Exception("Failed to fetch user document");
  }

  Future<String?> loginWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      isLoading = true;
      safeChangeNotifier();

      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await Future.delayed(const Duration(milliseconds: 400));

      final user = userCredential.user;
      if (user == null) return null;

      final userDoc = await fetchUserDocument(user.uid);
      if (!userDoc.exists) {
        throw Exception("User document not found");
      }

      final role = userDoc['role'] ?? 'user';
      final plan = userDoc['plan'] ?? 'free';

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', role);
      await prefs.setString('plan', plan);
      await prefs.setString('userId', user.uid);
      await prefs.setString('email', user.email ?? '');

      await prefs.setBool('isLoggedIn', true);
      print(role);
      print(plan);

      if (role == 'org') {
        if (plan == 'free') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OrgCoreHome()), // or onboarding
          );
        } else if (plan == 'super') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OrgSuperHome()), // or onboarding
          );
        } else if (plan == 'plus') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OrganizationPlusHome(),
            ), // or onboarding
          );
        }
      } else if (role == 'user') {
        if (role == "student") {
          if (plan == 'free') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => FreeStudentHome(),
              ), // or onboarding
            );
          } else if (plan == 'super') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ApexUserHome(role: role),
              ), // or onboarding
            );
          } else if (plan == 'plus') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OrganizationPlusHome(),
              ), // or onboarding
            );
          }
        } else if (role == "mentor") {
          if (plan == 'free') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => OrgCoreHome()), // or onboarding
            );
          } else if (plan == 'super') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OrgSuperHome(),
              ), // or onboarding
            );
          } else if (plan == 'plus') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OrganizationPlusHome(),
              ), // or onboarding
            );
          }
        } else if (role == "teacher") {
          if (plan == 'free') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => OrgCoreHome()), // or onboarding
            );
          } else if (plan == 'super') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OrgSuperHome(),
              ), // or onboarding
            );
          } else if (plan == 'plus') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OrganizationPlusHome(),
              ), // or onboarding
            );
          }
        } else {}
      }

      return role;
    } catch (e) {
      errormessage = e.toString();
      isLoading = false;
      safeChangeNotifier();
      return null;
    }
  }

  Future<void> registerUser(
    BuildContext context,
    String email,
    String password,
    String role,
    String username,
  ) async {
    try {
      isLoading = true;
      safeChangeNotifier();

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User creation failed');
      }

      const defaultPlan = 'free';

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': email,
        'role': role,
        'plan': defaultPlan,
        'username': username,
        'userType': 'none',
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', role);
      await prefs.setString('plan', defaultPlan);
      await prefs.setString('userId', user.uid);
      await prefs.setString('username', username);
      await prefs.setString('email', email);
      await prefs.setBool('isLoggedIn', true);

      isLoading = false;
      safeChangeNotifier();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        if (role == 'org') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => PlanSelectionScreen(role: 'org')),
          );
        } else if (role == 'user') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => StudentORTeacherPage()),
          );
        }
      });
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      safeChangeNotifier();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authentication error')),
        );
      });
    } on FirebaseException {
      isLoading = false;
      safeChangeNotifier();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Database error')));
      });
    } catch (e) {
      isLoading = false;
      safeChangeNotifier();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Something went wrong')));
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('role');
      prefs.remove('userId');
      prefs.remove('email');
      prefs.remove('isLoggedIn');
      safeChangeNotifier();
      print("User logged out.");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      safeChangeNotifier();
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  //Google
  //
  // Future<void> signInWithGoogle() async {
  //   try {
  //     GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) return;
  //
  //     GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //     AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithCredential(credential);
  //     print("Google Sign-In Successful: ${userCredential.user!.email}");
  //   } catch (e) {
  //     print("Error: $e");
  //     errormessage = e.toString();
  //   }
  // }
}
