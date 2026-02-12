import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/login_provider.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/OrgWidgets/org_dashboard_widgets.dart';
import 'package:htoochoon_flutter/lms/forms/screens/lms_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:htoochoon_flutter/Screens/LMS/assignment_list_screen.dart';
import 'package:htoochoon_flutter/Screens/LMS/live_session_list_screen.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/OrgWidgets/org_dashboard_tab.dart';

class ClassDetailScreen extends StatelessWidget {
  final String classId;
  final String className;

  const ClassDetailScreen({
    super.key,
    required this.classId,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<OrgProvider, LoginProvider>(
      builder: (context, orgProvider, loginProvider, child) =>
          DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                title: Text(className),
                bottom: const TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Assignments'),
                    Tab(text: 'Live Sessions'),
                    Tab(text: 'People'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  _buildOverviewTab(context),
                  LmsHomeScreen(
                    userId: loginProvider.uid.toString(),
                    userRole: "teacher", // handled constantly by screens
                    classId: classId,
                  ),
                  LiveSessionListScreen(classId: classId),
                  _buildPeopleTab(context, orgProvider),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(context),
          const SizedBox(height: 24),
          const Text(
            'Recent Activity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Center(child: Text("No recent activity")),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to $className',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check here for latest announcements and course materials.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeopleTab(BuildContext context, OrgProvider orgProvider) {
    // TODO: Replace these dummy lists with data from real Provider
    // final orgProvider = Provider.of<OrgProvider>(context);
    // final teachers = orgProvider.getTeachers(classId);

    final List<String> teachers = ["Mr. Anderson"];
    final List<String> students = [
      "Alice Johnson",
      "Bob Smith",
      "Charlie Brown",
      "Diana Prince",
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Teachers Section ---
          _buildSectionHeader(context, "Teachers"),
          ...teachers.map(
            (name) => _buildPersonTile(context, name, isTeacher: true),
          ),

          const SizedBox(height: 32),

          // --- Students Section ---
          _buildSectionHeader(
            context,
            "Students",
            // The Invite Button
            trailing: IconButton(
              icon: Icon(
                Icons.person_add_alt_1,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => showInviteStudentDialog(context, orgProvider),
            ),
          ),

          // Student Count
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              "${students.length} students",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),

          // Student List
          ...students.map((name) => _buildPersonTile(context, name)),
        ],
      ),
    );
  }

  // Helper widget for the headers (Teachers/Students)
  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    Widget? trailing,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
        const SizedBox(height: 4),
        Divider(color: Theme.of(context).primaryColor, thickness: 1),
      ],
    );
  }

  // Helper widget for the list rows (Avatar + Name)
  Widget _buildPersonTile(
    BuildContext context,
    String name, {
    bool isTeacher = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isTeacher
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.grey.shade200,
            radius: 20,
            child: Text(
              name[0].toUpperCase(), // First letter of name
              style: TextStyle(
                color: isTeacher
                    ? Theme.of(context).primaryColor
                    : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),

          if (!isTeacher)
            IconButton(
              icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
              onPressed: () {},
            ),
        ],
      ),
    );
  }

  // Logic to show the Invite Popup
  void _showInviteDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Invite students"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter the email address of the student you want to invite.",
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email address",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () {
                if (emailController.text.isNotEmpty) {
                  // TODO: Call your Provider API to send the invite
                  // Provider.of<OrgProvider>(context, listen: false).inviteStudent(emailController.text);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Invitation sent to ${emailController.text}",
                      ),
                    ),
                  );
                }
              },
              child: const Text("Invite"),
            ),
          ],
        );
      },
    );
  }
}
