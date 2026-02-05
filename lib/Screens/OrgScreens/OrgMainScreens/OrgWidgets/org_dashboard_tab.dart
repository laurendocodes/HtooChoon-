import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/OrgWidgets/create_dialogs.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/OrgWidgets/create_widgets.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/invitation_screen.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:provider/provider.dart';

class PremiumOrgDashboardScreen extends StatefulWidget {
  const PremiumOrgDashboardScreen({super.key});

  @override
  State<PremiumOrgDashboardScreen> createState() =>
      _PremiumOrgDashboardScreenState();
}

class _PremiumOrgDashboardScreenState extends State<PremiumOrgDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.space3xl,
                AppTheme.space2xl,
                AppTheme.space3xl,
                AppTheme.spaceLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: AppTheme.spaceXs),
                  Text(
                    'Manage your organization, courses, and members',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.getTextSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stats Cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.space3xl),
            sliver: SliverToBoxAdapter(
              child: _StatsGrid(
                stats: [
                  _StatData(
                    label: 'Active Classes',
                    value: '8',
                    icon: Icons.class_outlined,
                    color: const Color(0xFF3B82F6),
                    trend: '+2 this week',
                    onTap: () => _navigateToInvitations(context),
                  ),
                  _StatData(
                    label: 'Total Students',
                    value: '124',
                    icon: Icons.people_outline,
                    color: const Color(0xFF10B981),
                    trend: '+12 this month',
                    onTap: () => _navigateToInvitations(context),
                  ),
                  _StatData(
                    label: 'Pending Invites',
                    value: '3',
                    icon: Icons.mail_outline,
                    color: const Color(0xFFF59E0B),
                    trend: 'Needs attention',
                    onTap: () => _navigateToInvitations(context),
                  ),
                  _StatData(
                    label: 'Active Teachers',
                    value: '12',
                    icon: Icons.school_outlined,
                    color: const Color(0xFF8B5CF6),
                    trend: 'All verified',
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.space3xl)),

          // Quick Actions Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space3xl,
              ),
              child: Row(
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.tune, size: 18),
                    label: const Text('Customize'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.getTextSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spaceLg)),

          // Quick Actions Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.space3xl),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 280,
                mainAxisSpacing: AppTheme.spaceMd,
                crossAxisSpacing: AppTheme.spaceMd,
                childAspectRatio: 1.4,
              ),
              delegate: SliverChildListDelegate([
                _ActionCard(
                  icon: Icons.create_new_folder_outlined,
                  title: 'Create Program',
                  description: 'Set up a new learning program',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                  ),
                  onTap: () => showCreateProgramDialog(context),
                ),
                _ActionCard(
                  icon: Icons.library_books_outlined,
                  title: 'Add Course',
                  description: 'Create a new course module',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  onTap: () =>
                      _showCreateDialog(context, 'Course', orgProvider),
                ),
                _ActionCard(
                  icon: Icons.person_add_outlined,
                  title: 'Invite Teacher',
                  description: 'Add a new instructor',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                  ),
                  onTap: () => _showInviteDialog(context, orgProvider),
                ),
                _ActionCard(
                  icon: Icons.group_add_outlined,
                  title: 'Invite Students',
                  description: 'Bulk invite students',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                  ),
                  onTap: () => showInviteStudentDialog(context, orgProvider),
                ),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.space3xl)),

          // Recent Activity Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space3xl,
              ),
              child: Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spaceLg)),

          // Activity List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.space3xl,
              0,
              AppTheme.space3xl,
              AppTheme.space3xl,
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: AppTheme.borderRadiusLg,
                  border: Border.all(
                    color: AppTheme.getBorder(context),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _ActivityItem(
                      icon: Icons.person_add,
                      iconColor: const Color(0xFF10B981),
                      title: 'New teacher joined',
                      subtitle: 'John Doe accepted the invitation',
                      time: '2 hours ago',
                    ),
                    Divider(height: 1, color: AppTheme.getBorder(context)),
                    _ActivityItem(
                      icon: Icons.class_,
                      iconColor: const Color(0xFF3B82F6),
                      title: 'Class created',
                      subtitle: 'Introduction to Python - Batch A',
                      time: '5 hours ago',
                    ),
                    Divider(height: 1, color: AppTheme.getBorder(context)),
                    _ActivityItem(
                      icon: Icons.assignment_turned_in,
                      iconColor: const Color(0xFF8B5CF6),
                      title: 'Assignment submitted',
                      subtitle: '24 students completed Math Quiz 3',
                      time: '1 day ago',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToInvitations(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InvitationsScreen()),
    );
  }

  /// Show dialog to invite a student to the organization
  /// Students need to be assigned to specific courses/classes
  void showInviteStudentDialog(BuildContext context, OrgProvider provider) {
    final emailController = TextEditingController();
    List<Map<String, dynamic>> suggestions = [];
    Map<String, dynamic>? selectedUser;
    bool isSearching = false;

    // Student-specific fields
    String? selectedCourseId;
    String? selectedClassId;
    List<String> selectedCourseIds = []; // For bulk course assignment

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          Future<void> onSearch(String value) async {
            setState(() {
              isSearching = true;
              selectedUser = null;
            });

            final result = await provider.searchUsersByEmail(value.trim());

            if (ctx.mounted) {
              setState(() {
                suggestions = result;
                isSearching = false;
              });
            }
          }

          return AlertDialog(
            title: const Text('Invite Student'),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email Search
                    TextField(
                      controller: emailController,
                      onChanged: onSearch,
                      decoration: InputDecoration(
                        labelText: 'Student Email',
                        hintText: 'search@example.com',
                        suffixIcon: isSearching
                            ? const Padding(
                                padding: EdgeInsets.all(AppTheme.spaceSm),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : const Icon(Icons.search, size: 20),
                      ),
                    ),

                    // Search Results
                    if (suggestions.isNotEmpty) ...[
                      const SizedBox(height: AppTheme.spaceMd),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.getBorder(context),
                          ),
                          borderRadius: AppTheme.borderRadiusMd,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: suggestions.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: AppTheme.getBorder(context),
                          ),
                          itemBuilder: (_, i) {
                            final user = suggestions[i];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                                child: Text(
                                  user['email'][0].toUpperCase(),
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              title: Text(user['email']),
                              subtitle: Text(
                                user['name'] ?? user['username'] ?? '',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              onTap: () {
                                setState(() {
                                  selectedUser = user;
                                  emailController.text = user['email'];
                                  suggestions.clear();
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],

                    // Only show course/class selection if user is selected
                    if (selectedUser != null) ...[
                      const SizedBox(height: AppTheme.spaceLg),

                      // Divider with text
                      Row(
                        children: [
                          Expanded(
                            child: Divider(color: AppTheme.getBorder(context)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spaceSm,
                            ),
                            child: Text(
                              'ENROLLMENT OPTIONS',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppTheme.getTextTertiary(context),
                                    letterSpacing: 1.2,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: AppTheme.getBorder(context)),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppTheme.spaceLg),

                      // Course Selection
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('organizations')
                            .doc(provider.currentOrgId)
                            .collection('courses')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const LinearProgressIndicator();
                          }

                          final courses = snapshot.data!.docs;

                          if (courses.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(AppTheme.spaceMd),
                              decoration: BoxDecoration(
                                color: AppTheme.warning.withOpacity(0.1),
                                borderRadius: AppTheme.borderRadiusMd,
                                border: Border.all(
                                  color: AppTheme.warning.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 20,
                                    color: AppTheme.warning,
                                  ),
                                  const SizedBox(width: AppTheme.spaceSm),
                                  Expanded(
                                    child: Text(
                                      'No courses available. Create courses first.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: AppTheme.warning),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Courses (Optional)',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: AppTheme.spaceXs),
                              Text(
                                'Student will have access to selected courses',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppTheme.getTextSecondary(context),
                                    ),
                              ),
                              const SizedBox(height: AppTheme.spaceSm),
                              Container(
                                constraints: const BoxConstraints(
                                  maxHeight: 200,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppTheme.getBorder(context),
                                  ),
                                  borderRadius: AppTheme.borderRadiusMd,
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: courses.length,
                                  itemBuilder: (_, index) {
                                    final course = courses[index];
                                    final courseId = course.id;
                                    final isSelected = selectedCourseIds
                                        .contains(courseId);

                                    return CheckboxListTile(
                                      value: isSelected,
                                      onChanged: (checked) {
                                        setState(() {
                                          if (checked == true) {
                                            selectedCourseIds.add(courseId);
                                          } else {
                                            selectedCourseIds.remove(courseId);
                                          }
                                        });
                                      },
                                      title: Text(
                                        course['title'] ?? 'Untitled Course',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                      subtitle: Text(
                                        course['description'] ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppTheme.getTextSecondary(
                                                context,
                                              ),
                                            ),
                                      ),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      dense: true,
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: AppTheme.spaceLg),

                      // Optional: Specific Class Selection
                      if (selectedCourseIds.length == 1) ...[
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('organizations')
                              .doc(provider.currentOrgId)
                              .collection('classes')
                              .where(
                                'courseId',
                                isEqualTo: selectedCourseIds.first,
                              )
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox.shrink();
                            }

                            final classes = snapshot.data!.docs;

                            if (classes.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Specific Class (Optional)',
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: AppTheme.spaceXs),
                                Text(
                                  'Or leave empty for general course access',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppTheme.getTextSecondary(
                                          context,
                                        ),
                                      ),
                                ),
                                const SizedBox(height: AppTheme.spaceSm),
                                DropdownButtonFormField<String>(
                                  value: selectedClassId,
                                  decoration: const InputDecoration(
                                    labelText: 'Class',
                                    hintText: 'Select a class',
                                  ),
                                  items: classes.map((doc) {
                                    return DropdownMenuItem(
                                      value: doc.id,
                                      child: Text(doc['name'] ?? 'Untitled'),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() => selectedClassId = value);
                                  },
                                ),
                                const SizedBox(height: AppTheme.spaceMd),
                              ],
                            );
                          },
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: AppTheme.spaceXs),
              ElevatedButton(
                onPressed: selectedUser == null || provider.isLoading
                    ? null
                    : () async {
                        try {
                          await provider.inviteStudent(
                            email: selectedUser!['email'],
                            courseIds: selectedCourseIds,
                            classId: selectedClassId,
                            title: 'Invitation to join our Learning Platform',
                            body:
                                'You have been invited to join our organization as a student.',
                          );

                          if (!ctx.mounted) return;
                          Navigator.pop(ctx);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                selectedCourseIds.isEmpty
                                    ? 'Student invited successfully!'
                                    : 'Student invited with ${selectedCourseIds.length} course(s)!',
                              ),
                            ),
                          );
                        } catch (e) {
                          if (!ctx.mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                child: provider.isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send Invite'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showInviteDialog(BuildContext context, OrgProvider provider) {
    final emailController = TextEditingController();
    List<Map<String, dynamic>> suggestions = [];
    Map<String, dynamic>? selectedUser;
    bool isSearching = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          Future<void> onSearch(String value) async {
            setState(() {
              isSearching = true;
              selectedUser = null;
            });

            final result = await provider.searchUsersByEmail(value.trim());

            if (ctx.mounted) {
              setState(() {
                suggestions = result;
                isSearching = false;
              });
            }
          }

          return AlertDialog(
            title: const Text("Invite Teacher"),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: emailController,
                    onChanged: onSearch,
                    decoration: InputDecoration(
                      labelText: "Teacher Email",
                      hintText: "search@example.com",
                      suffixIcon: isSearching
                          ? const Padding(
                              padding: EdgeInsets.all(AppTheme.spaceSm),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : const Icon(Icons.search),
                    ),
                  ),
                  if (suggestions.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.spaceMd),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.getBorder(context)),
                        borderRadius: AppTheme.borderRadiusMd,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: suggestions.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: AppTheme.getBorder(context),
                        ),
                        itemBuilder: (_, i) {
                          final user = suggestions[i];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1),
                              child: Text(
                                user['email'][0].toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            title: Text(user['email']),
                            onTap: () {
                              setState(() {
                                selectedUser = user;
                                emailController.text = user['email'];
                                suggestions.clear();
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              const SizedBox(width: AppTheme.spaceXs),
              ElevatedButton(
                onPressed: selectedUser == null || provider.isLoading
                    ? null
                    : () async {
                        try {
                          await provider.inviteMember(
                            selectedUser!['email'],
                            'teacher',
                            title: 'Invitation to join our LMS',
                            body:
                                'You have been invited to join our organization as a teacher.',
                          );

                          if (!ctx.mounted) return;
                          Navigator.pop(ctx);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Invitation sent successfully!"),
                            ),
                          );
                        } catch (e) {
                          if (!ctx.mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                child: provider.isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Send Invite"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCreateDialog(
    BuildContext context,
    String type,
    OrgProvider provider,
  ) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    final durationController = TextEditingController();
    final classesController = TextEditingController();
    final seatsController = TextEditingController();

    String? selectedProgramId;
    String selectedLevel = 'Beginner';
    String selectedCategory = 'Computer Science';

    final List<String> categories = [
      'Computer Science',
      'Math',
      'Architecture',
      'Design',
      'Business',
    ];

    final List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (_, setState) {
          bool isCreating = false;

          return AlertDialog(
            title: Text("Create New $type"),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: type == "Program"
                            ? "Program Name"
                            : "Course Title",
                        hintText: "Enter a descriptive name",
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceMd),
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        hintText: "What will students learn?",
                      ),
                    ),
                    if (type == "Course") ...[
                      const SizedBox(height: AppTheme.spaceMd),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('organizations')
                            .doc(provider.currentOrgId)
                            .collection('programs')
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) {
                            return const LinearProgressIndicator();
                          }
                          return DropdownButtonFormField<String>(
                            value: selectedProgramId,
                            decoration: const InputDecoration(
                              labelText: "Program (Optional)",
                            ),
                            items: snapshot.data!.docs.map((doc) {
                              return DropdownMenuItem(
                                value: doc.id,
                                child: Text(doc['name']),
                              );
                            }).toList(),
                            onChanged: (v) =>
                                setState(() => selectedProgramId = v),
                          );
                        },
                      ),
                      const SizedBox(height: AppTheme.spaceMd),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: "Category",
                        ),
                        items: categories
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => selectedCategory = v!),
                      ),
                      const SizedBox(height: AppTheme.spaceMd),
                      DropdownButtonFormField<String>(
                        value: selectedLevel,
                        decoration: const InputDecoration(labelText: "Level"),
                        items: levels
                            .map(
                              (l) => DropdownMenuItem(value: l, child: Text(l)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => selectedLevel = v!),
                      ),
                      const SizedBox(height: AppTheme.spaceMd),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Price",
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spaceMd),
                          Expanded(
                            child: TextField(
                              controller: durationController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Duration (weeks)",
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spaceMd),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: classesController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Total Classes",
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spaceMd),
                          Expanded(
                            child: TextField(
                              controller: seatsController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Available Seats",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isCreating ? null : () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              const SizedBox(width: AppTheme.spaceXs),
              ElevatedButton(
                onPressed: isCreating
                    ? null
                    : () async {
                        setState(() => isCreating = true);
                        try {
                          if (type == "Program") {
                            await provider.createProgram(
                              titleController.text.trim(),
                              descController.text.trim(),
                            );
                          } else {
                            await provider.createCourse(
                              title: titleController.text.trim(),
                              description: descController.text.trim(),
                              programId: selectedProgramId,
                              category: selectedCategory,
                              level: selectedLevel,
                              price: int.parse(priceController.text),
                              durationWeeks: int.parse(durationController.text),
                              totalClasses: int.parse(classesController.text),
                              seats: int.parse(seatsController.text),
                            );
                          }

                          if (ctx.mounted) Navigator.pop(ctx);
                        } catch (e) {
                          setState(() => isCreating = false);
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                child: isCreating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Create"),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// SUPPORTING WIDGETS
// ============================================================

class _StatData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final VoidCallback? onTap;

  _StatData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    this.onTap,
  });
}

class _StatsGrid extends StatelessWidget {
  final List<_StatData> stats;

  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive: 2 columns on mobile, 4 on desktop
        final crossAxisCount = constraints.maxWidth > 900 ? 4 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppTheme.spaceMd,
            crossAxisSpacing: AppTheme.spaceMd,
            childAspectRatio: 1.4,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return _StatCard(stat: stat);
          },
        );
      },
    );
  }
}

class _StatCard extends StatefulWidget {
  final _StatData stat;

  const _StatCard({required this.stat});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.stat.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: AppTheme.borderRadiusLg,
            border: Border.all(
              color: _isHovered
                  ? widget.stat.color.withOpacity(0.3)
                  : AppTheme.getBorder(context),
              width: 1,
            ),
            boxShadow: _isHovered ? AppTheme.shadowMd(isDark) : null,
          ),
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spaceXs),
                    decoration: BoxDecoration(
                      color: widget.stat.color.withOpacity(0.1),
                      borderRadius: AppTheme.borderRadiusMd,
                    ),
                    child: Icon(
                      widget.stat.icon,
                      color: widget.stat.color,
                      size: 20,
                    ),
                  ),
                  if (widget.stat.onTap != null)
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppTheme.getTextTertiary(context),
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.stat.value,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppTheme.space2xs),
                  Text(
                    widget.stat.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.getTextSecondary(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppTheme.space2xs),
                  Text(
                    widget.stat.trend,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.getTextTertiary(context),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = widget.gradient as LinearGradient;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: AppTheme.borderRadiusLg,
            border: Border.all(color: AppTheme.getBorder(context), width: 1),
            boxShadow: _isHovered ? AppTheme.shadowLg(isDark) : null,
          ),
          child: Stack(
            children: [
              // Gradient background on hover
              if (_isHovered)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.05,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient.colors,
                          stops: gradient.stops,
                          begin: gradient.begin,
                          end: gradient.end,
                          transform: const GradientRotation(0.1),
                        ),
                        borderRadius: AppTheme.borderRadiusLg,
                      ),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spaceSm),
                      decoration: BoxDecoration(
                        gradient: widget.gradient,
                        borderRadius: AppTheme.borderRadiusMd,
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 24),
                    ),
                    const Spacer(),
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppTheme.space2xs),
                    Text(
                      widget.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.getTextSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow indicator
              Positioned(
                top: AppTheme.spaceMd,
                right: AppTheme.spaceMd,
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: _isHovered ? -0.125 : 0,
                  child: Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: AppTheme.getTextTertiary(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceXs),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: AppTheme.borderRadiusMd,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: AppTheme.space2xs),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.getTextTertiary(context),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
