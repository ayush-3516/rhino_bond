import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences.dart';
import '../../base/utils/constants.dart';
import '../../base/utils/supabase_tables.dart';
import '../../models/app_user.dart';

class AuthService {
  static final supabase = Supabase.instance.client;
  static late final SharedPreferences prefs;

  // Initialize the auth service
  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Check if user is authenticated
  bool get isAuthenticated => supabase.auth.currentUser != null;

  // Get current user
  User? get currentUser => supabase.auth.currentUser;

  // Sign in with phone
  Future<void> signInWithPhone(String phoneNumber) async {
    try {
      await supabase.auth.signInWithOtp(
        phone: phoneNumber,
        shouldCreateUser: false,
      );
    } catch (e) {
      throw AuthException('Failed to send OTP: $e');
    }
  }

  // Verify OTP
  Future<void> verifyOTP(String phoneNumber, String otp) async {
    try {
      await supabase.auth.verifyOTP(
        phone: phoneNumber,
        token: otp,
        type: OtpType.sms,
      );
    } catch (e) {
      throw AuthException('Failed to verify OTP: $e');
    }
  }

  // Sign up with phone
  Future<void> signUpWithPhone(String phoneNumber, String name) async {
    try {
      final userExists = await checkUserExistsWithPhoneNumber(phoneNumber);
      if (userExists) {
        throw AuthException('User already exists with this phone number');
      }

      await supabase.auth.signInWithOtp(
        phone: phoneNumber,
        shouldCreateUser: true,
      );
    } catch (e) {
      throw AuthException('Failed to sign up: $e');
    }
  }

  // Check if user exists with phone number
  Future<bool> checkUserExistsWithPhoneNumber(String phoneNumber) async {
    try {
      final response = await supabase
          .from(SupabaseTables.appUsers)
          .select()
          .eq('phone', phoneNumber)
          .single();
      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Create user profile
  Future<void> createUserProfile(AppUser user) async {
    try {
      await supabase.from(SupabaseTables.appUsers).insert(user.toJson());
    } catch (e) {
      throw AuthException('Failed to create user profile: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      await prefs.clear();
    } catch (e) {
      throw AuthException('Failed to sign out: $e');
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
