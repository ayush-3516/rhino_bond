import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:rhino_bond/l10n/generated/messages_all.dart';
import 'package:rhino_bond/l10n/generated/messages_en.dart' as messages_en;
import 'package:rhino_bond/l10n/generated/messages_gu.dart' as messages_gu;
import 'package:rhino_bond/l10n/generated/messages_hi.dart' as messages_hi;
import 'package:rhino_bond/l10n/generated/messages_mr.dart' as messages_mr;
import 'package:rhino_bond/l10n/generated/messages_pa.dart' as messages_pa;

class AppLocalizations {
  static AppLocalizations? _current;
  final MessageLookupByLibrary _messages;

  AppLocalizations(this._messages);

  static AppLocalizations of(BuildContext context) {
    assert(_current != null,
        'No instance of AppLocalizations loaded. Make sure to add AppLocalizationsDelegate to your MaterialApp');
    return _current!;
  }

  String get appTitle => _messages['appTitle'] as String? ?? 'Rhino Bond';
  String get settingsTitle =>
      _messages['settingsTitle'] as String? ?? 'Settings';
  String get profileSettings =>
      _messages['profileSettings'] as String? ?? 'Profile Settings';
  String get changePassword =>
      _messages['changePassword'] as String? ?? 'Change Password';
  String get appSettings =>
      _messages['appSettings'] as String? ?? 'App Settings';
  String get darkMode => _messages['darkMode'] as String? ?? 'Dark Mode';
  String get pushNotifications =>
      _messages['pushNotifications'] as String? ?? 'Push Notifications';
  String get notificationsDescription =>
      _messages['notificationsDescription'] as String? ??
      'Receive notifications about rewards and updates';
  String get language => _messages['language'] as String? ?? 'Language';
  String get security => _messages['security'] as String? ?? 'Security';
  String get biometricAuthentication =>
      _messages['biometricAuthentication'] as String? ??
      'Biometric Authentication';
  String get biometricDescription =>
      _messages['biometricDescription'] as String? ??
      'Use fingerprint or face ID to login';
  String get privacyPolicy =>
      _messages['privacyPolicy'] as String? ?? 'Privacy Policy';
  String get termsOfService =>
      _messages['termsOfService'] as String? ?? 'Terms of Service';
  String get about => _messages['about'] as String? ?? 'About';
  String get appVersion => _messages['appVersion'] as String? ?? 'App Version';
  String get checkForUpdates =>
      _messages['checkForUpdates'] as String? ?? 'Check for Updates';
  String get deleteAccount =>
      _messages['deleteAccount'] as String? ?? 'Delete Account';
  String get deleteAccountDescription =>
      _messages['deleteAccountDescription'] as String? ??
      'Permanently delete your account and all data';
  String get deleteAccountConfirmation =>
      _messages['deleteAccountConfirmation'] as String? ??
      'Are you sure you want to delete your account? This action cannot be undone.';
  String get cancel => _messages['cancel'] as String? ?? 'Cancel';
  String get delete => _messages['delete'] as String? ?? 'Delete';

  // Language names
  String get english => _messages['english'] as String? ?? 'English';
  String get gujarati => _messages['gujarati'] as String? ?? 'Gujarati';
  String get hindi => _messages['hindi'] as String? ?? 'Hindi';
  String get marathi => _messages['marathi'] as String? ?? 'Marathi';
  String get punjabi => _messages['punjabi'] as String? ?? 'Punjabi';

  // Contact FAQ Screen
  String get generalInquiry =>
      _messages['generalInquiry'] as String? ?? 'General Inquiry';
  String get technicalSupport =>
      _messages['technicalSupport'] as String? ?? 'Technical Support';
  String get accountIssues =>
      _messages['accountIssues'] as String? ?? 'Account Issues';
  String get rewardsProgram =>
      _messages['rewardsProgram'] as String? ?? 'Rewards Program';
  String get otherTopic => _messages['otherTopic'] as String? ?? 'Other Topic';
  String get messageSent =>
      _messages['messageSent'] as String? ?? 'Message sent successfully';
  String get contactFAQTitle =>
      _messages['contactFAQTitle'] as String? ?? 'Contact & FAQ';
  String get getInTouch => _messages['getInTouch'] as String? ?? 'Get in Touch';
  String get emailLabel => _messages['emailLabel'] as String? ?? 'Email';
  String get phoneLabel => _messages['phoneLabel'] as String? ?? 'Phone';
  String get addressLabel => _messages['addressLabel'] as String? ?? 'Address';
  String get sendMessageTitle =>
      _messages['sendMessageTitle'] as String? ?? 'Send us a Message';
  String get nameLabel => _messages['nameLabel'] as String? ?? 'Name';
  String get nameValidation =>
      _messages['nameValidation'] as String? ?? 'Please enter your name';
  String get emailValidation =>
      _messages['emailValidation'] as String? ?? 'Please enter your email';
  String get emailFormatValidation =>
      _messages['emailFormatValidation'] as String? ??
      'Please enter a valid email address';
  String get topicLabel => _messages['topicLabel'] as String? ?? 'Topic';
  String get messageLabel => _messages['messageLabel'] as String? ?? 'Message';
  String get messageValidation =>
      _messages['messageValidation'] as String? ?? 'Please enter your message';
  String get sendButton => _messages['sendButton'] as String? ?? 'Send';

  // Drawer menu items
  String get home => _messages['home'] as String? ?? 'Home';
  String get logout => _messages['logout'] as String? ?? 'Logout';
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'gu', 'hi', 'mr', 'pa'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    await initializeMessages(locale.toString());
    final messages = _findGeneratedMessagesFor(locale.toString());
    if (messages == null) {
      throw Exception('No messages found for locale $locale');
    }
    AppLocalizations._current = AppLocalizations(messages);
    return AppLocalizations._current!;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  MessageLookupByLibrary? _findGeneratedMessagesFor(String locale) {
    var actualLocale =
        Intl.verifiedLocale(locale, _messagesExistFor, onFailure: (_) => null);
    if (actualLocale == null) return null;
    return _findExact(actualLocale);
  }

  bool _messagesExistFor(String locale) {
    try {
      return _findExact(locale) != null;
    } catch (e) {
      return false;
    }
  }

  MessageLookupByLibrary? _findExact(String localeName) {
    switch (localeName) {
      case 'en':
        return messages_en.messages;
      case 'gu':
        return messages_gu.messages;
      case 'hi':
        return messages_hi.messages;
      case 'mr':
        return messages_mr.messages;
      case 'pa':
        return messages_pa.messages;
      default:
        return null;
    }
  }
}
