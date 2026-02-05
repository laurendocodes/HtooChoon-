import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/login_screen.dart';
import 'package:htoochoon_flutter/Screens/MainLayout/main_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

  /// Google sign in
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      isLoading = true;
      safeChangeNotifier();

      UserCredential userCredential;

      if (kIsWeb) {
        // WEB
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await FirebaseAuth.instance.signInWithPopup(
          googleProvider,
        );
      } else {
        // MOBILE
        final GoogleSignIn googleSignIn = GoogleSignIn.instance;
        final GoogleSignInAccount? googleUser = await googleSignIn
            .authenticate();

        if (googleUser == null) {
          isLoading = false;
          safeChangeNotifier();
          return;
        }

        final googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
      }

      final user = userCredential.user;
      if (user == null) throw Exception("Google sign-in failed");

      //Create Firestore user doc if new user
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        await _createUserDocument(user, user.displayName ?? 'Google User');
      }

      await _handleAuthSuccess(context, user);
    } catch (e) {
      _handleAuthError(context, e);
    }
  }

  /// Forgot password
  Future<void> sendEmailOtp(String email) async {
    try {
      isLoading = true;
      safeChangeNotifier();

      final otp = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000))
          .toString();

      await FirebaseFirestore.instance
          .collection('password_otps')
          .doc(email)
          .set({'otp': otp, 'createdAt': FieldValue.serverTimestamp()});

      // TODO: send email using EmailJS / Firebase Functions / backend
      debugPrint("OTP sent to $email → $otp");

      isLoading = false;
      safeChangeNotifier();
    } catch (e) {
      isLoading = false;
      safeChangeNotifier();
      throw Exception("Failed to send OTP");
    }
  }

  ///OTP
  Future<bool> verifyEmailOtp(String email, String enteredOtp) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('password_otps')
          .doc(email)
          .get();

      if (!doc.exists) return false;

      final storedOtp = doc['otp'];
      if (storedOtp != enteredOtp) return false;

      // OTP valid → delete
      await FirebaseFirestore.instance
          .collection('password_otps')
          .doc(email)
          .delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Reset password
  Future<void> resetPasswordAfterOtp(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Failed to reset password");
    }
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

  Future<void> loginWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      isLoading = true;
      safeChangeNotifier();

      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await _handleAuthSuccess(context, userCredential.user);
    } catch (e) {
      _handleAuthError(context, e);
    }
  }

  // Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     isLoading = true;
  //     safeChangeNotifier();
  //
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) {
  //       isLoading = false;
  //       safeChangeNotifier();
  //       return; // User canceled
  //     }
  //
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     final UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithCredential(credential);
  //     final user = userCredential.user;
  //
  //     if (user != null) {
  //       // Check if user doc exists, if not create it (Google Sign Up implicit)
  //       final userDoc = await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user.uid)
  //           .get();
  //
  //       if (!userDoc.exists) {
  //         await _createUserDocument(user, user.displayName ?? 'User');
  //       }
  //     }
  //
  //     await _handleAuthSuccess(context, user);
  //   } catch (e) {
  //     _handleAuthError(context, e);
  //   }
  // }
  //
  Future<void> registerUser(
    BuildContext context,
    String email,
    String password,
    String username,
  ) async {
    try {
      isLoading = true;
      safeChangeNotifier();

      // 1. Check if username already exists
      final usernameCheck = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (usernameCheck.docs.isNotEmpty) {
        throw Exception('Username already taken. Please choose another one.');
      }

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) throw Exception('User creation failed');

      await _createUserDocument(user, username);

      await _handleAuthSuccess(context, user);
    } catch (e) {
      _handleAuthError(context, e);
      print(e);
    }
  }

  Future<void> _createUserDocument(User user, String username) async {
    const defaultPlan = 'free';

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email,
      'role': 'user', // Default is just user
      'userType': 'none',
      'plan': defaultPlan,
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
      'isActive': true,
    });

    debugPrint('USER DOC CREATED for ${user.uid}');
  }

  Future<void> _handleAuthSuccess(BuildContext context, User? user) async {
    if (user == null) return;

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

    isLoading = false;
    safeChangeNotifier();

    if (!context.mounted) return;

    // UNIFIED ROUTE: Everyone goes to MainScaffold
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainScaffold()),
    );
  }

  void _handleAuthError(BuildContext context, Object e) {
    errormessage = e.toString();
    isLoading = false;
    safeChangeNotifier();
    debugPrint('AUTH ERROR → $e');

    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // await GoogleSignIn().signOut(); // Ensure Google Sign out too

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PremiumLoginScreen()),
      );
    } catch (e) {
      debugPrint("Logout error: $e");
    }
  }
}
