import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  final String role;
  const UserHomePage({super.key, required this.role});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Htoo Choon")),
      body: SafeArea(child: Column(children: [])),
    );
  }
}
