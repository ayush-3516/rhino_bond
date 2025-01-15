import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Logger {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _cyan = '\x1B[36m';

  static void info(String message) {
    _log('INFO', _blue, message);
  }

  static void success(String message) {
    _log('SUCCESS', _green, message);
  }

  static void warning(String message) {
    _log('WARNING', _yellow, message);
  }

  static void error(String message) {
    _log('ERROR', _red, message);
  }

  static void debug(String message) {
    if (kDebugMode) {
      _log('DEBUG', _cyan, message);
    }
  }

  static void _log(String level, String color, String message) {
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    print('$color[$timestamp] [$level] $message$_reset');
  }
}
