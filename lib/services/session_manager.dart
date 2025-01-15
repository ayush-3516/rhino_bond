import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rhino_bond/utils/logger.dart';

/// Manages session tokens using `FlutterSecureStorage`.
class SessionManager {
  static final _storage = FlutterSecureStorage();

  /// Saves the session token securely.
  static Future<void> saveSession(String token) async {
    Logger.debug('Saving session token');
    try {
      await _storage.write(key: 'session_token', value: token);
      Logger.success('Session token saved successfully');
    } catch (e) {
      Logger.error('Failed to save session token: ${e.toString()}');
      rethrow;
    }
  }

  /// Retrieves the session token securely.
  static Future<String?> getSession() async {
    Logger.debug('Retrieving session token');
    try {
      final token = await _storage.read(key: 'session_token');
      if (token == null) {
        Logger.warning('No session token found');
      } else {
        Logger.debug('Session token retrieved successfully');
      }
      return token;
    } catch (e) {
      Logger.error('Failed to retrieve session token: ${e.toString()}');
      rethrow;
    }
  }

  /// Clears the session token securely.
  static Future<void> clearSession() async {
    Logger.debug('Clearing session token');
    try {
      await _storage.delete(key: 'session_token');
      Logger.success('Session token cleared successfully');
    } catch (e) {
      Logger.error('Failed to clear session token: ${e.toString()}');
      rethrow;
    }
  }
}
