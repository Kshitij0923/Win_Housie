import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tambola/Login_Register%20Screens/login_screen.dart';

Future<void> logoutUser(context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // or remove('isLoggedIn')
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
}
