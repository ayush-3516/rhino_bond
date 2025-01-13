import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _localeKey = 'app_locale';
  Locale _locale = const Locale('en');

  LanguageProvider() {
    _loadSavedLocale();
  }

  Locale get locale => _locale;

  String get currentLanguage {
    switch (_locale.languageCode) {
      case 'en':
        return 'English';
      case 'gu':
        return 'Gujarati';
      case 'hi':
        return 'Hindi';
      case 'mr':
        return 'Marathi';
      case 'pa':
        return 'Punjabi';
      default:
        return 'English';
    }
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey) ?? 'en';
    _locale = Locale(localeCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale newLocale) async {
    if (!['en', 'gu', 'hi', 'mr', 'pa'].contains(newLocale.languageCode)) {
      return;
    }

    if (_locale != newLocale) {
      _locale = newLocale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, newLocale.languageCode);
      notifyListeners();
    }
  }
}
