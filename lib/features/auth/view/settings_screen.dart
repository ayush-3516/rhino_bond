import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/appbar.dart';
import 'package:rhino_bond/widgets/app_drawer.dart';
import 'package:rhino_bond/theme/theme_provider.dart';
import 'package:rhino_bond/providers/language_provider.dart';
import 'package:rhino_bond/config/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: appLocalizations?.settings ?? 'Settings',
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
              _buildSectionHeader(
                  appLocalizations?.profileSettings ?? 'Profile Settings'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: Text(appLocalizations?.changePassword ??
                          'Change Password'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(context, '/changePassword');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // App Settings Section
              _buildSectionHeader(
                  appLocalizations?.appSettings ?? 'App Settings'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        themeProvider.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                      title: Text(appLocalizations?.darkMode ?? 'Dark Mode'),
                      trailing: Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications),
                      title: Text(appLocalizations?.pushNotifications ??
                          'Push Notifications'),
                      subtitle: Text(appLocalizations?.notificationsSubtitle ??
                          'Receive notifications about rewards and updates'),
                      value: _notificationsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(appLocalizations?.language ?? 'Language'),
                      subtitle: Text(languageProvider.getCurrentLanguageName()),
                      trailing: DropdownButton<String>(
                        value: languageProvider.getCurrentLanguageName(),
                        underline: Container(),
                        items: languageProvider.supportedLanguages.keys
                            .map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            languageProvider.setLanguage(newValue);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Security Section
              _buildSectionHeader(appLocalizations?.security ?? 'Security'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.fingerprint),
                      title: Text(appLocalizations?.biometricAuth ??
                          'Biometric Authentication'),
                      subtitle: Text(appLocalizations?.biometricAuthSubtitle ??
                          'Use fingerprint or face ID to login'),
                      value: _biometricsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _biometricsEnabled = value;
                        });
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.security),
                      title: Text(
                          appLocalizations?.privacyPolicy ?? 'Privacy Policy'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Navigate to privacy policy screen
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: Text(appLocalizations?.termsOfService ??
                          'Terms of Service'),
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
              _buildSectionHeader(appLocalizations?.about ?? 'About'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info),
                      title:
                          Text(appLocalizations?.appVersion ?? 'App Version'),
                      trailing: const Text('1.0.0'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.update),
                      title: Text(appLocalizations?.checkForUpdates ??
                          'Check for Updates'),
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
                    appLocalizations?.deleteAccount ?? 'Delete Account',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    appLocalizations?.deleteAccountSubtitle ??
                        'Permanently delete your account and all data',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    _showDeleteAccountDialog(appLocalizations);
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

  Future<void> _showDeleteAccountDialog(
      AppLocalizations? appLocalizations) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(appLocalizations?.deleteAccount ?? 'Delete Account'),
          content: Text(
            appLocalizations?.deleteAccountSubtitle ??
                'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text(appLocalizations?.cancel ?? 'Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                appLocalizations?.delete ?? 'Delete',
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
