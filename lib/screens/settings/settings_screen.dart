import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/widgets/appbar.dart';
import 'package:rhino_bond/widgets/custom_app_drawer.dart';
import 'package:rhino_bond/providers/theme_provider.dart';
import 'package:rhino_bond/providers/language_provider.dart';
import 'package:rhino_bond/l10n/localization.dart';
import 'package:rhino_bond/screens/settings/privacy_policy_screen.dart';
import 'package:rhino_bond/screens/settings/terms_of_service_screen.dart';
import 'package:rhino_bond/screens/settings/change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;

  late List<String> _languages;
  late Map<String, Locale> _languageLocales;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languages = [
      AppLocalizations.of(context).english,
      AppLocalizations.of(context).gujarati,
      AppLocalizations.of(context).hindi,
      AppLocalizations.of(context).marathi,
      AppLocalizations.of(context).punjabi,
    ];

    _languageLocales = {
      AppLocalizations.of(context).english: const Locale('en'),
      AppLocalizations.of(context).gujarati: const Locale('gu'),
      AppLocalizations.of(context).hindi: const Locale('hi'),
      AppLocalizations.of(context).marathi: const Locale('mr'),
      AppLocalizations.of(context).punjabi: const Locale('pa'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).settingsTitle,
        scaffoldKey: _scaffoldKey,
        showBackButton: true,
      ),
      endDrawer: CustomAppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              _buildSectionHeader(AppLocalizations.of(context).profileSettings),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: Text(AppLocalizations.of(context).changePassword),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // App Settings Section
              _buildSectionHeader(AppLocalizations.of(context).appSettings),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        themeProvider.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                      title: Text(AppLocalizations.of(context).darkMode),
                      trailing: Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications),
                      title:
                          Text(AppLocalizations.of(context).pushNotifications),
                      subtitle: Text(AppLocalizations.of(context)
                          .notificationsDescription),
                      value: _notificationsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(AppLocalizations.of(context).language),
                      subtitle: Text(Provider.of<LanguageProvider>(context)
                          .currentLanguage),
                      trailing: DropdownButton<String>(
                        value: Provider.of<LanguageProvider>(context)
                            .currentLanguage,
                        underline: Container(),
                        items: _languages.map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                        onChanged: (String? newValue) async {
                          if (newValue != null) {
                            final locale = _languageLocales[newValue];
                            if (locale != null) {
                              await Provider.of<LanguageProvider>(context,
                                      listen: false)
                                  .setLocale(locale);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Security Section
              _buildSectionHeader(AppLocalizations.of(context).security),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.fingerprint),
                      title: Text(
                          AppLocalizations.of(context).biometricAuthentication),
                      subtitle: Text(
                          AppLocalizations.of(context).biometricDescription),
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
                      title: Text(AppLocalizations.of(context).privacyPolicy),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: Text(AppLocalizations.of(context).termsOfService),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsOfServiceScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // About Section
              _buildSectionHeader(AppLocalizations.of(context).about),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: Text(AppLocalizations.of(context).appVersion),
                      trailing: const Text('1.0.0'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.update),
                      title: Text(AppLocalizations.of(context).checkForUpdates),
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
                    AppLocalizations.of(context).deleteAccount,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context).deleteAccountDescription,
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
          title: Text(AppLocalizations.of(context).deleteAccount),
          content: Text(
            AppLocalizations.of(context).deleteAccountConfirmation,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context).delete,
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
