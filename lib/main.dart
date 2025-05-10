import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tambola/Login_Register%20Screens/splash_screen.dart';
import 'package:tambola/Theme/app_theme.dart';

void main() async {
  // Ensure Flutter is initialized before calling platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown, // Uncomment if you want upside-down portrait too
    // DeviceOrientation.landscapeLeft, // Uncomment for landscape orientations
    // DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: appTheme.themeData,
      home: const SplashScreen(),
    );
  }
}
