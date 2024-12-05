import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _languageKey = 'selectedLanguage';
  Locale _currentLocale = const Locale('en');

  LanguageProvider() {
    _loadLanguage();
  }

  Locale get currentLocale => _currentLocale;

  final Map<String, Locale> supportedLanguages = {
    'English': const Locale('en'),
    'ગુજરાતી': const Locale('gu'),
    'हिंदी': const Locale('hi'),
    'मराठी': const Locale('mr'),
    'ਪੰਜਾਬੀ': const Locale('pa'),
  };

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);
    if (savedLanguage != null && supportedLanguages.containsKey(savedLanguage)) {
      _currentLocale = supportedLanguages[savedLanguage]!;
      notifyListeners();
    }
  }

  Future<void> setLanguage(String languageName) async {
    if (supportedLanguages.containsKey(languageName)) {
      _currentLocale = supportedLanguages[languageName]!;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageName);
      notifyListeners();
    }
  }

  String getCurrentLanguageName() {
    return supportedLanguages.entries
        .firstWhere((entry) => entry.value == _currentLocale,
            orElse: () => const MapEntry('English', Locale('en')))
        .key;
  }
}
