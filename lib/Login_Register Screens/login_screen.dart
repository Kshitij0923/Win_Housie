import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tambola/Login_Register%20Screens/otp_verification_screen.dart';
import 'package:tambola/Login_Register%20Screens/register_screen.dart';
import 'package:tambola/Login_Register%20Screens/start_page.dart';
import 'package:tambola/Provider/Controller/api_provider.dart';
import 'package:tambola/Theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers and focus nodes
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();

  // Form state variables
  bool _isLoading = false;
  bool _isFormValid = false;

  // Colors - Enhanced color scheme for better harmony
  final Color _primaryColor = const Color(0xFF6C63FF); // Main purple
  final Color _accentColor = const Color(0xFFFF6584); // Pink accent
  final Color _backgroundColor = const Color(0xFF121212); // Dark background
  final Color _cardColor = const Color(0xFF1E1E1E); // Slightly lighter card
  final Color _animationBgColor = const Color(
    0xFF1A1A1A,
  ); // Animation background
  final Color _textPrimaryColor = Colors.white;
  final Color _textSecondaryColor = Colors.grey.shade300;

  @override
  void initState() {
    super.initState();
    // Add listeners to check form validity
    _phoneController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    // Dispose controllers
    _phoneController.dispose();
    // Dispose focus nodes
    _phoneFocus.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    final bool isValid =
        _phoneController.text.isNotEmpty && _phoneController.text.length >= 10;
    setState(() {
      _isFormValid = isValid;
    });
  }

  Future<void> _login() async {
    if (!_isFormValid) {
      _showErrorSnackBar('Please enter a valid phone number');
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
      debugPrint('\n=== Login Request ===');
      debugPrint('Sending login request with phone: $phoneNumber');

      final provider = Provider.of<AuthProvider>(context, listen: false);
      final result = await provider.loginUser(phone: phoneNumber);

      if (result['success']) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => OtpVerificationScreen(
                    phoneNumber: phoneNumber,
                    username: '', // No username needed for login
                  ),
            ),
          );
        }
      } else {
        _showErrorSnackBar(result['message']);
      }
    } catch (e) {
      debugPrint('Login error: $e');
      if (mounted) {
        _showErrorSnackBar('Login failed: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      debugPrint('=== Login End ===\n');
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
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.done,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: GoogleFonts.poppins(color: _textPrimaryColor, fontSize: 16),
      cursorColor: _primaryColor,
      decoration: _buildInputDecoration(hintText, icon),
      onFieldSubmitted: (_) {
        if (_isFormValid) {
          _login();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

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
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
        ),
        title: Text(
          "Log in to your account",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _textPrimaryColor,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: BoxDecoration(gradient: AppTheme().backgroundGradient),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: keyboardHeight > 0 ? keyboardHeight : 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  // Enhanced animation container
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
                          borderRadius: BorderRadius.circular(20),
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
                  SizedBox(height: screenHeight * 0.03),
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
                    child: Text(
                      "Win Housie",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Subtitle
                  Text(
                    "Enter your phone number to continue",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: _textSecondaryColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  // Phone field
                  _buildTextField(
                    hintText: "Phone Number",
                    icon: Icons.phone,
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 28),
                  // Enhanced Login button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    width: double.infinity,
                    height: 55,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient:
                            _isLoading || !_isFormValid
                                ? LinearGradient(
                                  colors: [
                                    Colors.grey.shade800,
                                    Colors.grey.shade600,
                                  ],
                                )
                                : const LinearGradient(
                                  colors: [
                                    Color(0xFF6C63FF), // _primaryColor
                                    Color(0xFFFF6584), // _accentColor
                                  ],
                                ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading || !_isFormValid ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  "Get OTP",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color:
                                        _isLoading || !_isFormValid
                                            ? Colors.grey
                                            : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Register option with enhanced styling
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: _cardColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: _textSecondaryColor,
                          ),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: _accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
