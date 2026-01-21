import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:provider/provider.dart';
import 'OrgWidgets/org_dashboard_widgets.dart';

class MainDashboardWrapper extends StatefulWidget {
  const MainDashboardWrapper({super.key});
  @override
  State<MainDashboardWrapper> createState() => _MainDashboardWrapperState();
}

class _MainDashboardWrapperState extends State<MainDashboardWrapper> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  final List<Widget> _pages = [
    const OrgDashboardScreen(),
    const AllProgramsScreen(),
    const TeachersListScreen(),
    const StudentsListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isExtended = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: Row(
        children: [
          // Custom Sidebar Container
          Container(
            width: isExtended ? 250 : 80,
            color: Theme.of(context).cardColor,
            child: Column(
              children: [
                // 1. App Logo / Header
                _buildSidebarHeader(isExtended),

                // 2. Main Navigation Items
                Expanded(
                  child: NavigationRail(
                    extended: isExtended,
                    minExtendedWidth: 250,
                    selectedIndex: _selectedIndex,
                    backgroundColor: Colors.transparent,
                    onDestinationSelected: (index) =>
                        setState(() => _selectedIndex = index),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.layers_outlined),
                        selectedIcon: Icon(Icons.layers),
                        label: Text('Programs'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_pin_outlined),
                        selectedIcon: Icon(Icons.person_pin),
                        label: Text('Teachers'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.school_outlined),
                        selectedIcon: Icon(Icons.school),
                        label: Text('Students'),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // 3. Footer Section (Profile, Theme, Settings, Logout)
                _buildSidebarFooter(isExtended),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),

          // Main Content
          Expanded(
            child: IndexedStack(index: _selectedIndex, children: _pages),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader(bool isExtended) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        mainAxisAlignment: isExtended
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          const Icon(Icons.school, size: 32, color: Colors.teal),
          if (isExtended) ...[
            const SizedBox(width: 12),
            const Text(
              "Htoo Choon",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSidebarFooter(bool isExtended) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Light/Dark Toggle
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
            title: isExtended ? const Text("Theme") : null,
            trailing: isExtended
                ? Switch(
                    value: _isDarkMode,
                    onChanged: (val) => setState(() => _isDarkMode = val),
                  )
                : null,
            onTap: () => setState(() => _isDarkMode = !_isDarkMode),
          ),

          // Settings
          _buildFooterItem(
            Icons.settings_outlined,
            "Settings",
            isExtended,
            () {},
          ),

          const SizedBox(height: 8),

          // Admin Profile Card
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => _showProfileMenu(context),
              child: Row(
                mainAxisAlignment: isExtended
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.teal,
                    child: Text(
                      "AD",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  if (isExtended) ...[
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Admin",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "View Profile",
                            style: TextStyle(fontSize: 11, color: Colors.teal),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          _buildFooterItem(
            Icons.logout,
            "Logout",
            isExtended,
            () => _handleLogout(),
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterItem(
    IconData icon,
    String label,
    bool isExtended,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: isExtended ? Text(label, style: TextStyle(color: color)) : null,
    );
  }

  void _showProfileMenu(BuildContext context) {}

  void _handleLogout() {}
}

class OrgDashboardScreen extends StatefulWidget {
  const OrgDashboardScreen({super.key});

  @override
  State<OrgDashboardScreen> createState() => _OrgDashboardScreenState();
}

class _OrgDashboardScreenState extends State<OrgDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header
                  const Text(
                    "Dashboard",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // 2. Stats Cards
                  Row(
                    children: [
                      _buildStatCard("Active Classes", "8", Colors.blue),
                      _buildStatCard("Total Students", "124", Colors.green),
                      _buildStatCard("Pending Invites", "3", Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 3. Quick Actions
                  const Text(
                    "Quick Actions",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildActionButton(
                        icon: Icons.create_new_folder,
                        label: "Create Program",
                        onTap: () =>
                            _showCreateDialog(context, "Program", orgProvider),
                      ),
                      _buildActionButton(
                        icon: Icons.book,
                        label: "Add Course",
                        onTap: () =>
                            _showCreateDialog(context, "Course", orgProvider),
                      ),
                      _buildActionButton(
                        icon: Icons.person_add,
                        label: "Invite Teacher",
                        onTap: () => _showInviteDialog(context, orgProvider),
                      ),
                      _buildActionButton(
                        icon: Icons.calendar_today,
                        label: "Create Class",
                        onTap: () =>
                            _showCreateClassDialog(context, orgProvider),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.teal),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // --- Dialog Examples for Interactions ---

  void _showInviteDialog(BuildContext context, OrgProvider provider) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Invite Teacher"),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: "Teacher Email"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              provider.inviteTeacher(emailController.text);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Invitation Sent!")));
            },
            child: const Text("Send Invite"),
          ),
        ],
      ),
    );
  }
  //
  // void _showProgramCreateDialog(
  //   BuildContext context,
  //   String type,
  //   OrgProvider provider,
  // ) {
  //   showDialog(
  //     context: (context),
  //     builder: (ctx) => AlertDialog(
  //       title: const Text("Create New Program"),
  //       content: TextField(
  //         controller: emailController,
  //         decoration: const InputDecoration(labelText: "Teacher Email"),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx),
  //           child: const Text("Cancel"),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             provider.inviteTeacher(emailController.text);
  //             Navigator.pop(ctx);
  //             ScaffoldMessenger.of(
  //               context,
  //             ).showSnackBar(const SnackBar(content: Text("Invitation Sent!")));
  //           },
  //           child: const Text("Send Invite"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showCourseCreateDialog(
    BuildContext context,
    String type,
    OrgProvider provider,
  ) {
    // Basic dialog for Program/Course creation
    // Implement text controllers and call provider methods
  }
  void _showCreateDialog(
    BuildContext context,
    String type,
    OrgProvider provider,
  ) {
    // Basic dialog for Program/Course creation
    // Implement text controllers and call provider methods
  }

  void _showCreateClassDialog(BuildContext context, OrgProvider provider) {
    // This dialog needs a Dropdown to select Course and Teacher
    // Fetch courses/teachers from provider before showing logic
  }
}

class ProgramDetailScreen extends StatelessWidget {
  final String programId;
  final String programName;

  const ProgramDetailScreen({
    super.key,
    required this.programId,
    required this.programName,
  });

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("$programName > Courses")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('organizations')
            .doc(orgProvider.currentOrgId)
            .collection('courses')
            .where('programId', isEqualTo: programId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          var courses = snapshot.data!.docs;

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              var course = courses[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.book, color: Colors.blue),
                  title: Text(course['title']),
                  subtitle: Text(
                    "Status: ${course['status']}",
                  ), // DRAFT, READY, LIVE
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailScreen(
                          courseId: course.id,
                          courseTitle: course['title'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Open dialog to add course to THIS program
        },
      ),
    );
  }
}

class CourseDetailScreen extends StatelessWidget {
  final String courseId;
  final String courseTitle;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("$courseTitle > Classes")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('organizations')
            .doc(orgProvider.currentOrgId)
            .collection('classes')
            .where('courseId', isEqualTo: courseId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          var classes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              var cls = classes[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.group, color: Colors.white),
                  ),
                  title: Text(cls['name']), // e.g., "Batch 1 - Morning"
                  subtitle: Text("Teacher ID: ${cls['teacherId']}"),
                  trailing: ElevatedButton(
                    child: const Text("Manage"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClassInteriorDashboard(
                            classId: cls.id,
                            className: cls['name'],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ClassInteriorDashboard extends StatefulWidget {
  final String classId;
  final String className;

  const ClassInteriorDashboard({
    super.key,
    required this.classId,
    required this.className,
  });

  @override
  State<ClassInteriorDashboard> createState() => _ClassInteriorDashboardState();
}

class _ClassInteriorDashboardState extends State<ClassInteriorDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.className),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.video_call), text: "Live Sessions"),
            Tab(icon: Icon(Icons.assignment), text: "Assignments"),
            Tab(icon: Icon(Icons.quiz), text: "Exams"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LiveSessionsTab(classId: widget.classId),
          _AssignmentsTab(classId: widget.classId),
          _ExamsTab(classId: widget.classId),
        ],
      ),
    );
  }
}

class _ExamsTab extends StatelessWidget {
  final String classId;
  const _ExamsTab({required this.classId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.quiz, size: 60, color: Colors.grey),
          const SizedBox(height: 20),
          const Text("No Exams Scheduled"),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text("Create Exam Form"),
            onPressed: () {
              // Navigate to a dedicated Form Builder Screen
              // Logic: Add Questions -> Save to Firestore -> orgProvider.createExam(...)
            },
          ),
        ],
      ),
    );
  }
}

class _AssignmentsTab extends StatelessWidget {
  final String classId;
  const _AssignmentsTab({required this.classId});

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context, listen: false);

    return Scaffold(
      // Using scaffold to get floating button inside tab
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.upload_file),
        onPressed: () {
          // Call orgProvider.createAssignment(...)
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('organizations')
            .doc(orgProvider.currentOrgId)
            .collection('classes')
            .doc(classId)
            .collection('assignments')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: Text("No Assignments yet"));
          return ListView(
            children: snapshot.data!.docs
                .map(
                  (doc) => ListTile(
                    title: Text(doc['title']),
                    subtitle: Text(doc['description']),
                    trailing: const Icon(Icons.check_circle_outline),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

// --- Tab 1: Live Sessions & AI Cheat Detection ---
class _LiveSessionsTab extends StatelessWidget {
  final String classId;
  const _LiveSessionsTab({required this.classId});

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context, listen: false);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_link),
            label: const Text("Schedule New Session"),
            onPressed: () => _showAddSessionDialog(context, orgProvider),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('organizations')
                .doc(orgProvider.currentOrgId)
                .collection('classes')
                .doc(classId)
                .collection('sessions')
                .orderBy('startTime')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());
              var sessions = snapshot.data!.docs;

              return ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  var session = sessions[index];
                  bool aiEnabled = session['enableCheatDetection'] ?? false;

                  return Card(
                    color: Colors.blue[50],
                    child: ListTile(
                      leading: const Icon(
                        Icons.video_camera_front,
                        color: Colors.red,
                      ),
                      title: Text(session['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Time: ${session['startTime'].toDate()}"),
                          if (aiEnabled)
                            const Chip(
                              label: Text(
                                "AI Cheat Detection: ON",
                                style: TextStyle(fontSize: 10),
                              ),
                              backgroundColor: Colors.amber,
                              visualDensity: VisualDensity.compact,
                            ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          "Start Live",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          // TODO: Integrate Zoom/Agora SDK here
                          // Pass 'aiEnabled' to the video call screen to trigger local ML models
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddSessionDialog(BuildContext context, OrgProvider provider) {
    final titleController = TextEditingController();
    bool enableAI = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Schedule Live Class"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Topic"),
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text("Enable AI Cheat Detection"),
                  subtitle: const Text(
                    "Detects phone usage, looking away, etc.",
                  ),
                  value: enableAI,
                  onChanged: (val) => setState(() => enableAI = val),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  provider.createLiveSession(
                    classId: classId,
                    title: titleController.text,
                    startTime: DateTime.now().add(
                      const Duration(days: 1),
                    ), // Placeholder date
                    meetingLink: "https://zoom.us/j/123456",
                    enableAiCheatDetection: enableAI,
                  );
                  Navigator.pop(ctx);
                },
                child: const Text("Schedule"),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AllProgramsScreen extends StatelessWidget {
  const AllProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Programs"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                showCreateProgramDialog(context, orgProvider);
              },
              icon: const Icon(Icons.add),
              label: const Text("New Program"),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('organizations')
            .doc(orgProvider.currentOrgId)
            .collection('programs')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState(
              Icons.layers,
              "No Programs yet",
              "Create your first program like 'Computer Science' or 'GED'",
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProgramDetailScreen(
                        programId: data.id,
                        programName: data['name'],
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.folder, color: Colors.amber, size: 32),
                        const Spacer(),
                        Text(
                          data['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          data['description'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Widget _buildEmptyState(IconData icon, String title, String subtitle) {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    ),
  );
}

class TeachersListScreen extends StatelessWidget {
  const TeachersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Management"),
        actions: [
          TextButton.icon(
            onPressed: () {
              //TODO
              // _showInviteDialog(context, orgProvider, "teacher"),
            },

            icon: const Icon(Icons.person_add),
            label: const Text("Invite Teacher"),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('organizations')
            .doc(orgProvider.currentOrgId)
            .collection('teachers')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              var teacher = snapshot.data!.docs[index];
              bool isPending = teacher['status'] == 'pending';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isPending ? Colors.grey : Colors.blue,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: Text(teacher['email']),
                subtitle: Text(
                  isPending ? "Waiting for acceptance..." : "Active Staff",
                ),
                trailing: isPending
                    ? Chip(
                        label: const Text("Pending"),
                        backgroundColor: Colors.orange[100],
                      )
                    : const Icon(Icons.chevron_right),
              );
            },
          );
        },
      ),
    );
  }
}

class StudentsListScreen extends StatelessWidget {
  const StudentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Student Management"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Active Students"),
              Tab(text: "Join Requests"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStudentList(orgProvider, "active"),
            _buildStudentList(orgProvider, "requested"),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            //TODO

            // _showInviteDialog(context, orgProvider, "student"),
          },

          label: const Text("Invite Student"),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildStudentList(OrgProvider provider, String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('organizations')
          .doc(provider.currentOrgId)
          .collection('students')
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty)
          return const Center(child: Text("No students found"));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var student = snapshot.data!.docs[index];
            return Card(
              child: ListTile(
                title: Text(student['name'] ?? student['email']),
                subtitle: Text(
                  "Joined: ${student['joinedAt']?.toDate() ?? 'Pending'}",
                ),
                trailing: status == "requested"
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {},
                          ),
                        ],
                      )
                    : const Icon(Icons.more_vert),
              ),
            );
          },
        );
      },
    );
  }
}
