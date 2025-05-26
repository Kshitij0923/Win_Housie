import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tambola/Theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final theme = AppTheme();

  // Settings state
  bool darkMode = true;
  bool soundEffects = true;
  bool music = true;
  bool notifications = true;
  bool gameInvites = true;
  bool isActive = true; // Added active status
  String language = 'English';

  @override
  void initState() {
    super.initState();
    // Initialize responsive sizes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        theme.init(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppTheme().createAppBar(
        title: "Settings",
        titleStyle: TextStyle(fontSize: 22),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildGeneralSection(),
              const SizedBox(height: 24),
              _buildSoundSection(),
              const SizedBox(height: 24),
              _buildNotificationsSection(),
              const SizedBox(height: 24),
              _buildAccountSection(),
              const SizedBox(height: 24),
              _buildSupportSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: theme.textPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    ValueChanged<bool>? onChanged,
    bool isLast = false,
    Color? iconColor,
    Color? activeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border:
            !isLast
                ? Border(
                  bottom: BorderSide(
                    color: theme.textSecondaryColor.withOpacity(0.08),
                    width: 1,
                  ),
                )
                : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (iconColor ?? theme.primaryColor).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor ?? theme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: theme.textPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        color: theme.textSecondaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor ?? theme.primaryColor,
            activeTrackColor: (activeColor ?? theme.primaryColor).withOpacity(
              0.3,
            ),
            inactiveThumbColor: theme.textSecondaryColor.withOpacity(0.5),
            inactiveTrackColor: theme.textSecondaryColor.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    String? subtitle,
    String? value,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border:
              !isLast
                  ? Border(
                    bottom: BorderSide(
                      color: theme.textSecondaryColor.withOpacity(0.08),
                      width: 1,
                    ),
                  )
                  : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: theme.primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: theme.textPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          color: theme.textSecondaryColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (value != null)
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: theme.textSecondaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: theme.textSecondaryColor.withOpacity(0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('General'),
        _buildSettingsCard(
          children: [
            _buildToggleItem(
              icon: Icons.circle,
              title: 'Active Status',
              subtitle:
                  isActive
                      ? 'You appear online to other players'
                      : 'You appear offline to other players',
              value: isActive,
              iconColor: isActive ? Colors.green : Colors.grey,
              activeColor: Colors.green,
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    isActive = value;
                  });
                  // You can add logic here to update server status
                  _updateActiveStatus(value);
                }
              },
            ),
            _buildToggleItem(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: 'Switch between light and dark theme',
              value: darkMode,
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    darkMode = value;
                  });
                }
              },
            ),
            _buildNavigationItem(
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: 'Change app language',
              value: language,
              onTap: _showLanguageBottomSheet,
              isLast: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSoundSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Sound'),
        _buildSettingsCard(
          children: [
            _buildToggleItem(
              icon: Icons.volume_up_outlined,
              title: 'Sound Effects',
              subtitle: 'Play sounds for game actions',
              value: soundEffects,
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    soundEffects = value;
                  });
                }
              },
            ),
            _buildToggleItem(
              icon: Icons.music_note_outlined,
              title: 'Background Music',
              subtitle: 'Play background music',
              value: music,
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    music = value;
                  });
                }
              },
              isLast: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Notifications'),
        _buildSettingsCard(
          children: [
            _buildToggleItem(
              icon: Icons.notifications_outlined,
              title: 'Push Notifications',
              subtitle: 'Receive app notifications',
              value: notifications,
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    notifications = value;
                    if (!value) {
                      gameInvites = false;
                    }
                  });
                }
              },
            ),
            _buildToggleItem(
              icon: Icons.games_outlined,
              title: 'Game Invites',
              subtitle: 'Get notified about game invites',
              value: gameInvites,
              onChanged:
                  notifications
                      ? (value) {
                        if (mounted) {
                          setState(() {
                            gameInvites = value;
                          });
                        }
                      }
                      : null,
              isLast: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Account'),
        _buildSettingsCard(
          children: [
            _buildNavigationItem(
              icon: Icons.person_outline,
              title: 'Profile',
              subtitle: 'Edit profile information',
              onTap: () {
                // Navigate to profile screen
                debugPrint('Navigate to profile screen');
              },
            ),
            _buildNavigationItem(
              icon: Icons.lock_outline,
              title: 'Privacy & Security',
              subtitle: 'Manage your privacy settings',
              onTap: () {
                // Navigate to privacy settings
                debugPrint('Navigate to privacy settings');
              },
              isLast: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Support'),
        _buildSettingsCard(
          children: [
            _buildNavigationItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'Get help and support',
              onTap: () {
                // Navigate to help center
                debugPrint('Navigate to help center');
              },
            ),
            _buildNavigationItem(
              icon: Icons.feedback_outlined,
              title: 'Send Feedback',
              subtitle: 'Share your thoughts with us',
              onTap: () {
                // Navigate to feedback
                debugPrint('Navigate to feedback');
              },
            ),
            _buildNavigationItem(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App version and information',
              onTap: () {
                _showAboutDialog();
              },
              isLast: true,
            ),
          ],
        ),
      ],
    );
  }

  // Method to handle active status updates
  void _updateActiveStatus(bool isActive) {
    // Add your logic here to update server/database
    debugPrint('Active status updated: $isActive');

    // You might want to:
    // 1. Update user status in database
    // 2. Notify other players
    // 3. Update UI in other screens
    // 4. Handle socket connections for real-time updates

    // Example API call (uncomment and modify as needed):
    // try {
    //   await UserService.updateActiveStatus(isActive);
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(isActive ? 'You are now online' : 'You are now offline'),
    //         backgroundColor: isActive ? Colors.green : Colors.grey,
    //       ),
    //     );
    //   }
    // } catch (e) {
    //   debugPrint('Error updating active status: $e');
    // }
  }

  void _showLanguageBottomSheet() {
    if (!mounted) return;

    final languages = [
      {'name': 'English', 'code': 'en'},
      {'name': 'Spanish', 'code': 'es'},
      {'name': 'French', 'code': 'fr'},
      {'name': 'German', 'code': 'de'},
      {'name': 'Hindi', 'code': 'hi'},
      {'name': 'Chinese', 'code': 'zh'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder:
          (context) => Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.textSecondaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Select Language',
                  style: GoogleFonts.poppins(
                    color: theme.textPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children:
                        languages.map((lang) {
                          final isSelected = lang['name'] == language;
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                            ),
                            title: Text(
                              lang['name']!,
                              style: GoogleFonts.poppins(
                                color:
                                    isSelected
                                        ? theme.primaryColor
                                        : theme.textPrimaryColor,
                                fontSize: 16,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                              ),
                            ),
                            trailing:
                                isSelected
                                    ? Icon(
                                      Icons.check_circle,
                                      color: theme.primaryColor,
                                      size: 20,
                                    )
                                    : null,
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  language = lang['name']!;
                                });
                                Navigator.pop(context);
                              }
                            },
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  void _showAboutDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: theme.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.games_rounded,
                    color: theme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'About Houziee',
                    style: GoogleFonts.poppins(
                      color: theme.textPrimaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Version 1.0.0',
                  style: GoogleFonts.poppins(
                    color: theme.textSecondaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Win Housie',
                  style: GoogleFonts.poppins(
                    color: theme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '©️ 2025 Taruna infosoft Pvt Ltd.',
                  style: GoogleFonts.poppins(
                    color: theme.textSecondaryColor.withOpacity(0.8),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(
                    color: theme.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
