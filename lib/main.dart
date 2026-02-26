import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Api/api_service/api_service.dart';
import 'package:htoochoon_flutter/Providers/assignment_provider.dart';
import 'package:htoochoon_flutter/Providers/class_provider.dart';
import 'package:htoochoon_flutter/Providers/invitation_provider.dart';
import 'package:htoochoon_flutter/Providers/login_provider.dart';

import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:htoochoon_flutter/Providers/student_clr_view_provider.dart';
import 'package:htoochoon_flutter/Providers/user_provider.dart';
import 'package:htoochoon_flutter/Providers/auth_provider.dart';
import 'package:htoochoon_flutter/Providers/structure_provider.dart';
import 'package:htoochoon_flutter/Providers/subscription_provider.dart';
import 'package:htoochoon_flutter/Providers/theme_provider.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/login_screen.dart';
import 'package:htoochoon_flutter/Screens/MainLayout/main_scaffold.dart';
import 'package:htoochoon_flutter/Screens/Onboarding/onboarding_screen.dart';

import 'package:htoochoon_flutter/Theme/themedata.dart';

import 'package:htoochoon_flutter/lms/forms/screens/lms_home_screen.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();

  Dio dio = Dio();

  // Interceptor to attach token dynamically
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        // Optional: always set JSON content type
        options.headers['Content-Type'] = 'application/json';

        return handler.next(options);
      },
    ),
  );

  // ApiService apiService = ApiService(dio);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // ChangeNotifierProvider(create: (_) => AuthProvider(apiService)),
        // ChangeNotifierProvider(create: (_) => UserProvider(apiService)),
        ChangeNotifierProvider(create: (_) => OrgProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentProvider()),
        ChangeNotifierProvider(create: (_) => StructureProvider()),
        ChangeNotifierProvider(create: (_) => ClassProvider()),
        ChangeNotifierProvider(create: (_) => StudentClassroomProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => InvitationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HtooChoon',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          home: AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  String? token;
  bool _isInit = false;
  Future<bool>? _onboardingCheck;

  @override
  void initState() {
    super.initState();

    _loadToken();
    _onboardingCheck = _checkOnboarding();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('access_token');
    setState(() {
      print("token: $token");
      token = storedToken;
    });
    // await prefs.setString(
    //   'access_token',
    //   "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2OWVlZGI4YS00OTk5LTQyODktODlmOS03NzQzZTE0ZTVlYmYiLCJlbWFpbCI6InJlbnRpZWhlaGVAZ21haWwuY29tIiwicm9sZSI6IlNUVURFTlQiLCJpYXQiOjE3NzIwMDc4NTgsImV4cCI6MTc3MjAxMTQ1OH0.Dfy0eE0BYNbUSdSDk_ZTxkRRASpIOgN8_DjLVFsU0yk",
    // );
    //
    // final storedToken = prefs.getString('access_token');
    //
    // setState(() {
    //   print("token: $token");
    //   token = storedToken;
    // });
  }

  Future<bool> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // While token is loading
    // if (token!.isNotEmpty) {
    //   return Center(child: CircularProgressIndicator());
    // }
    // If token not found → show login
    if (token == null || token!.isEmpty) {
      return const PremiumLoginScreen();
    }

    // Only fetch user once
    if (!_isInit) {
      _isInit = true;
      Future.microtask(() {
        Provider.of<AuthProvider>(context, listen: false).fetchMe();
      });
    }

    return FutureBuilder<bool>(
      future: _onboardingCheck,
      builder: (context, onboardingSnapshot) {
        if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final hasSeenOnboarding = onboardingSnapshot.data ?? false;

        if (!hasSeenOnboarding) {
          return const OnboardingScreen();
        }

        return Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.isLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            return MainScaffold();
          },
        );
      },
    );
  }
}
