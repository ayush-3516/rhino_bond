import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.purple[700],
    colorScheme: ColorScheme.light(
      primary: Colors.purple[700]!,
      secondary: Colors.purple[500]!,
      error: Colors.red[700]!,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.purple[700],
      foregroundColor: Colors.white,
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.purple[800],
    colorScheme: ColorScheme.dark(
      primary: Colors.purple[800]!,
      secondary: Colors.purple[600]!,
      error: Colors.red[400]!,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.purple[900],
      foregroundColor: Colors.white,
    ),
  );
}
