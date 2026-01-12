import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/login_provider.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/login_screen.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/logister_parent.dart';
import 'package:htoochoon_flutter/Theme/theme_provider.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const LoginPage(),
    );
  }
}
