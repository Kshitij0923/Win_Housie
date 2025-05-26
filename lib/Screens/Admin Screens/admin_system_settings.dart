import 'package:flutter/material.dart';
import 'package:tambola/Provider/Controller/user_provider.dart';
import 'package:tambola/Theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  bool _autoContestCreationEnabled = false;
  bool _allowUserRegistration = true;
  bool _maintenanceMode = false;
  int _maxContestsPerDay = 5;
  int _defaultContestDurationHours = 2;
  bool _isUpdatingAutoContest = false;
  bool _isLoadingSettings = true;

  // API endpoint
  static const String _apiBaseUrl =
      'https://ae12-103-175-140-106.ngrok-free.app/api';

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  String? _getAuthToken() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.authToken;
  }

  // Get headers with auth token
  Map<String, String> _getAuthHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'ngrok-skip-browser-warning': 'true',
    };

    final token = _getAuthToken();
    debugPrint('Auth token: $token');
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Load current settings from API
  Future<void> _loadCurrentSettings() async {
    final token = _getAuthToken();

    if (token == null) {
      _showErrorSnackBar('User not authenticated. Please log in again.');
      setState(() {
        _isLoadingSettings = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$_apiBaseUrl/system/settings'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _autoContestCreationEnabled =
              data['autoContestCreationEnabled'] ?? false;
          _allowUserRegistration = data['allowUserRegistration'] ?? true;
          _maintenanceMode = data['maintenanceMode'] ?? false;
          _maxContestsPerDay = data['maxContestsPerDay'] ?? 5;
          _defaultContestDurationHours =
              data['defaultContestDurationHours'] ?? 2;
          _isLoadingSettings = false;
        });
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _handleApiError(response);
        setState(() {
          _isLoadingSettings = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
      _handleNetworkError(e);
      setState(() {
        _isLoadingSettings = false;
      });
    }
  }

  // API call to update auto contest creation
  Future<void> _updateAutoContestCreation(bool enabled) async {
    final token = _getAuthToken();

    if (token == null) {
      _showErrorSnackBar('User not authenticated. Please log in again.');
      return;
    }

    setState(() {
      _isUpdatingAutoContest = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/Contests/automatic_contest'),
        headers: _getAuthHeaders(),
        body: json.encode({
          'enabled': enabled,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        setState(() {
          _autoContestCreationEnabled = enabled;
        });
        _showSuccessSnackBar(
          enabled
              ? 'Auto contest creation enabled successfully'
              : 'Auto contest creation disabled successfully',
        );
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
        // Revert the toggle state
        setState(() {
          _autoContestCreationEnabled = !enabled;
        });
      } else {
        // Error response
        _handleApiError(response);
        // Revert the toggle state
        setState(() {
          _autoContestCreationEnabled = !enabled;
        });
      }
    } catch (e) {
      // Network or other error
      debugPrint("Auto contest update error: $e");
      _handleNetworkError(e);
      // Revert the toggle state
      setState(() {
        _autoContestCreationEnabled = !enabled;
      });
    } finally {
      setState(() {
        _isUpdatingAutoContest = false;
      });
    }
  }

  // Save other settings to API
  Future<void> _saveSettingsToAPI() async {
    final token = _getAuthToken();

    if (token == null) {
      _showErrorSnackBar('User not authenticated. Please log in again.');
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('$_apiBaseUrl/system/settings'),
        headers: _getAuthHeaders(),
        body: json.encode({
          'allowUserRegistration': _allowUserRegistration,
          'maintenanceMode': _maintenanceMode,
          'maxContestsPerDay': _maxContestsPerDay,
          'defaultContestDurationHours': _defaultContestDurationHours,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessSnackBar('Settings saved successfully');
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _handleApiError(response);
      }
    } catch (e) {
      debugPrint("Settings save error: $e");
      _handleNetworkError(e);
    }
  }

  void _handleUnauthorized() {
    _showErrorSnackBar('Session expired. Please login again.');
    // You can navigate to login screen here if needed
    // Navigator.pushReplacementNamed(context, '/login');
  }

  void _handleApiError(http.Response response) {
    String errorMessage = 'Failed to update settings';
    try {
      final errorData = json.decode(response.body);
      errorMessage = errorData['message'] ?? errorMessage;
    } catch (e) {
      // If we can't parse the error response, use default message
    }
    _showErrorSnackBar('$errorMessage (Status: ${response.statusCode})');
  }

  void _handleNetworkError(dynamic error) {
    String errorMessage = 'Network error occurred';
    if (error.toString().contains('SocketException')) {
      errorMessage = 'No internet connection';
    } else if (error.toString().contains('TimeoutException')) {
      errorMessage = 'Request timeout';
    }
    _showErrorSnackBar(errorMessage);
  }

  void _showSuccessSnackBar(String message) {
    final theme = AppTheme();
    ScaffoldMessenger.of(context).showSnackBar(
      theme.createSnackBar(
        message: message,
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    final theme = AppTheme();
    ScaffoldMessenger.of(context).showSnackBar(
      theme.createSnackBar(
        message: message,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    theme.init(context);

    // Show loading indicator while loading settings
    if (_isLoadingSettings) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading settings...',
                style: TextStyle(
                  fontSize: theme.sp(4),
                  color: theme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Settings',
              style: TextStyle(
                fontSize: theme.sp(7),
                fontWeight: FontWeight.bold,
                color: theme.textPrimaryColor,
              ),
            ),
            SizedBox(height: theme.hp(3)),
            _buildSettingsCard(
              theme,
              title: 'Contest Creation',
              children: [
                _buildAutoContestSwitchTile(),
                Divider(color: theme.backgroundColor),
                _buildSliderTile(
                  title: 'Max Contests Per Day',
                  value: _maxContestsPerDay.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: _maxContestsPerDay.toString(),
                  onChanged: (value) {
                    setState(() {
                      _maxContestsPerDay = value.round();
                    });
                    _saveSettings();
                  },
                ),
                Divider(color: theme.backgroundColor),
                _buildSliderTile(
                  title: 'Default Contest Duration (hours)',
                  value: _defaultContestDurationHours.toDouble(),
                  min: 1,
                  max: 6,
                  divisions: 5,
                  label: '$_defaultContestDurationHours hours',
                  onChanged: (value) {
                    setState(() {
                      _defaultContestDurationHours = value.round();
                    });
                    _saveSettings();
                  },
                ),
              ],
            ),
            SizedBox(height: theme.hp(2)),
            _buildSettingsCard(
              theme,
              title: 'User Management',
              children: [
                _buildSwitchTile(
                  title: 'Allow User Registration',
                  subtitle:
                      _allowUserRegistration
                          ? 'New users can register in the app'
                          : 'New user registration is disabled',
                  value: _allowUserRegistration,
                  onChanged: (value) {
                    setState(() {
                      _allowUserRegistration = value;
                    });
                    _saveSettings();
                  },
                ),
              ],
            ),
            SizedBox(height: theme.hp(2)),
            _buildSettingsCard(
              theme,
              title: 'System Status',
              children: [
                _buildSwitchTile(
                  title: 'Maintenance Mode',
                  subtitle:
                      _maintenanceMode
                          ? 'App is in maintenance mode. Only admins can access.'
                          : 'App is operating normally',
                  value: _maintenanceMode,
                  onChanged: (value) {
                    _showMaintenanceModeDialog(value);
                  },
                ),
              ],
            ),
            SizedBox(height: theme.hp(4)),
            Center(
              child: ElevatedButton.icon(
                onPressed: _resetToDefaults,
                icon: const Icon(Icons.restore),
                label: const Text('Reset to Defaults'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade700,
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.wp(6),
                    vertical: theme.hp(1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Special widget for auto contest creation with loading state
  Widget _buildAutoContestSwitchTile() {
    return ListTile(
      title: Row(
        children: [
          const Text('Auto Contest Creation'),
          if (_isUpdatingAutoContest) ...[
            const SizedBox(width: 8),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ],
      ),
      subtitle: Text(
        _autoContestCreationEnabled
            ? 'System will automatically create contests based on schedule'
            : 'Automatic contest creation is disabled',
      ),
      trailing: Switch(
        value: _autoContestCreationEnabled,
        onChanged:
            _isUpdatingAutoContest
                ? null
                : (value) {
                  _updateAutoContestCreation(value);
                },
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildSettingsCard(
    AppTheme theme, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(theme.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: theme.sp(5),
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(height: theme.hp(2)),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildSliderTile({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: label,
          onChanged: onChanged,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(min.round().toString()),
              Text(label),
              Text(max.round().toString()),
            ],
          ),
        ),
      ],
    );
  }

  void _showMaintenanceModeDialog(bool newValue) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Enable Maintenance Mode?'),
            content: Text(
              newValue
                  ? 'This will prevent regular users from accessing the app. Only admins will be able to log in.'
                  : 'This will restore normal access to the app for all users.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _maintenanceMode = newValue;
                  });
                  _saveSettings();
                  Navigator.pop(context);
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reset Settings?'),
            content: const Text(
              'This will reset all settings to their default values. This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  setState(() {
                    _autoContestCreationEnabled = false;
                    _allowUserRegistration = true;
                    _maintenanceMode = false;
                    _maxContestsPerDay = 5;
                    _defaultContestDurationHours = 2;
                  });
                  // Also call API to reset auto contest creation
                  _updateAutoContestCreation(false);
                  _saveSettings();
                  Navigator.pop(context);
                },
                child: const Text('Reset'),
              ),
            ],
          ),
    );
  }

  void _saveSettings() {
    // Save settings to API instead of just showing snackbar
    _saveSettingsToAPI();
  }
}
