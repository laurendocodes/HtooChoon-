import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:htoochoon_flutter/Screens/MainLayout/main_scaffold.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/OrgWidgets/create_widgets.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/OrgWidgets/org_dashboard_tab.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/OrgWidgets/org_dashboard_widgets.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/OrgWidgets/premium_sidebar.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/org_core_home.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/org_tabs/members_tab.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:provider/provider.dart';

class PremiumDashboardWrapper extends StatefulWidget {
  final String? currentOrgID;

  const PremiumDashboardWrapper({super.key, required this.currentOrgID});

  @override
  State<PremiumDashboardWrapper> createState() =>
      _PremiumDashboardWrapperState();
}

class _PremiumDashboardWrapperState extends State<PremiumDashboardWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const PremiumOrgDashboardScreen(),
    const AllProgramsScreen(),
    const MemberFilterScreen(),
    const TeachersListScreen(),
    const StudentsListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final orgProvider = context.watch<OrgProvider>();
    final isExtended = MediaQuery.of(context).size.width > 1200;

    // Handle organization exit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (orgProvider.lastAction == OrgAction.exited) {
        orgProvider.clearLastAction();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => MainScaffold()),
          (route) => false,
        );
      }
    });

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Row(
            children: [
              // Sidebar Navigation
              PremiumSidebar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() => _selectedIndex = index);
                },
                isExtended: isExtended,
              ),

              // Main Content Area
              Expanded(
                child: IndexedStack(index: _selectedIndex, children: _pages),
              ),
            ],
          ),
        ),

        // Loading Overlay
        GlobalOrgSwitchOverlay(loadingText: "Exiting organization…"),
      ],
    );
  }
}

/// Premium All Programs Screen
class AllProgramsScreen extends StatelessWidget {
  const AllProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context);

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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Programs',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(height: AppTheme.spaceXs),
                        Text(
                          'Organize courses into structured learning paths',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppTheme.getTextSecondary(context),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceLg),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement create program dialog
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('New Program'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spaceLg,
                        vertical: AppTheme.spaceMd,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Programs Grid
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('organizations')
                .doc(orgProvider.currentOrgId)
                .collection('programs')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SliverFillRemaining(
                  child: _buildEmptyState(
                    Icons.layers_outlined,
                    'No programs yet',
                    'Create your first program to organize your courses',
                    context,
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.space3xl,
                  0,
                  AppTheme.space3xl,
                  AppTheme.space3xl,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: AppTheme.spaceLg,
                    mainAxisSpacing: AppTheme.spaceLg,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final program = snapshot.data!.docs[index];
                    return _ProgramCard(
                      name: program['name'],
                      description: program['description'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgramDetailScreen(
                              programId: program.id,
                              programName: program['name'],
                            ),
                          ),
                        );
                      },
                    );
                  }, childCount: snapshot.data!.docs.length),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    IconData icon,
    String title,
    String subtitle,
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space3xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radius2xl),
              ),
              child: Icon(icon, size: 48, color: const Color(0xFF3B82F6)),
            ),
            const SizedBox(height: AppTheme.spaceLg),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppTheme.spaceXs),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.getTextSecondary(context)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramCard extends StatefulWidget {
  final String name;
  final String description;
  final VoidCallback onTap;

  const _ProgramCard({
    required this.name,
    required this.description,
    required this.onTap,
  });

  @override
  State<_ProgramCard> createState() => _ProgramCardState();
}

class _ProgramCardState extends State<_ProgramCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            border: Border.all(
              color: _isHovered
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                  : AppTheme.getBorder(context),
              width: 1,
            ),
            boxShadow: _isHovered ? AppTheme.shadowMd(isDark) : null,
          ),
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spaceXs),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                      ),
                      borderRadius: AppTheme.borderRadiusMd,
                    ),
                    child: const Icon(
                      Icons.folder,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: AppTheme.getTextTertiary(context),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                widget.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.spaceXs),
              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.getTextSecondary(context),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
