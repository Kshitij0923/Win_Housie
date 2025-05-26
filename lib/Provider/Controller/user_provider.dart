import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  // Constants for SharedPreferences keys
  static const String KEY_PHONE = 'phone_number';
  static const String KEY_USERNAME = 'username';
  static const String KEY_ACCESS_TOKEN = 'accessToken';
  static const String KEY_REFRESH_TOKEN = 'refreshToken';
  static const String KEY_IS_LOGGED_IN = 'isLoggedIn';
  static const String KEY_USER_ROLE = 'user_role';
  static const String KEY_AUTH_TOKEN = 'auth_token';
  static const String KEY_IS_AUTHENTICATED = 'is_authenticated';

  String? _phoneNumber;
  String? _username;
  String? _accessToken;
  String? _refreshToken;
  String? _user;

  String? get phoneNumber => _phoneNumber;
  String? get username => _username;
  String? get authToken => _accessToken;
  String? get refreshToken => _refreshToken;
  String? get user => _user;
  bool get isAuthenticated => _accessToken != null;

  void setAuthToken(String token) {
    _accessToken = token;
    notifyListeners();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _phoneNumber = prefs.getString(KEY_PHONE);
    _username = prefs.getString(KEY_USERNAME);
    _accessToken = prefs.getString(KEY_ACCESS_TOKEN);
    _refreshToken = prefs.getString(KEY_REFRESH_TOKEN);
    debugPrint("Loaded auth token: $_accessToken");
    notifyListeners();
  }

  Future<void> saveUserData({
    required String phoneNumber,
    required String username,
    required String authToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_PHONE, phoneNumber);
    await prefs.setString(KEY_USERNAME, username);
    await prefs.setString(KEY_ACCESS_TOKEN, authToken);
    await prefs.setString(KEY_REFRESH_TOKEN, refreshToken);
    
    _phoneNumber = phoneNumber;
    _username = username;
    _accessToken = authToken;
    _refreshToken = refreshToken;
    notifyListeners();
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(KEY_PHONE);
    await prefs.remove(KEY_USERNAME);
    await prefs.remove(KEY_ACCESS_TOKEN);
    await prefs.remove(KEY_REFRESH_TOKEN);
    
    _phoneNumber = null;
    _username = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  // Complete logout method that clears ALL authentication data
  Future<void> logout() async {
    try {
      // Clear in-memory data
      _accessToken = null;
      _user = null;
      _phoneNumber = null;
      _username = null;
      _refreshToken = null;
      
      // Clear SharedPreferences data
      final prefs = await SharedPreferences.getInstance();
      
      // Remove all authentication-related data using both key formats
      await prefs.remove(KEY_IS_LOGGED_IN);
      await prefs.remove(KEY_PHONE);
      await prefs.remove(KEY_USERNAME);
      await prefs.remove(KEY_ACCESS_TOKEN);
      await prefs.remove(KEY_REFRESH_TOKEN);
      await prefs.remove(KEY_USER_ROLE);
      await prefs.remove(KEY_AUTH_TOKEN);
      await prefs.remove(KEY_IS_AUTHENTICATED);
      
      // Also remove the keys used in other parts of your app
      await prefs.remove('isLoggedIn');
      await prefs.remove('phone_number');
      await prefs.remove('username');
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      await prefs.remove('auth_token');
      await prefs.remove('user_role');
      await prefs.remove('user_id');
      await prefs.remove('is_authenticated');
      
      debugPrint('User logged out successfully - all data cleared');
      
      // Notify listeners after clearing data
      notifyListeners();
    } catch (e) {
      debugPrint('Error during logout: $e');
      // Even if there's an error, clear in-memory data and notify
      _accessToken = null;
      _user = null;
      _phoneNumber = null;
      _username = null;
      _refreshToken = null;
      notifyListeners();
    }
  }
}
