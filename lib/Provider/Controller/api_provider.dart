import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final String _baseUrl = 'https://ae12-103-175-140-106.ngrok-free.app';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _accessToken;
  String? get accessToken => _accessToken;

  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setUserData(String token, Map<String, dynamic> userData) {
    _accessToken = token;
    _user = userData;
    notifyListeners();
  }

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String phone,
    required String email,
    String? referralCode,
  }) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/authenticate/createuser'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'email': email,
          'referral_code': referralCode ?? '',
        }),
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': responseBody};
      } else {
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> loginUser({required String phone}) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/authenticate/otp_generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      debugPrint('Login API response code: ${response.statusCode}');
      debugPrint('Login API response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        return {'success': true, 'data': responseBody};
      } else {
        final errorBody = json.decode(response.body);
        return {
          'success': false,
          'message': errorBody['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Login error: ${e.toString()}'};
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/verifyotp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        final token = responseBody['access_token'];
        final userData = responseBody['user'];

        _setUserData(token, userData);

        return {'success': true, 'data': responseBody};
      } else {
        return {
          'success': false,
          'message': responseBody['message'] ?? 'OTP verification failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> verifyOtpRequest({
    required String phone,
    required String otp,
    required String name,
  }) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/authenticate/otp_Login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'otp': otp, 'name': name}),
      );

      final responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        final accessToken = responseBody['data']['accessToken'];
        final userData = responseBody['data']['user'];

        if (accessToken == null) {
          throw Exception('Invalid access token in response');
        }

        _setUserData(accessToken, userData);

        return {'success': true, 'data': responseBody['data']};
      } else {
        return {
          'success': false,
          'message': responseBody['message'] ?? 'OTP verification failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'OTP verification error: ${e.toString()}',
      };
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> resendOtp({
    required String phone,
    required String name,
  }) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/authenticate/otp_Login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'name': name}),
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseBody['message'] ?? 'OTP resent successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Failed to resend OTP',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Resend OTP error: ${e.toString()}'};
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      // Clear in-memory data
      _accessToken = null;
      _user = null;

      // Clear SharedPreferences data
      final prefs = await SharedPreferences.getInstance();

      // Remove all authentication-related data
      await prefs.remove('isLoggedIn');
      await prefs.remove('phone_number');
      await prefs.remove('username');
      await prefs.remove('auth_token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_role');
      await prefs.remove('user_id');

      debugPrint('User logged out successfully - all data cleared');

      // Notify listeners after clearing data
      notifyListeners();
    } catch (e) {
      debugPrint('Error during logout: $e');
      // Even if there's an error, clear in-memory data and notify
      _accessToken = null;
      _user = null;
      notifyListeners();
    }
  }
}
