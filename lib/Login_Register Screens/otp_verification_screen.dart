import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tambola/Screens/home_page.dart';
import 'package:tambola/Theme/app_theme.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String username;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.username,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with CodeAutoFill {
  // Constants for SharedPreferences
  static const String KEY_PHONE = 'phone_number';
  static const String KEY_USERNAME = 'username';
  static const String KEY_IS_AUTHENTICATED = 'is_authenticated';
  static const String KEY_AUTH_TOKEN = 'auth_token';
  // static const String KEY_USER_ID = 'user_id';

  bool _smsListenerRegistered = false;

  // Controllers and variables
  SharedPreferences? _prefs;
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  bool _isLoading = false;
  final List<bool> _otpFilled = List.generate(6, (_) => false);
  String _otpCode = "";
  bool _isResendActive = false;
  int _resendTimer = 30;

  // Colors

  @override
  void initState() {
    super.initState();
    _initPrefs();
    printAppSignature(); // Print app signature for debugging
    initSmsListener();
    _startResendTimer();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    // Safely unregister the SMS listener
    try {
      // Check if the widget is still mounted before unregistering
      if (mounted) {
        SmsAutoFill().unregisterListener().catchError((error) {
          debugPrint("Error unregistering SMS listener: $error");
        });
      }
    } catch (e) {
      debugPrint("Exception during SMS listener unregistration: $e");
    }

    // Cancel other operations
    try {
      cancel();
    } catch (e) {
      debugPrint("Error canceling code auto fill: $e");
    }

    // Dispose controllers
    for (var controller in _otpControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (_resendTimer > 0) {
            _resendTimer--;
            _startResendTimer();
          } else {
            _isResendActive = true;
          }
        });
      }
    });
  }

  Future<void> printAppSignature() async {
    final signature = await SmsAutoFill().getAppSignature;
    debugPrint("App Signature: $signature");
  }

  Future<void> initSmsListener() async {
    if (_smsListenerRegistered) {
      debugPrint("SMS listener already registered, skipping");
      return;
    }

    try {
      await SmsAutoFill().listenForCode();
      _smsListenerRegistered = true;
      final signature = await SmsAutoFill().getAppSignature;
      debugPrint("App Signature: $signature");
    } catch (e) {
      debugPrint("SMS Listener Error: $e");
    }
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 6) {
      setState(() {
        _otpCode = code!;
        for (int i = 0; i < 6; i++) {
          _otpControllers[i].text = _otpCode[i];
          _otpFilled[i] = true;
        }
      });
      // Auto-verify after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        _verifyOtp();
      });
    }
  }

  Future<void> _initPrefs() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('Storage initialization: $e');
    }
  }

  Future<void> _verifyOtp() async {
    setState(() => _isLoading = true);
    final otp = _otpControllers.map((controller) => controller.text).join();

    try {
      debugPrint('\n=== OTP Verification Request ===');
      debugPrint('Sending verification request with data:');
      debugPrint('Phone: ${widget.phoneNumber}');
      debugPrint('OTP: $otp');
      debugPrint('Username: ${widget.username}');

      final response = await http.post(
        Uri.parse('https://app.houziee.in/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': widget.phoneNumber,
          'otp': otp,
          'name': widget.username,
        }),
      );

      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        debugPrint('Decoded response data: $responseData');

        final authToken = responseData['token'];
        final userData = responseData['user'];

        if (authToken == null || userData == null) {
          throw Exception('Invalid response format');
        }

        final userId = userData['id']?.toString();
        if (userId == null) {
          throw Exception('User ID missing in response');
        }

        debugPrint('Saving user data:');
        debugPrint('User ID: $userId');
        debugPrint('Username: ${userData['name']}');
        debugPrint('Phone: ${userData['phone']}');

        await saveUserData(
          phoneNumber: userData['phone'],
          username: userData['name'],
          authToken: authToken,
          userId: userId,
        );

        debugPrint(
          "Data saved. Phone: ${userData['phone']} | Username: ${userData['name']}",
        );

        if (mounted) {
          await Future.delayed(const Duration(milliseconds: 300));
          // Navigate to home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HousieeGameApp()),
          );
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Verification failed');
      }
    } catch (e) {
      debugPrint('Verification error: $e');
      if (mounted) {
        _showErrorSnackBar('Verification failed: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      debugPrint('=== OTP Verification End ===\n');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme().errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> saveUserData({
    required String phoneNumber,
    required String username,
    required String authToken,
    required String userId,
  }) async {
    await _initPrefs();

    if (_prefs != null) {
      try {
        // Save phone and username
        final phoneSaved = await _prefs!.setString(KEY_PHONE, phoneNumber);
        final usernameSaved = await _prefs!.setString(KEY_USERNAME, username);
        // final userIdSaved = await _prefs!.setString(KEY_USER_ID, userId);
        final tokenSaved = await _prefs!.setString(KEY_AUTH_TOKEN, authToken);
        final authSaved = await _prefs!.setBool(KEY_IS_AUTHENTICATED, true);

        if (!phoneSaved || !usernameSaved || !tokenSaved || !authSaved) {
          debugPrint('Failed to save user data');
          throw Exception('Failed to save data');
        }

        debugPrint('User data saved successfully.');
        debugPrint('Authentication state set to TRUE');
      } catch (e) {
        debugPrint('Storage error: $e');
        throw Exception('Failed to save user data: $e');
      }
    } else {
      debugPrint('SharedPreferences not initialized.');
    }
  }

  Future<void> _resendOtp() async {
    if (!_isResendActive) return;

    setState(() {
      _isResendActive = false;
      _resendTimer = 30;
    });

    _startResendTimer();

    try {
      final response = await http.post(
        Uri.parse('https://app.houziee.in/api/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': widget.username,
          'phone': widget.phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        _showSuccessSnackBar('OTP sent successfully!');
        // Reset the SMS listener after resend
        await initSmsListener();
      } else {
        final errorData = json.decode(response.body);
        _showErrorSnackBar(errorData['error'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      _showErrorSnackBar('Network error. Please check your connection.');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onOtpFieldChanged(String value, int index) {
    if (value.isNotEmpty) {
      setState(() {
        _otpFilled[index] = true;
      });

      if (index < 5) {
        FocusScope.of(context).nextFocus();
      } else {
        // When the last field is filled, check if all fields are filled
        bool allFilled = _otpControllers.every(
          (controller) => controller.text.isNotEmpty,
        );
        if (allFilled) {
          // Auto verify when all fields are filled
          _verifyOtp();
        }
      }
    } else {
      setState(() {
        _otpFilled[index] = false;
      });

      if (index > 0) {
        FocusScope.of(context).previousFocus();
      }
    }
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: 50,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color:
            _otpFilled[index]
                ? AppTheme().primaryColor.withValues(alpha: 0.1)
                : AppTheme().cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _otpFilled[index] ? AppTheme().primaryColor : Colors.transparent,
          width: 2,
        ),
        boxShadow:
            _otpFilled[index]
                ? [
                  BoxShadow(
                    color: AppTheme().primaryColor.withValues(alpha: 0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
                : null,
      ),
      child: TextField(
        controller: _otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: GoogleFonts.poppins(
          fontSize: AppTheme().headingStyle.fontSize,
          fontWeight: FontWeight.bold,
          color: AppTheme().textPrimaryColor,
        ),
        cursorColor: AppTheme().primaryColor,
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        onChanged: (value) => _onOtpFieldChanged(value, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme().backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme().textPrimaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "OTP Verification",
            style: AppTheme().headingStyle.copyWith(
              color: AppTheme().textPrimaryColor,
              fontSize: screenHeight * 0.025,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(gradient: AppTheme().backgroundGradient),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  left: screenHeight * 0.025,
                  right: screenHeight * 0.020,
                  bottom:
                      keyboardHeight > screenHeight * 0
                          ? keyboardHeight
                          : screenHeight * 0.020,
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    // Houziee illustration
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Lottie.asset(
                        'assets/OTP.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Title and description
                    Text(
                      "Verification Code",
                      style: AppTheme().headingStyle.copyWith(
                        fontSize: screenHeight * 0.027,
                        color: AppTheme().textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.010),
                    Text(
                      "We have sent a verification code to\n ${widget.phoneNumber}",
                      textAlign: TextAlign.center,
                      style: AppTheme().captionStyle.copyWith(
                        fontSize: screenHeight * 0.015,
                        color: AppTheme().textSecondaryColor,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // OTP input fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        6,
                        (index) => _buildOtpField(index),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Verify button
                    SizedBox(
                      width: screenWidth * 0.45,
                      height: screenHeight * 0.065,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme().primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          shadowColor: AppTheme().primaryColor.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        child:
                            _isLoading
                                ? SizedBox(
                                  width: screenWidth * 0.5,
                                  height: screenHeight * 0.5,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                : Text(
                                  "Verify",
                                  style: AppTheme().buttonTextStyle.copyWith(
                                    fontSize: screenHeight * 0.019,
                                    color: AppTheme().textPrimaryColor,
                                  ),
                                ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.020),

                    // Resend OTP section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code? ",
                          style: AppTheme().captionStyle.copyWith(
                            fontSize: screenHeight * 0.013,
                            color: AppTheme().textSecondaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: _isResendActive ? _resendOtp : null,
                          child: Text(
                            _isResendActive
                                ? "Resend OTP"
                                : "OTP sent successfully $_resendTimer s",
                            style: AppTheme().linkStyle.copyWith(
                              fontSize: screenHeight * 0.014,
                              color:
                                  _isResendActive
                                      ? AppTheme().primaryColor
                                      : AppTheme().accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Help text
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppTheme().cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme().primaryColor.withValues(alpha: 0.3),
                          width: screenWidth * 0.013,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppTheme().primaryColor,
                                size: screenHeight * 0.025,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Need Help?",
                                style: AppTheme().subheadingStyle.copyWith(
                                  fontSize: screenHeight * 0.018,
                                  color: AppTheme().textPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "• Make sure your mobile number is correct\n• Check your SMS inbox for the verification code\n• It may take a moment for the code to arrive",
                            style: AppTheme().captionStyle.copyWith(
                              fontSize: screenHeight * 0.014,
                              color: AppTheme().textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
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
