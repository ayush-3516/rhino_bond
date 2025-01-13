import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages session tokens using `FlutterSecureStorage`.
class SessionManager {
  static final _storage = FlutterSecureStorage();

  /// Saves the session token securely.
  static Future<void> saveSession(String token) async {
    await _storage.write(key: 'session_token', value: token);
  }

  /// Retrieves the session token securely.
  static Future<String?> getSession() async {
    return await _storage.read(key: 'session_token');
  }

  /// Clears the session token securely.
  static Future<void> clearSession() async {
    await _storage.delete(key: 'session_token');
  }
}
