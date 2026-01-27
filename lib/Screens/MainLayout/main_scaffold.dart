import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Notificaton/announcements_widget.dart';
import 'package:htoochoon_flutter/Notificaton/noti&emails.dart';
import 'package:htoochoon_flutter/Providers/theme_provider.dart';
import 'package:htoochoon_flutter/Providers/login_provider.dart';
import 'package:htoochoon_flutter/Screens/Classes/classes_tab.dart';
import 'package:htoochoon_flutter/Screens/Courses/courses_tab.dart';
import 'package:htoochoon_flutter/Screens/Home/home_tab.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/org_context_loader.dart';
import 'package:htoochoon_flutter/Screens/Profile/profile_tab.dart'; // Implemented
import 'package:provider/provider.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const ClassesTab(),
    const CoursesTab(),
    const OrgContextLoader(),
    const ProfileTab(),
    const NotiAndEmails(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isExtended = MediaQuery.of(context).size.width > 900;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return Scaffold(
      body: Row(
        children: [
          // SIDEBAR
          NavigationRail(
            extended: isExtended,
            minExtendedWidth: 200,
            backgroundColor: Theme.of(context).cardColor,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            leading: Column(
              children: [
                const SizedBox(height: 20),
                Icon(
                  Icons.school_rounded,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                if (isExtended) ...[
                  const SizedBox(height: 8),
                  Text(
                    "HTOO CHOON",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1.2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
                const SizedBox(height: 30),
              ],
            ),
            trailing: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                    ),
                    onPressed: () => themeProvider.toggleTheme(),
                  ),
                  const SizedBox(height: 8),
                  // Logout
                  IconButton(
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.redAccent,
                    ),
                    onPressed: () => loginProvider.logout(context),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
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
                icon: Icon(Icons.notifications_active_outlined),
                selectedIcon: Icon(Icons.notifications_on),
                label: Text('Notifications    '),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // MAIN CONTENT
          Expanded(
            child: IndexedStack(index: _selectedIndex, children: _pages),
          ),
        ],
      ),
    );
  }
}
