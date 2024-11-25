import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/appbar.dart';
import 'package:rhino_bond/widgets/app_drawer.dart';
import 'package:rhino_bond/theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;
  String _selectedLanguage = 'English';
  bool _biometricsEnabled = false;

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Settings',
        scaffoldKey: _scaffoldKey,
      ),
      endDrawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              _buildSectionHeader('Profile Settings'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Edit Profile'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Navigate to profile edit screen
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Change Password'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Navigate to change password screen
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // App Settings Section
              _buildSectionHeader('App Settings'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      ),
                      title: const Text('Dark Mode'),
                      trailing: Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications),
                      title: const Text('Push Notifications'),
                      subtitle: const Text('Receive notifications about rewards and updates'),
                      value: _notificationsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text('Language'),
                      subtitle: Text(_selectedLanguage),
                      trailing: DropdownButton<String>(
                        value: _selectedLanguage,
                        underline: Container(),
                        items: _languages.map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedLanguage = newValue;
                            });
                            // TODO: Implement language switching
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Security Section
              _buildSectionHeader('Security'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.fingerprint),
                      title: const Text('Biometric Authentication'),
                      subtitle: const Text('Use fingerprint or face ID to login'),
                      value: _biometricsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _biometricsEnabled = value;
                        });
                        // TODO: Implement biometric authentication
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.security),
                      title: const Text('Privacy Policy'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Navigate to privacy policy screen
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text('Terms of Service'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Navigate to terms of service screen
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // About Section
              _buildSectionHeader('About'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('App Version'),
                      trailing: const Text('1.0.0'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.update),
                      title: const Text('Check for Updates'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Implement update check
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Delete Account Section
              Card(
                color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                child: ListTile(
                  leading: Icon(
                    Icons.delete_forever,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Permanently delete your account and all data',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    _showDeleteAccountDialog();
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              onPressed: () {
                // TODO: Implement account deletion
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
