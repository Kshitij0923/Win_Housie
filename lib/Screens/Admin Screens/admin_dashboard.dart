import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tambola/Login_Register%20Screens/login_screen.dart';
import 'package:tambola/Provider/Controller/user_provider.dart';
import 'package:tambola/Provider/Modal/sontest_service.dart';
import 'package:tambola/Screens/Admin%20Screens/admin_contest_management.dart';
import 'package:tambola/Screens/Admin%20Screens/admin_system_settings.dart';
import 'package:tambola/Theme/app_theme.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final ContestService _contestService = ContestService();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    theme.init(context);

    final List<Widget> _screens = [
      ContestManagementScreen(contestService: _contestService),
      SystemSettingsScreen(),
    ];

    return Scaffold(
      appBar: theme.createAppBar(
        title: 'Admin Dashboard',
        titleStyle: theme.appBarTitleStyle.copyWith(fontSize: theme.sp(6)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: theme.textSecondaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Contests'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
