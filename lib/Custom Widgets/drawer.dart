import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tambola/Screens/ticket_screen.dart';
import 'package:tambola/Screens/wallet_screen.dart';
import 'package:tambola/Theme/app_theme.dart';

class NeumorphicHousieeDrawer extends StatelessWidget {
  final String username;
  final String email;
  final String avatarUrl;
  final int coins;
  final int tickets;

  const NeumorphicHousieeDrawer({
    super.key,
    this.username = "Player",
    this.email = "player@example.com",
    this.avatarUrl = "",
    this.coins = 0,
    this.tickets = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    final Color baseColor = theme.cardColor;
    final Color shadowDark = Colors.black;
    final Color shadowLight = theme.primaryColor.withValues(alpha: 0.3);
    final Color highlightColor = theme.primaryColor;

    return Drawer(
      backgroundColor: theme.backgroundColor,
      child: Container(
        decoration: BoxDecoration(gradient: theme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, theme, baseColor, shadowDark, shadowLight),
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
                        Navigator.pop(context);
                        // Navigate to profile
                      },
                    ),
                    SizedBox(height: theme.hp(2)),
                    _buildNeumorphicMenuItem(
                      context: context,
                      icon: Icons.history_rounded,
                      title: 'Game History',
                      theme: theme,
                      baseColor: baseColor,
                      shadowDark: shadowDark,
                      shadowLight: shadowLight,
                      highlightColor: highlightColor,
                      onTap: () {
                        Navigator.pop(context);
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
                            builder: (context) => const MyTicketsScreen(),
                          ),
                        );
                        // Navigate to ticket purchase
                      },
                    ),
                    SizedBox(height: theme.hp(2)),
                    _buildNeumorphicMenuItem(
                      context: context,
                      icon: Icons.attach_money_rounded,
                      title: 'Add Coins',
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
                        Navigator.pop(context);
                        // Navigate to settings
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
  ) {
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
                child:
                    avatarUrl.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(theme.wp(9)),
                          child: Image.network(avatarUrl, fit: BoxFit.cover),
                        )
                        : Center(
                          child: Text(
                            username.isNotEmpty
                                ? username[0].toUpperCase()
                                : "P",
                            style: GoogleFonts.poppins(
                              color: theme.textPrimaryColor,
                              fontSize: theme.sp(8),
                              fontWeight: FontWeight.bold,
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
                    Text(username, style: theme.subheadingStyle),
                    SizedBox(height: theme.hp(0.5)),
                    Text(email, style: theme.captionStyle),
                    SizedBox(height: theme.hp(1.5)),
                    // Edit profile button
                    _buildNeumorphicButton(
                      context,
                      'Edit Profile',
                      icon: Icons.edit,
                      isSmall: true,
                      theme: theme,
                      baseColor: baseColor,
                      shadowDark: shadowDark,
                      shadowLight: shadowLight,
                      onTap: () {
                        // Edit profile action
                      },
                    ),
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
                      '$coins',
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
                    builder: (context) => const MyTicketsScreen(),
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
                      '$tickets',
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
        // Logout action
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
