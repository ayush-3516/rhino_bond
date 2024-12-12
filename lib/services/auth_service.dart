import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final SupabaseClient _supabaseClient = SupabaseClient(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_KEY']!,
  );

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> signInWithPhone(String phone, String password) async {
    final response = await _supabaseClient.auth.signIn(
      phone: phone,
      password: password,
    );

    if (response.error != null) {
      throw response.error!.message;
    }

    await _prefs.setString('user_token', response.data!.session!.accessToken);
  }

  static Future<void> signUpWithPhone(String phone, String password) async {
    final response = await _supabaseClient.auth.signUp(
      phone: phone,
      password: password,
    );

    if (response.error != null) {
      throw response.error!.message;
    }
  }

  static Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
    await _prefs.remove('user_token');
  }

  static Future<bool> isUserLoggedIn() async {
    final token = _prefs.getString('user_token');
    return token != null;
  }
}
