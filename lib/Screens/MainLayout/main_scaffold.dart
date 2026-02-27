import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Notificaton/announcements_widget.dart';
import 'package:htoochoon_flutter/Notificaton/noti&emails.dart';
import 'package:htoochoon_flutter/Providers/auth_provider.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:htoochoon_flutter/Providers/theme_provider.dart';
import 'package:htoochoon_flutter/Providers/login_provider.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/login_screen.dart';
import 'package:htoochoon_flutter/Screens/Classes/classes_tab.dart';
import 'package:htoochoon_flutter/Screens/Courses/courses_tab.dart';
import 'package:htoochoon_flutter/Screens/Home/home_tab.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/org_core_home.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/org_dashboard_wrapper.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/org_context_loader.dart';
import 'package:htoochoon_flutter/Screens/Profile/profile_tab.dart'; // Implemented
import 'package:htoochoon_flutter/Screens/Teacher/Home/teacher_dashboard_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    HomeTab(),
    ClassesTab(),
    CoursesTab(),
    OrgContextLoader(),
    ProfileTab(),
    // NotiAndEmails(),
  ];

  @override
  Widget build(BuildContext context) {
    final isExtended = MediaQuery.of(context).size.width > 900;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final orgProvider = context.watch<OrgProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (orgProvider.justSwitched) {
        orgProvider.clearJustSwitched();

        Widget dashboard;
        if (orgProvider.role == 'teacher') {
          dashboard = TeacherDashboardScreen(
            currentOrgID: orgProvider.currentOrgId,
            currentOrgName: orgProvider.currentOrgName ?? "Htoo Choon",
            role: orgProvider.role,
          );
        } else {
          dashboard = PremiumDashboardWrapper(
            currentOrgID: orgProvider.currentOrgId,
            currentOrgName: orgProvider.currentOrgName ?? "Htoo Choon",
            role: orgProvider.role,
          );
        }

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => dashboard),
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
              _PremiumNavigationRail(
                isExtended: isExtended,
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() => _selectedIndex = index);
                },
                themeProvider: themeProvider,
                authProvider: authProvider,
              ),

              VerticalDivider(
                width: 1.2,
                thickness: 1,
                color: AppTheme.getBorder(context),
              ),

              // Main Content - IndexedStack preserves state
              Expanded(
                child: IndexedStack(index: _selectedIndex, children: _pages),
              ),
            ],
          ),
        ),

        // Loading overlay
        GlobalOrgSwitchOverlay(loadingText: "Switching organization…"),
      ],
    );
  }
}

/// Premium Navigation Rail with theme integration
class _PremiumNavigationRail extends StatelessWidget {
  final bool isExtended;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final ThemeProvider themeProvider;
  final AuthProvider authProvider;

  const _PremiumNavigationRail({
    required this.isExtended,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.themeProvider,
    required this.authProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isExtended ? 280 : 72,
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Column(
        children: [
          // Logo/Brand
          _buildHeader(context, isExtended),

          const SizedBox(height: AppTheme.spaceLg),

          // Navigation Items
          Expanded(
            child: NavigationRail(
              extended: isExtended,
              minExtendedWidth: 280,
              backgroundColor: Colors.transparent,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: isExtended
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              // Destinations are const because they contain only static content
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.class_outlined),
                  selectedIcon: Icon(Icons.class_),
                  label: Text('Classes'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.library_books_outlined),
                  selectedIcon: Icon(Icons.library_books),
                  label: Text('Courses'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.business_outlined),
                  selectedIcon: Icon(Icons.business),
                  label: Text('Org'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text('Profile'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.notifications_outlined),
                  selectedIcon: Icon(Icons.notifications),
                  label: Text('Notifications'),
                ),
              ],
            ),
          ),

          // Footer Actions
          Divider(height: 1, color: AppTheme.getBorder(context)),
          _buildFooter(context, isExtended),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isExtended) {
    return Padding(
      padding: EdgeInsets.all(isExtended ? AppTheme.spaceLg : AppTheme.spaceMd),
      child: Row(
        mainAxisAlignment: isExtended
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logos/main_logo.jpeg', height: 70),
          if (isExtended) ...[
            const SizedBox(width: AppTheme.spaceSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HTOO CHOON',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'Learning Platform',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.getTextSecondary(context),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isExtended) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Theme Toggle
          _FooterButton(
            icon: themeProvider.isDarkMode
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined,
            label: 'Theme',
            isExtended: isExtended,
            onTap: () => themeProvider.toggleTheme(),
          ),

          const SizedBox(height: AppTheme.spaceXs),

          // Logout
          _FooterButton(
            icon: Icons.logout_rounded,
            label: 'Logout',
            isExtended: isExtended,
            onTap: () {
              authProvider.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PremiumLoginScreen()),
              );
            },
            color: AppTheme.error,
          ),
        ],
      ),
    );
  }
}

class _FooterButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isExtended;
  final VoidCallback onTap;
  final Color? color;

  const _FooterButton({
    required this.icon,
    required this.label,
    required this.isExtended,
    required this.onTap,
    this.color,
  });

  @override
  State<_FooterButton> createState() => _FooterButtonState();
}

class _FooterButtonState extends State<_FooterButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppTheme.getTextSecondary(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: AppTheme.borderRadiusMd,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isExtended
                  ? AppTheme.spaceMd
                  : AppTheme.spaceXs,
              vertical: AppTheme.spaceSm,
            ),
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppTheme.getSurfaceVariant(context)
                  : Colors.transparent,
              borderRadius: AppTheme.borderRadiusMd,
            ),
            child: Row(
              mainAxisAlignment: widget.isExtended
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: color, size: 20),
                if (widget.isExtended) ...[
                  const SizedBox(width: AppTheme.spaceSm),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// HERE!!! Global loading overlay for organization operations
class GlobalOrgSwitchOverlay extends StatelessWidget {
  final String loadingText;

  const GlobalOrgSwitchOverlay({super.key, required this.loadingText});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrgProvider>(
      builder: (_, provider, __) {
        if (!provider.orgIsLoading) return const SizedBox.shrink();

        return Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Lottie.asset(
                      'assets/lottie/networking.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                  Text(
                    loadingText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
