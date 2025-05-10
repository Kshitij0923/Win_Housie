import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Singleton pattern
  static final AppTheme _instance = AppTheme._internal();
  factory AppTheme() => _instance;
  AppTheme._internal();

  // Responsive heights and widths
  MediaQueryData? _mediaQueryData;
  double _screenWidth = 0;
  double _screenHeight = 0;
  double _blockSizeHorizontal = 0;
  double _blockSizeVertical = 0;

  // Safe area sizes
  double _safeAreaHorizontal = 0;
  double _safeAreaVertical = 0;
  double _safeBlockHorizontal = 0;
  double _safeBlockVertical = 0;

  bool _initialized = false;

  // Initialize responsive sizes
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData!.size.width;
    _screenHeight = _mediaQueryData!.size.height;
    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
    _safeAreaVertical =
        _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
    _safeBlockHorizontal = (_screenWidth - _safeAreaHorizontal) / 100;
    _safeBlockVertical = (_screenHeight - _safeAreaVertical) / 100;

    _initialized = true;
  }

  // Helper methods for responsive sizing with default values
  double hp(double percentage) {
    if (!_initialized) {
      return percentage * 8.0; // Default fallback value
    }
    return _blockSizeVertical * percentage;
  }

  double wp(double percentage) {
    if (!_initialized) {
      return percentage * 4.0; // Default fallback value
    }
    return _blockSizeHorizontal * percentage;
  }

  double sp(double percentage) {
    if (!_initialized) {
      return percentage * 4.0; // Default fallback value for font sizes
    }
    return _blockSizeHorizontal * percentage;
  }

  // Main colors
  final Color primaryColor = const Color(0xFF6C63FF); // Main purple
  final Color accentColor = const Color(0xFFFF6584); // Pink accent
  final Color backgroundColor = const Color(0xFF121212); // Dark background
  final Color cardColor = const Color(0xFF1E1E1E); // Slightly lighter card
  final Color animationBgColor = const Color(
    0xFF1A1A1A,
  ); // Animation background
  final Color textPrimaryColor = Colors.white;
  final Color textSecondaryColor = Colors.grey.shade300;
  final Color disabledColor = Colors.grey.shade800;
  final Color errorColor = const Color(0xFFFF5252);
  final Color successColor = const Color(0xFF4CAF50);
  final Color warningColor = const Color(0xFFFFC107);
  final Color infoColor = const Color(0xFF2196F3);

  // Gradients
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryColor, accentColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient get disabledGradient => LinearGradient(
    colors: [disabledColor, Colors.grey.shade600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.black, Colors.black87, Colors.deepPurple],
  );

  LinearGradient get houzieeGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      backgroundColor, // Dark background
      cardColor, // Card color
      primaryColor, // Primary purple
      accentColor, // Accent pink
    ],
    stops: const [0.1, 0.4, 0.7, 1.0],
  );

  // Responsive spacing
  EdgeInsets get defaultPadding =>
      EdgeInsets.symmetric(horizontal: wp(5), vertical: hp(2));

  EdgeInsets get cardPadding => EdgeInsets.all(wp(4));

  EdgeInsets get buttonPadding =>
      EdgeInsets.symmetric(horizontal: wp(5), vertical: hp(1.8));

  // Responsive border radius
  BorderRadius get defaultBorderRadius => BorderRadius.circular(wp(3));
  BorderRadius get buttonBorderRadius => BorderRadius.circular(wp(4));
  BorderRadius get cardBorderRadius => BorderRadius.circular(wp(3));

  // Text styles with responsive sizing
  TextStyle get headingStyle => GoogleFonts.poppins(
    fontSize: sp(7),
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  TextStyle get subheadingStyle => GoogleFonts.poppins(
    fontSize: sp(5),
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  TextStyle get bodyStyle =>
      GoogleFonts.poppins(fontSize: sp(4), color: textPrimaryColor);

  TextStyle get captionStyle =>
      GoogleFonts.poppins(fontSize: sp(3.5), color: textSecondaryColor);

  TextStyle get buttonTextStyle => GoogleFonts.poppins(
    fontSize: sp(4.5),
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  TextStyle get linkStyle => GoogleFonts.poppins(
    fontSize: sp(3.8),
    fontWeight: FontWeight.bold,
    color: accentColor,
  );

  // Input decoration
  InputDecoration inputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        color: textSecondaryColor.withOpacity(0.6),
        fontSize: sp(4),
      ),
      prefixIcon: Icon(icon, color: primaryColor, size: wp(5)),
      filled: true,
      fillColor: cardColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: cardBorderRadius,
        borderSide: BorderSide(color: textSecondaryColor.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: cardBorderRadius,
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: cardBorderRadius,
        borderSide: BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: cardBorderRadius,
        borderSide: BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: hp(2)),
    );
  }

  // Button styles
  ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    foregroundColor: textPrimaryColor,
    padding: buttonPadding,
    shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
  );

  // Checkbox theme
  CheckboxThemeData get checkboxTheme => CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.selected)) {
        return primaryColor;
      }
      return Colors.transparent;
    }),
    checkColor: MaterialStateProperty.all(textPrimaryColor),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(wp(1))),
    side: BorderSide(color: textSecondaryColor.withOpacity(0.6), width: 1.5),
  );

  // Card decoration
  BoxDecoration get cardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: cardBorderRadius,
    border: Border.all(color: textSecondaryColor.withOpacity(0.1), width: 1),
  );

  // Button decoration
  BoxDecoration get buttonDecoration => BoxDecoration(
    borderRadius: buttonBorderRadius,
    boxShadow: [
      BoxShadow(
        color: primaryColor.withOpacity(0.3),
        blurRadius: 15,
        offset: const Offset(0, 5),
        spreadRadius: 0,
      ),
    ],
  );

  // Snackbar styles
  SnackBarThemeData get snackBarTheme => SnackBarThemeData(
    backgroundColor: cardColor,
    contentTextStyle: captionStyle,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(wp(2.5))),
    behavior: SnackBarBehavior.floating,
  );

  // Helper methods for creating themed widgets
  SnackBar createSnackBar({
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    return SnackBar(
      content: Text(message, style: captionStyle),
      backgroundColor: backgroundColor ?? cardColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(wp(2.5)),
      ),
      margin: EdgeInsets.all(wp(2.5)),
      duration: duration,
    );
  }

  SnackBar get errorSnackBar =>
      createSnackBar(message: 'An error occurred', backgroundColor: errorColor);

  SnackBar get successSnackBar => createSnackBar(
    message: 'Operation successful',
    backgroundColor: successColor,
  );

  // Full theme data
  ThemeData get themeData => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    // Updated: errorColor is now part of colorScheme
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: cardColor,
      background: backgroundColor,
      error: errorColor,
    ),
    // Updated: TextTheme with correct parameter names
    textTheme: TextTheme(
      displayLarge: headingStyle, // was headline1
      displayMedium: subheadingStyle, // was headline2
      bodyLarge: bodyStyle, // was bodyText1
      bodySmall: captionStyle, // was caption
      labelLarge: buttonTextStyle, // was button
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardColor,
      hintStyle: GoogleFonts.poppins(
        color: textSecondaryColor.withOpacity(0.6),
        fontSize: sp(4),
      ),
      border: OutlineInputBorder(
        borderRadius: cardBorderRadius,
        borderSide: BorderSide(color: textSecondaryColor.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: cardBorderRadius,
        borderSide: BorderSide(color: textSecondaryColor.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: cardBorderRadius,
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: cardBorderRadius,
        borderSide: BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: cardBorderRadius,
        borderSide: BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: hp(2)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
    checkboxTheme: checkboxTheme,
    snackBarTheme: snackBarTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: subheadingStyle,
      iconTheme: IconThemeData(color: textPrimaryColor),
    ),
  );
}
