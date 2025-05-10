import 'package:flutter/material.dart';

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
    // Base colors for neumorphic design
    Color baseColor = const Color.fromARGB(255, 200, 170, 246);
    Color shadowDark = const Color.fromARGB(255, 2, 2, 2);
    Color shadowLight = const Color.fromARGB(255, 188, 137, 242);

    return Drawer(
      backgroundColor: Colors.purple[100],
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(baseColor, shadowDark, shadowLight),
            const SizedBox(height: 15),
            _buildBalanceInfo(baseColor, shadowDark, shadowLight),
            const SizedBox(height: 25),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildNeumorphicMenuItem(
                    icon: Icons.home_rounded,
                    title: 'Home',
                    baseColor: Colors.white,
                    shadowDark: shadowDark,
                    shadowLight: shadowLight,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 15),
                  _buildNeumorphicMenuItem(
                    icon: Icons.person_rounded,
                    title: 'My Profile',
                    baseColor: Colors.white,
                    shadowDark: shadowDark,
                    shadowLight: shadowLight,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to profile
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildNeumorphicMenuItem(
                    icon: Icons.history_rounded,
                    title: 'Game History',
                    baseColor: Colors.white,
                    shadowDark: shadowDark,
                    shadowLight: shadowLight,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to game history
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildNeumorphicMenuItem(
                    icon: Icons.card_giftcard_rounded,
                    title: 'My Rewards',
                    baseColor: Colors.white,
                    shadowDark: shadowDark,
                    shadowLight: shadowLight,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to rewards
                    },
                  ),
                  _buildDivider(),
                  _buildNeumorphicMenuItem(
                    icon: Icons.shopping_cart_rounded,
                    title: 'Buy Tickets',
                    baseColor: Colors.white,
                    shadowDark: shadowDark,
                    shadowLight: shadowLight,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to ticket purchase
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildNeumorphicMenuItem(
                    icon: Icons.attach_money_rounded,
                    title: 'Add Coins',
                    baseColor: Colors.white,
                    shadowDark: shadowDark,
                    shadowLight: shadowLight,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to add coins
                    },
                  ),
                  _buildDivider(),
                  _buildNeumorphicMenuItem(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    baseColor: Colors.white,
                    shadowDark: shadowDark,
                    shadowLight: shadowLight,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to settings
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildNeumorphicMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    baseColor: Colors.white,
                    shadowDark: shadowDark,
                    shadowLight: shadowLight,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to help
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: _buildLogoutButton(baseColor, shadowDark, shadowLight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color baseColor, Color shadowDark, Color shadowLight) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Neumorphic avatar
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: shadowDark,
                      offset: const Offset(4, 4),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      color: shadowLight,
                      offset: const Offset(-4, -4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child:
                    avatarUrl.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: Image.network(avatarUrl, fit: BoxFit.cover),
                        )
                        : Center(
                          child: Text(
                            username.isNotEmpty
                                ? username[0].toUpperCase()
                                : "P",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
              ),
              const SizedBox(width: 20),
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      email,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    // Edit profile button
                    _buildNeumorphicButton(
                      'Edit Profile',
                      icon: Icons.edit,
                      isSmall: true,
                      baseColor: Colors.white,
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
    Color baseColor,
    Color shadowDark,
    Color shadowLight,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Coins container
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: shadowDark,
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: shadowLight,
                    offset: const Offset(-4, -4),
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
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$coins',
                    style: TextStyle(
                      color: Colors.blueGrey[800],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Tickets container
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: shadowDark,
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: shadowLight,
                    offset: const Offset(-4, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.confirmation_number_rounded,
                    color: Colors.purple[700],
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$tickets',
                    style: TextStyle(
                      color: Colors.blueGrey[800],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeumorphicMenuItem({
    required IconData icon,
    required String title,
    required Color baseColor,
    required Color shadowDark,
    required Color shadowLight,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: shadowDark.withValues(alpha: 0.7),
              offset: const Offset(3, 3),
              blurRadius: 5,
            ),
            BoxShadow(
              color: shadowLight,
              offset: const Offset(-3, -3),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueGrey[700], size: 22),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.blueGrey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Divider(color: Color(0xFFA3B1C6), thickness: 0.5),
    );
  }

  Widget _buildNeumorphicButton(
    String text, {
    required IconData icon,
    required bool isSmall,
    required Color baseColor,
    required Color shadowDark,
    required Color shadowLight,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isSmall ? 10 : 15),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isSmall ? 5 : 12,
          horizontal: isSmall ? 10 : 20,
        ),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(isSmall ? 10 : 15),
          boxShadow: [
            BoxShadow(
              color: shadowDark.withValues(alpha: 0.7),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
            BoxShadow(
              color: shadowLight,
              offset: const Offset(-2, -2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.blueGrey[700], size: isSmall ? 16 : 22),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontSize: isSmall ? 12 : 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    Color baseColor,
    Color shadowDark,
    Color shadowLight,
  ) {
    return InkWell(
      onTap: () {
        // Logout action
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: shadowDark.withValues(alpha: 0.7),
              offset: const Offset(4, 4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: shadowLight,
              offset: const Offset(-4, -4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent[400], size: 20),
            const SizedBox(width: 10),
            Text(
              'Logout',
              style: TextStyle(
                color: Colors.redAccent[400],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
