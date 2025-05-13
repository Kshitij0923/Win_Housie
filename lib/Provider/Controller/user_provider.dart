import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _phoneNumber;
  String? _username;
  String? _accessToken;
  String? _refreshToken;

  String? get phoneNumber => _phoneNumber;
  String? get username => _username;
  String? get authToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isAuthenticated => _accessToken != null;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _phoneNumber = prefs.getString('phone_number');
    _username = prefs.getString('username');
    _accessToken = prefs.getString('accessToken');
    _refreshToken = prefs.getString('refreshToken');
    notifyListeners();
  }

  Future<void> saveUserData({
    required String phoneNumber,
    required String username,
    required String authToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone_number', phoneNumber);
    await prefs.setString('username', username);
    await prefs.setString('auth_token', authToken);
    await prefs.setString('refresh_token', refreshToken);

    _phoneNumber = phoneNumber;
    _username = username;
    _accessToken = authToken;
    _refreshToken = refreshToken;
    notifyListeners();
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('phone_number');
    await prefs.remove('username');
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');

    _phoneNumber = null;
    _username = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }
}
