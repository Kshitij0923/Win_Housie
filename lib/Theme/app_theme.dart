import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShimmerText extends StatefulWidget {
  final String text;
  final TextStyle style;
  const ShimmerText({super.key, required this.text, required this.style});

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Color(0xFFFFFFFF),
                Color.fromARGB(255, 217, 183, 156),
                Color.fromARGB(255, 217, 183, 156),
                Color(0xFFB19CD9),
                Color(0xFFFFFFFF),
              ],
              stops: [
                0.0,
                _controller.value - 0.2 < 0 ? 0.0 : _controller.value - 0.2,
                _controller.value,
                _controller.value + 0.2 > 1 ? 1.0 : _controller.value + 0.2,
                1.0,
              ],
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
          },
          child: Text(
            widget.text,
            style: widget.style.copyWith(color: Colors.white),
          ),
        );
      },
    );
  }
}

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
  final Color buttonbackgroundColor = const Color(0xFF9D4EDD);
  final Color appBarColor =
      Colors.purple[800] ?? const Color(0xFF6A1B9A); // New app bar color

  // Contest Theme Colors
  final Color standardContestColor = const Color(0xFF4CAF50); // Green
  final Color standardContestIconColor = const Color(0xFF8BC34A); // Light Green
  final Color massContestColor = const Color(0xFF2196F3); // Blue
  final Color massContestIconColor = const Color(0xFF03A9F4); // Light Blue
  final Color megaContestColor = const Color(0xFFFF9800); // Orange
  final Color megaContestIconColor = const Color(0xFFFFB74D); // Light Orange
  final Color megaContestColor2 = const Color(0xFF9C27B0); // Purple
  final Color megaContestIconColor2 = const Color(0xFFBA68C8); // Light Purple

  // Contest Theme Font Families
  final String standardContestFontFamily = 'Poppins';
  final String massContestFontFamily = 'Montserrat';
  final String megaContestFontFamily = 'Raleway';
  final String megaContestFontFamily2 = 'Quicksand';

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

  // Contest Gradients
  LinearGradient getContestGradient(Color baseColor) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      baseColor.withValues(alpha: 0.8),
      baseColor.withValues(alpha: 0.5),
    ],
  );

  // Standard Contest Gradient
  LinearGradient get standardContestGradient =>
      getContestGradient(standardContestColor);

  // Mass Contest Gradient
  LinearGradient get massContestGradient =>
      getContestGradient(massContestColor);

  // Mega Contest Gradients
  LinearGradient get megaContestGradient =>
      getContestGradient(megaContestColor);
  LinearGradient get megaContestGradient2 =>
      getContestGradient(megaContestColor2);

  // App bar title gradient - matches the shimmer animation colors
  LinearGradient get appBarTitleGradient => const LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color.fromARGB(255, 217, 183, 156),
      Color(0xFFB19CD9),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomRight,
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

  // App bar title text style
  TextStyle get appBarTitleStyle => GoogleFonts.poppins(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
  );

  // Contest Text Styles
  TextStyle getContestTitleStyle(String fontFamily) => GoogleFonts.getFont(
    fontFamily,
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  TextStyle getContestSubtitleStyle(String fontFamily) => GoogleFonts.getFont(
    fontFamily,
    textStyle: TextStyle(
      fontSize: 12,
      color: Colors.white.withValues(alpha: 0.8),
    ),
  );

  TextStyle getContestPrizeStyle(String fontFamily, Color color) =>
      GoogleFonts.getFont(
        fontFamily,
        textStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      );

  TextStyle getContestEntryFeeStyle(String fontFamily) => GoogleFonts.getFont(
    fontFamily,
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  TextStyle getContestButtonStyle(String fontFamily, Color color) =>
      GoogleFonts.getFont(
        fontFamily,
        textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      );

  TextStyle getContestDetailsTitleStyle(String fontFamily) =>
      GoogleFonts.getFont(
        fontFamily,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );

  TextStyle getContestDetailsSubtitleStyle(String fontFamily) =>
      GoogleFonts.getFont(
        fontFamily,
        textStyle: TextStyle(
          fontSize: 14,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      );

  TextStyle getContestPrizeItemStyle(String fontFamily) => GoogleFonts.getFont(
    fontFamily,
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 14,
    ),
  );

  TextStyle getContestPrizeAmountStyle(String fontFamily, Color color) =>
      GoogleFonts.getFont(
        fontFamily,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: 14,
        ),
      );

  // Contest Button Styles
  ButtonStyle getContestOutlinedButtonStyle(Color color) =>
      OutlinedButton.styleFrom(
        side: BorderSide(color: color.withValues(alpha: 0.7)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      );

  ButtonStyle getContestElevatedButtonStyle(Color color) =>
      ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      );

  // Custom AppBar creation method with animated title
  PreferredSizeWidget createAppBar({
    String title = 'Win Housie',
    TextStyle? titleStyle,
    Function()? onDrawerPressed,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
    Widget? leading,
  }) {
    return AppBar(
      title: ShaderMask(
        shaderCallback: (bounds) => appBarTitleGradient.createShader(bounds),
        child: ShimmerText(text: title, style: titleStyle ?? appBarTitleStyle),
      ),
      backgroundColor: appBarColor,
      centerTitle: true,
      elevation: 0,
      leading:
          leading ??
          (onDrawerPressed != null
              ? IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Circle background color
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4), // Padding inside the circle
                  child: Icon(
                    Icons.person,
                    color: Colors.deepPurple,
                    size: bodyStyle.fontSize,
                  ),
                ),
                onPressed: onDrawerPressed,
              )
              : null),
      actions: actions,
      bottom: bottom,
    );
  }

  // Input decoration
  InputDecoration inputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        color: textSecondaryColor.withValues(alpha: 0.6),
        fontSize: sp(4),
      ),
      prefixIcon: Icon(icon, color: primaryColor, size: wp(5)),
      filled: true,
      fillColor: cardColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: cardBorderRadius,
        borderSide: BorderSide(
          color: textSecondaryColor.withValues(alpha: 0.1),
        ),
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
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return primaryColor;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(textPrimaryColor),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(wp(1))),
    side: BorderSide(
      color: textSecondaryColor.withValues(alpha: 0.6),
      width: 1.5,
    ),
  );

  // Card decoration
  BoxDecoration get cardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: cardBorderRadius,
    border: Border.all(
      color: textSecondaryColor.withValues(alpha: 0.1),
      width: 1,
    ),
  );

  // Contest Card Decorations
  BoxDecoration getContestCardDecoration(Color color) => BoxDecoration(
    color: Colors.black.withValues(alpha: 0.4),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: color.withValues(alpha: 0.5)),
  );

  BoxDecoration getMegaContestCardDecoration(Color color) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color.withValues(alpha: 0.8), color.withValues(alpha: 0.5)],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: color.withValues(alpha: 0.3),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  BoxDecoration getContestHeaderDecoration(Color color) => BoxDecoration(
    gradient: LinearGradient(
      colors: [color.withValues(alpha: 0.8), color.withValues(alpha: 0.6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
    ),
  );

  // Contest Info Card Decoration
  BoxDecoration getContestInfoCardDecoration(Color color) => BoxDecoration(
    color: Colors.black.withValues(alpha: 0.3),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: color.withValues(alpha: 0.3)),
  );

  // Contest Prize Item Decoration
  BoxDecoration get contestPrizeItemDecoration => BoxDecoration(
    color: Colors.black.withValues(alpha: 0.3),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey[800]!),
  );

  // Contest Popular Tag Decoration
  BoxDecoration get contestPopularTagDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  );

  // Contest Mega Tag Decoration
  BoxDecoration get contestMegaTagDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(50),
  );

  // Button decoration
  BoxDecoration get buttonDecoration => BoxDecoration(
    borderRadius: buttonBorderRadius,
    boxShadow: [
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.3),
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

  // Contest Details Bottom Sheet Decoration
  BoxDecoration get contestDetailsSheetDecoration => const BoxDecoration(
    color: Color(0xFF1E1E2C),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
  );

  // Contest Details Drag Handle
  BoxDecoration get contestDetailsDragHandleDecoration => BoxDecoration(
    color: Colors.grey[600],
    borderRadius: BorderRadius.circular(10),
  );

  // Contest Terms Box Decoration
  BoxDecoration get contestTermsBoxDecoration => BoxDecoration(
    color: Colors.blueGrey.withValues(alpha: 0.2),
    borderRadius: BorderRadius.circular(8),
  );

  // Contest Prize Distribution Header Decoration
  BoxDecoration getContestPrizeHeaderDecoration(Color color) => BoxDecoration(
    color: color.withValues(alpha: 0.2),
    borderRadius: BorderRadius.circular(8),
  );

  // Contest Payment Dialog Decoration
  BoxDecoration get contestPaymentDialogDecoration => BoxDecoration(
    color: const Color(0xFF1E1E2C),
    borderRadius: BorderRadius.circular(16),
  );

  // Contest Payment Success Dialog Decoration
  BoxDecoration get contestPaymentSuccessDialogDecoration => BoxDecoration(
    color: const Color(0xFF1E1E2C),
    borderRadius: BorderRadius.circular(16),
  );

  // Contest Payment Success Button Style
  ButtonStyle getContestPaymentSuccessButtonStyle(Color color) =>
      ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
        color: textSecondaryColor.withValues(alpha: 0.6),
        fontSize: sp(4),
      ),
      border: OutlineInputBorder(
        borderRadius: cardBorderRadius,
        borderSide: BorderSide(
          color: textSecondaryColor.withValues(alpha: 0.1),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: cardBorderRadius,
        borderSide: BorderSide(
          color: textSecondaryColor.withValues(alpha: 0.1),
        ),
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
      backgroundColor: appBarColor,
      elevation: 0,
      titleTextStyle: appBarTitleStyle,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      iconTheme: IconThemeData(color: textPrimaryColor),
    ),
  );
}
