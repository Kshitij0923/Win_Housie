import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:tambola/Theme/app_theme.dart';

class HouzieeProfileScreen extends StatefulWidget {
  final String username;
  final String email;
  final String? phone;
  final int coins;
  final int tickets;
  final int gamesPlayed;
  final int gamesWon;

  const HouzieeProfileScreen({
    Key? key,
    this.username = "Harshal",
    this.email = "hj90300@gmail.com",
    this.phone,
    this.coins = 1250,
    this.tickets = 8,
    this.gamesPlayed = 42,
    this.gamesWon = 15,
  }) : super(key: key);

  @override
  State<HouzieeProfileScreen> createState() => _HouzieeProfileScreenState();
}

class _HouzieeProfileScreenState extends State<HouzieeProfileScreen>
    with TickerProviderStateMixin {
  final theme = AppTheme();
  final ImagePicker _picker = ImagePicker();

  // Controllers
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  // Animation controllers
  late AnimationController _animationController;
  late AnimationController _profileImageAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // State variables
  bool isEditing = false;
  File? _profileImage;
  String? _profileImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
    _loadProfileImage();
  }

  void _initializeControllers() {
    _usernameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone ?? '');
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _profileImageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image_path');
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _profileImagePath = imagePath;
        _profileImage = File(imagePath);
      });
    }
  }

  Future<void> _saveProfileImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', imagePath);
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _isLoading = true;
        });

        await Future.delayed(
          const Duration(milliseconds: 300),
        ); // Loading effect

        setState(() {
          _profileImage = File(image.path);
          _profileImagePath = image.path;
          _isLoading = false;
        });

        await _saveProfileImage(image.path);
        _profileImageAnimationController.forward().then((_) {
          _profileImageAnimationController.reverse();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          theme.createSnackBar(
            message: 'Profile picture updated successfully!',
            backgroundColor: theme.successColor,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        theme.createSnackBar(
          message: 'Failed to pick image. Please try again.',
          backgroundColor: theme.errorColor,
        ),
      );
    }
  }

  Future<void> _showImagePickerOptions() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.textSecondaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Choose Profile Picture',
                  style: theme.subheadingStyle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageOption(
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage();
                      },
                    ),
                    _buildImageOption(
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImageFromCamera();
                      },
                    ),
                    if (_profileImage != null)
                      _buildImageOption(
                        icon: Icons.delete_rounded,
                        label: 'Remove',
                        color: theme.errorColor,
                        onTap: () {
                          Navigator.pop(context);
                          _removeProfileImage();
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final optionColor = color ?? theme.primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: optionColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: optionColor.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: optionColor, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: optionColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _isLoading = true;
        });

        await Future.delayed(const Duration(milliseconds: 300));

        setState(() {
          _profileImage = File(image.path);
          _profileImagePath = image.path;
          _isLoading = false;
        });

        await _saveProfileImage(image.path);

        ScaffoldMessenger.of(context).showSnackBar(
          theme.createSnackBar(
            message: 'Profile picture captured successfully!',
            backgroundColor: theme.successColor,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        theme.createSnackBar(
          message: 'Failed to capture image. Please try again.',
          backgroundColor: theme.errorColor,
        ),
      );
    }
  }

  Future<void> _removeProfileImage() async {
    setState(() {
      _profileImage = null;
      _profileImagePath = null;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image_path');

    ScaffoldMessenger.of(context).showSnackBar(
      theme.createSnackBar(
        message: 'Profile picture removed',
        backgroundColor: theme.warningColor,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    _profileImageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme.init(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildCustomAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 20),
                    _buildAchievementsSection(),
                    const SizedBox(height: 20),
                    _buildActionButtons(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return SliverAppBar(
      floating: false,
      pinned: true,
      backgroundColor: theme.appBarColor,
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: ShaderMask(
          shaderCallback:
              (bounds) => theme.appBarTitleGradient.createShader(bounds),
          child: ShimmerText(
            text: 'My Profile',
            style: theme.appBarTitleStyle.copyWith(fontSize: 22),
          ),
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient:
                isEditing
                    ? LinearGradient(
                      colors: [
                        theme.successColor,
                        theme.successColor.withOpacity(0.8),
                      ],
                    )
                    : theme.primaryGradient,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: (isEditing ? theme.successColor : theme.primaryColor)
                    .withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              isEditing ? Icons.check_rounded : Icons.edit_rounded,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
                if (!isEditing) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    theme.createSnackBar(
                      message: 'Profile updated successfully! 🎉',
                      backgroundColor: theme.successColor,
                    ),
                  );
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.cardColor, theme.cardColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildProfilePicture(),
          const SizedBox(height: 20),
          _buildUserInfo(),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [theme.primaryColor.withOpacity(0.3), Colors.transparent],
            ),
            shape: BoxShape.circle,
          ),
        ),
        // Animated border ring
        AnimatedBuilder(
          animation: _profileImageAnimationController,
          builder: (context, child) {
            return Container(
              width: 105 + (_profileImageAnimationController.value * 8),
              height: 105 + (_profileImageAnimationController.value * 8),
              decoration: BoxDecoration(
                gradient: theme.primaryGradient,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.cardColor,
                        theme.cardColor.withOpacity(0.9),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child:
                        _isLoading
                            ? _buildLoadingIndicator()
                            : _profileImage != null
                            ? Image.file(
                              _profileImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                            : _buildDefaultAvatar(),
                  ),
                ),
              ),
            );
          },
        ),
        // Camera button
        Positioned(
          bottom: 5,
          right: 5,
          child: GestureDetector(
            onTap: _showImagePickerOptions,
            child: Container(
              decoration: BoxDecoration(
                gradient: theme.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          widget.username.isNotEmpty ? widget.username[0].toUpperCase() : "H",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        // Online status
        const SizedBox(height: 16),

        // Username
        isEditing
            ? _buildEditableField(
              controller: _usernameController,
              hint: 'Username',
              icon: Icons.person_rounded,
            )
            : Text(
              _usernameController.text,
              style: theme.headingStyle.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

        const SizedBox(height: 10),

        // Phone
        if (isEditing || _phoneController.text.isNotEmpty)
          isEditing
              ? _buildEditableField(
                controller: _phoneController,
                hint: 'Phone Number',
                icon: Icons.phone_rounded,
              )
              : _buildInfoRow(Icons.phone_rounded, _phoneController.text),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: theme.textSecondaryColor, size: 16),
        const SizedBox(width: 8),
        Text(text, style: theme.captionStyle.copyWith(fontSize: 14)),
      ],
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.poppins(color: theme.textPrimaryColor, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            color: theme.textSecondaryColor.withOpacity(0.6),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: theme.primaryColor.withOpacity(0.8),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: theme.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.military_tech_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Achievements',
                style: theme.subheadingStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAchievementItem(
            'First Victory',
            'Won your first Houziee game',
            Icons.emoji_events_rounded,
            theme.successColor,
          ),
          _buildAchievementItem(
            'Coin Master',
            'Earned 1000+ coins',
            Icons.monetization_on_rounded,
            Colors.amber[700]!,
          ),
          _buildAchievementItem(
            'Game Champion',
            'Played 40+ games',
            Icons.gamepad_rounded,
            theme.infoColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: theme.textPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    color: theme.textSecondaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, color: color, size: 20),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildActionButton(
            title: 'Settings',
            icon: Icons.settings_rounded,
            gradient: LinearGradient(
              colors: [
                theme.textSecondaryColor.withOpacity(0.8),
                theme.textSecondaryColor,
              ],
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                theme.createSnackBar(
                  message: 'Settings coming soon!',
                  backgroundColor: theme.infoColor,
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            title: 'Invite Friends',
            icon: Icons.group_add_rounded,
            gradient: LinearGradient(
              colors: [theme.accentColor, theme.accentColor.withOpacity(0.8)],
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                theme.createSnackBar(
                  message: 'Invite feature coming soon!',
                  backgroundColor: theme.accentColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const ShimmerText({Key? key, required this.text, required this.style})
    : super(key: key);

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -0.5, end: 1.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: const [
                Colors.white,
                Colors.white,
                Colors.white70,
                Colors.white,
              ],
              stops: const [0.0, 0.4, 0.6, 1.0],
            ).createShader(bounds);
          },
          child: Text(widget.text, style: widget.style),
        );
      },
    );
  }
}
