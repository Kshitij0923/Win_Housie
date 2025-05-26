import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tambola/Login_Register%20Screens/login_screen.dart';
import 'package:tambola/Provider/Controller/user_provider.dart';
import 'package:tambola/Screens/contest_screen.dart';
import 'package:tambola/Screens/mega_screen.dart';
import 'package:tambola/Screens/myProfile.dart';
import 'package:tambola/Screens/settings_screen.dart';
import 'package:tambola/Screens/wallet_screen.dart';
import 'package:tambola/Theme/app_theme.dart';

class NeumorphicHousieeDrawer extends StatefulWidget {
  final String avatarUrl;
  final int coins;
  final int tickets;

  const NeumorphicHousieeDrawer({
    super.key,
    this.avatarUrl = "",
    this.coins = 0,
    this.tickets = 0,
  });

  @override
  State<NeumorphicHousieeDrawer> createState() =>
      _NeumorphicHousieeDrawerState();
}

File? _profileImage;
String? _email;
bool _isLoading = true;

class _NeumorphicHousieeDrawerState extends State<NeumorphicHousieeDrawer> {
  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get profile image path from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final imagePath = prefs.getString('profile_image_path');
      final email =
          prefs.getString('email') ??
          'user@example.com'; // Get email from SharedPreferences

      setState(() {
        if (imagePath != null && File(imagePath).existsSync()) {
          _profileImage = File(imagePath);
        } else {
          _profileImage = null;
        }
        _email = email;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading profile data: $e');
      setState(() {
        _isLoading = false;
        _email = 'user@example.com'; // Default email in case of error
      });
    }
  }

  Widget build(BuildContext context) {
    final theme = AppTheme();
    final Color baseColor = theme.cardColor;
    final Color shadowDark = Colors.black;
    final Color shadowLight = theme.primaryColor.withValues(alpha: 0.3);
    final Color highlightColor = theme.primaryColor;
    final userProvider = Provider.of<UserProvider>(context);

    return Drawer(
      backgroundColor: theme.backgroundColor,
      child: Container(
        decoration: BoxDecoration(gradient: theme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(
                context,
                theme,
                baseColor,
                shadowDark,
                shadowLight,
                userProvider,
              ),
              SizedBox(height: theme.hp(2)),
              _buildBalanceInfo(
                context,
                theme,
                baseColor,
                shadowDark,
                shadowLight,
              ),
              SizedBox(height: theme.hp(3)),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: theme.wp(5)),
                  children: [
                    _buildNeumorphicMenuItem(
                      context: context,
                      icon: Icons.home_rounded,
                      title: 'Home',
                      theme: theme,
                      baseColor: baseColor,
                      shadowDark: shadowDark,
                      shadowLight: shadowLight,
                      highlightColor: highlightColor,
                      onTap: () => Navigator.pop(context),
                    ),
                    SizedBox(height: theme.hp(2)),
                    _buildNeumorphicMenuItem(
                      context: context,
                      icon: Icons.person_rounded,
                      title: 'My Profile',
                      theme: theme,
                      baseColor: baseColor,
                      shadowDark: shadowDark,
                      shadowLight: shadowLight,
                      highlightColor: highlightColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HouzieeProfileScreen(),
                          ),
                        );
                        // Navigate to profile
                      },
                    ),
                    SizedBox(height: theme.hp(2)),
                    _buildNeumorphicMenuItem(
                      context: context,
                      icon: Icons.history_rounded,
                      title: 'Wallet',
                      theme: theme,
                      baseColor: baseColor,
                      shadowDark: shadowDark,
                      shadowLight: shadowLight,
                      highlightColor: highlightColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WalletScreen(),
                          ),
                        );
                        // Navigate to game history
                      },
                    ),
                    SizedBox(height: theme.hp(2)),
                    _buildNeumorphicMenuItem(
                      context: context,
                      icon: Icons.card_giftcard_rounded,
                      title: 'My Rewards',
                      theme: theme,
                      baseColor: baseColor,
                      shadowDark: shadowDark,
                      shadowLight: shadowLight,
                      highlightColor: highlightColor,
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to rewards
                      },
                    ),
                    _buildDivider(theme),
                    _buildNeumorphicMenuItem(
                      context: context,
                      icon: Icons.shopping_cart_rounded,
                      title: 'Buy Tickets',
                      theme: theme,
                      baseColor: baseColor,
                      shadowDark: shadowDark,
                      shadowLight: shadowLight,
                      highlightColor: theme.accentColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MegaScreen(contest: {}),
                          ),
                        );
                        // Navigate to ticket purchase
                      },
                    ),
                    SizedBox(height: theme.hp(2)),
                    _buildNeumorphicMenuItem(
                      context: context,
                      icon: Icons.attach_money_rounded,
                      title: 'Game History',
                      theme: theme,
                      baseColor: baseColor,
                      shadowDark: shadowDark,
                      shadowLight: shadowLight,
                      highlightColor: theme.accentColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WalletScreen(),
                          ),
                        );
                        // Navigate to add coins
                      },
                    ),
                    _buildDivider(theme),
                    _buildNeumorphicMenuItem(
                      context: context,
                      icon: Icons.settings_rounded,
                      title: 'Settings',
                      theme: theme,
                      baseColor: baseColor,
                      shadowDark: shadowDark,
                      shadowLight: shadowLight,
                      highlightColor: highlightColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: theme.hp(2)),
                    _buildNeumorphicMenuItem(
                      context: context,
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support',
                      theme: theme,
                      baseColor: baseColor,
                      shadowDark: shadowDark,
                      shadowLight: shadowLight,
                      highlightColor: highlightColor,
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to help
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(theme.wp(5)),
                child: _buildLogoutButton(
                  context,
                  theme,
                  baseColor,
                  shadowDark,
                  shadowLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight,
    UserProvider userProvider,
  ) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: theme.primaryColor),
      );
    }

    final username = userProvider.username ?? 'User';

    return Padding(
      padding: EdgeInsets.all(theme.wp(5)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Neumorphic avatar
              Container(
                width: theme.wp(18),
                height: theme.wp(18),
                decoration: BoxDecoration(
                  color: baseColor,
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      baseColor,
                      theme.primaryColor.withValues(alpha: 0.2),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: shadowDark.withValues(alpha: 0.7),
                      offset: Offset(4, 4),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      color: shadowLight,
                      offset: Offset(-4, -4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipOval(
                  child:
                      _profileImage != null
                          ? Image.file(
                            _profileImage!,
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          )
                          : Container(
                            width: 30,
                            height: 30,
                            color: Colors.purple[300],
                            child: Center(
                              child: Text(
                                username.isNotEmpty
                                    ? username[0].toUpperCase()
                                    : "U",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                ),
              ),
              SizedBox(width: theme.wp(5)),
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: theme.hp(2.5)),
                    Text(
                      username,
                      style: theme.headingStyle.copyWith(fontSize: theme.sp(6)),
                    ),
                    SizedBox(height: theme.hp(1.5)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceInfo(
    BuildContext context,
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.wp(5)),
      child: Row(
        children: [
          // Coins container
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WalletScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: theme.hp(2),
                  horizontal: theme.wp(3),
                ),
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: theme.cardBorderRadius,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      baseColor,
                      theme.primaryColor.withValues(alpha: 0.15),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: shadowDark.withValues(alpha: 0.7),
                      offset: Offset(4, 4),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      color: shadowLight,
                      offset: Offset(-4, -4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.monetization_on_rounded,
                      color: Colors.amber[700],
                      size: theme.wp(6),
                    ),
                    SizedBox(width: theme.wp(2)),
                    Text(
                      '${widget.coins}',
                      style: GoogleFonts.poppins(
                        color: theme.textPrimaryColor,
                        fontSize: theme.sp(4.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: theme.wp(4)),
          // Tickets container
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HousieContestScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: theme.hp(2),
                  horizontal: theme.wp(3),
                ),
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: theme.cardBorderRadius,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      baseColor,
                      theme.accentColor.withValues(alpha: 0.15),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: shadowDark.withValues(alpha: 0.7),
                      offset: Offset(4, 4),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      color: shadowLight,
                      offset: Offset(-4, -4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.confirmation_number_rounded,
                      color: theme.accentColor,
                      size: theme.wp(6),
                    ),
                    SizedBox(width: theme.wp(2)),
                    Text(
                      '${widget.tickets}',
                      style: GoogleFonts.poppins(
                        color: theme.textPrimaryColor,
                        fontSize: theme.sp(4.5),
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildNeumorphicMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required AppTheme theme,
    required Color baseColor,
    required Color shadowDark,
    required Color shadowLight,
    required Color highlightColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: theme.cardBorderRadius,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: theme.hp(1.8),
          horizontal: theme.wp(5),
        ),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: theme.cardBorderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [baseColor, highlightColor.withValues(alpha: 0.05)],
          ),
          boxShadow: [
            BoxShadow(
              color: shadowDark.withValues(alpha: 0.7),
              offset: Offset(3, 3),
              blurRadius: 5,
            ),
            BoxShadow(
              color: shadowLight,
              offset: Offset(-3, -3),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: highlightColor, size: theme.wp(5.5)),
            SizedBox(width: theme.wp(5)),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: theme.textPrimaryColor,
                fontSize: theme.sp(4),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: theme.textSecondaryColor,
              size: theme.wp(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(AppTheme theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.hp(2.5)),
      child: Divider(
        color: theme.textSecondaryColor.withValues(alpha: 0.2),
        thickness: 0.5,
      ),
    );
  }

  Widget _buildNeumorphicButton(
    BuildContext context,
    String text, {
    required IconData icon,
    required bool isSmall,
    required AppTheme theme,
    required Color baseColor,
    required Color shadowDark,
    required Color shadowLight,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        isSmall ? theme.wp(2.5) : theme.wp(3.5),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isSmall ? theme.hp(1) : theme.hp(1.8),
          horizontal: isSmall ? theme.wp(3) : theme.wp(5),
        ),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(
            isSmall ? theme.wp(2.5) : theme.wp(3.5),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [baseColor, theme.primaryColor.withValues(alpha: 0.1)],
          ),
          boxShadow: [
            BoxShadow(
              color: shadowDark.withValues(alpha: 0.7),
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
            BoxShadow(
              color: shadowLight,
              offset: Offset(-2, -2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: theme.primaryColor,
              size: isSmall ? theme.wp(4) : theme.wp(5.5),
            ),
            SizedBox(width: theme.wp(2)),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: theme.textPrimaryColor,
                fontSize: isSmall ? theme.sp(3.5) : theme.sp(4),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    AppTheme theme,
    Color baseColor,
    Color shadowDark,
    Color shadowLight,
  ) {
    return InkWell(
      onTap: () {
        // Handle logout logic here
        Provider.of<UserProvider>(context, listen: false).logout();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      borderRadius: theme.buttonBorderRadius,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: theme.hp(2)),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: theme.buttonBorderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [baseColor, theme.errorColor.withValues(alpha: 0.15)],
          ),
          boxShadow: [
            BoxShadow(
              color: shadowDark.withValues(alpha: 0.7),
              offset: Offset(4, 4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: shadowLight,
              offset: Offset(-4, -4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: theme.errorColor,
              size: theme.wp(5),
            ),
            SizedBox(width: theme.wp(2.5)),
            Text(
              'Logout',
              style: GoogleFonts.poppins(
                color: theme.errorColor,
                fontSize: theme.sp(4.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
