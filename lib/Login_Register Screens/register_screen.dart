import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tambola/Login_Register%20Screens/login_screen.dart';
import 'package:tambola/Login_Register%20Screens/otp_verification_screen.dart';
import 'package:tambola/Login_Register%20Screens/start_page.dart';
import 'package:tambola/Provider/Controller/api_provider.dart';
import 'package:tambola/Theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers and focus nodes
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _referralFocus = FocusNode();

  bool _isLoading = false;
  bool _isOver18 = false;
  bool _acceptTerms = false;
  bool _isFormValid = false;

  final Color _primaryColor = const Color(0xFF6C63FF); // Main purple
  final Color _accentColor = const Color(0xFFFF6584); // Pink accent
  final Color _backgroundColor = const Color(0xFF121212); // Dark background
  final Color _cardColor = const Color(0xFF1E1E1E); // Slightly lighter card
  final Color _animationBgColor = const Color(
    0xFF1A1A1A,
  ); // Animation background
  final LinearGradient houzieeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFF121212), // Dark background
      const Color(0xFF1E1E1E), // Card color
      const Color(0xFF6C63FF), // Primary purple
      const Color(0xFFFF6584), // Accent pink
    ],
    stops: [0.1, 0.4, 0.7, 1.0],
  );

  final Color _textPrimaryColor = Colors.white;
  final Color _textSecondaryColor = Colors.grey.shade300;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_checkFormValidity);
    _phoneController.addListener(_checkFormValidity);
    _emailController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    // Dispose controllers
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _referralController.dispose();

    // Dispose focus nodes
    _usernameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _referralFocus.dispose();

    super.dispose();
  }

  void _checkFormValidity() {
    final bool isValid =
        _usernameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _acceptTerms;

    setState(() {
      _isFormValid = isValid;
    });
  }

  Future<void> _register() async {
    if (!_isFormValid) {
      _showErrorSnackBar('Please fill all required fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String phoneNumber = _phoneController.text;
    if (!phoneNumber.startsWith('+91')) {
      phoneNumber = phoneNumber;
    }

    try {
      debugPrint('\n=== Registration Request ===');
      debugPrint('Sending registration request with data:');
      debugPrint('Username: ${_usernameController.text}');
      debugPrint('Phone: $phoneNumber');
      debugPrint('Email: ${_emailController.text}');
      debugPrint('Referral: ${_referralController.text}');

      final provider = Provider.of<AuthProvider>(context, listen: false);
      final result = await provider.registerUser(
        name: _usernameController.text,
        phone: phoneNumber,
        email: _emailController.text,
        referralCode: _referralController.text,
      );

      if (result['success']) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } else {
        _showErrorSnackBar(result['message']);
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      if (mounted) {
        _showErrorSnackBar('Registration failed: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      debugPrint('=== Registration End ===\n');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        color: _textSecondaryColor.withValues(alpha: 0.6),
        fontSize: 16,
      ),
      prefixIcon: Icon(icon, color: _primaryColor, size: 20),
      filled: true,
      fillColor: _cardColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: _textSecondaryColor.withValues(alpha: 0.1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: GoogleFonts.poppins(color: _textPrimaryColor, fontSize: 16),
      cursorColor: _primaryColor,
      decoration: _buildInputDecoration(hintText, icon),
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    theme.init(context);
    return Scaffold(
      backgroundColor: _backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: _textPrimaryColor),
          onPressed:
              () => Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder:
                      (_, animation, secondaryAnimation) => const StartPage(),
                  transitionsBuilder: (_, animation, __, child) {
                    // You can customize this transition:
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
        ),
        title: Text(
          "Create Account",
          style: theme.headingStyle.copyWith(
            color: _textPrimaryColor,
            fontSize: theme.sp(5.5),
          ),
        ),
      ),

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(gradient: theme.backgroundGradient),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  left: theme.wp(5),
                  right: theme.wp(5),
                  bottom: theme.sp(10) > 0 ? theme.sp(20) : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: theme.sp(10)),
                    Stack(
                      children: [
                        // Subtle gradient for animation background
                        Center(
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              _primaryColor.withValues(alpha: 0.5),
                              BlendMode.srcATop,
                            ),
                            child: Lottie.asset(
                              'assets/OTP.json',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        // Subtle overlay to enhance animation visibility
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(theme.sp(20)),
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 1.0,
                              colors: [
                                Colors.transparent,
                                _animationBgColor.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: theme.sp(20)),

                    // Enhanced Title with gradient
                    ShaderMask(
                      shaderCallback:
                          (bounds) => LinearGradient(
                            colors: [
                              _primaryColor,
                              _accentColor.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                      child: Text("Win Housie", style: theme.headingStyle),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Create an account to start playing!",
                      textAlign: TextAlign.center,
                      style: theme.captionStyle,
                    ),
                    SizedBox(height: theme.sp(10)),

                    // Form fields with enhanced spacing
                    _buildTextField(
                      hintText: "Full Name",
                      icon: Icons.person_outline,
                      controller: _usernameController,
                      focusNode: _usernameFocus,
                      nextFocus: _phoneFocus,
                    ),
                    SizedBox(height: theme.sp(5)),
                    _buildTextField(
                      hintText: "Phone Number",
                      icon: Icons.phone,
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      nextFocus: _emailFocus,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: theme.sp(5)),
                    _buildTextField(
                      hintText: "Email Address",
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      focusNode: _emailFocus,
                      nextFocus: _referralFocus,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: theme.sp(5)),
                    _buildTextField(
                      hintText: "Referral Code (Optional)",
                      icon: Icons.card_giftcard,
                      controller: _referralController,
                      focusNode: _referralFocus,
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: theme.sp(5)),

                    // Enhanced Checkboxes
                    Container(
                      padding: EdgeInsets.all(theme.sp(3.5)),
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(theme.sp(3)),
                        border: Border.all(
                          color: _textSecondaryColor.withValues(alpha: 0.1),
                          width: theme.sp(0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.1,
                                child: Checkbox(
                                  value: _isOver18,
                                  onChanged: (value) {
                                    setState(() {
                                      _isOver18 = value ?? false;
                                      _checkFormValidity();
                                    });
                                  },
                                  activeColor: _primaryColor,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "I confirm that I am 18 years or older",
                                  style: theme.captionStyle.copyWith(
                                    fontSize: theme.wp(3.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: theme.sp(1)),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.1,
                                child: Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _acceptTerms = value ?? false;
                                      _checkFormValidity();
                                    });
                                  },
                                  activeColor: _primaryColor,
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: "I agree to the ",
                                    style: theme.captionStyle.copyWith(
                                      fontSize: theme.wp(3.5),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Terms & Conditions",
                                        style: theme.captionStyle.copyWith(
                                          fontSize: theme.wp(3.5),
                                          color: _accentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: theme.sp(7)),

                    // Enhanced Register button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(theme.sp(5)),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withValues(alpha: 0.3),
                            blurRadius: theme.sp(5),
                            offset: const Offset(0, 5),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      width: theme.wp(40),
                      height: theme.sp(13.4),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient:
                              _isLoading || !_isFormValid
                                  ? theme.disabledGradient
                                  : theme.primaryGradient,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ElevatedButton(
                          onPressed:
                              _isLoading || !_isFormValid ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: theme.sp(2),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(theme.sp(20)),
                            ),
                          ),
                          child:
                              _isLoading
                                  ? SizedBox(
                                    width: theme.sp(24),
                                    height: theme.sp(24),
                                    child: CircularProgressIndicator(
                                      color: theme.textPrimaryColor,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text("Register", style: theme.bodyStyle),
                        ),
                      ),
                    ),
                    SizedBox(height: theme.sp(5)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _cardColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(theme.sp(5)),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: theme.captionStyle,
                            children: [
                              TextSpan(text: " Login", style: theme.linkStyle),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: theme.sp(5)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
