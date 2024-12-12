import 'package:supabase_flutter/supabase_flutter.dart';
import '../../base/utils/local_db_keys.dart';
import '../../models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static late final SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> register(String phoneNumber, String email) async {
    try {
      // Check if user exists
      final userExists =
          await checkUserExistsWithPhoneNumberAndEmail(phoneNumber, email);
      if (userExists) {
        throw Exception(
            'User with this phone number already exists, please login to continue');
      }

      // Send OTP to phone number
      final otpResponse =
          await _supabase.auth.signInWithOtp(phone: phoneNumber);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<AppUser?> verifyPhoneNumberAndRegister({
    required String email,
    required String name,
    required String phone,
    required String otp,
  }) async {
    try {
      // Verify OTP
      final response = await _supabase.auth.verifyOTP(
        phone: phone,
        token: otp,
        type: OtpType.sms,
      );
      if (response.user == null) {
        throw Exception('Please enter a valid code');
      }

      final AppUser user = AppUser(
        id: response.user?.id,
        email: email,
        name: name,
        phone: phone,
      );

      final createdUser = await _createUser(user);
      if (createdUser == null) {
        throw Exception('Unable to create user');
      }

      _storeLocally(createdUser);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> login(String phoneNumber) async {
    try {
      // Check if user exists
      final userExists = await checkUserExistsWithPhoneNumber(phoneNumber);
      if (!userExists) {
        throw Exception('User does not exist, please register first');
      }

      // Send OTP to phone number
      final otpResponse =
          await _supabase.auth.signInWithOtp(phone: phoneNumber);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<AppUser?> verifyPhoneNumberAndLogin({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        phone: phone,
        token: otp,
        type: OtpType.sms,
      );
      if (response.user == null) {
        throw Exception('Please enter a valid code');
      }

      final user = await _getUser(response.user!.id);
      if (user == null) {
        throw Exception('Unable to find user');
      }

      _storeLocally(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> checkUserExistsWithPhoneNumber(String phoneNumber) async {
    try {
      final response = await _supabase
          .from('app_users')
          .select()
          .eq('phone', phoneNumber)
          .single();
      return response['id'] != null;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> checkUserExistsWithPhoneNumberAndEmail(
      String phoneNumber, String email) async {
    try {
      final response = await _supabase
          .from('app_users')
          .select()
          .or('phone.eq.$phoneNumber,email.eq.$email');
      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<AppUser?> _createUser(AppUser user) async {
    try {
      final createdUser = await _supabase
          .from('app_users')
          .insert(user.toMap())
          .select()
          .single();
      return AppUser.fromMap(createdUser);
    } catch (e) {
      return null;
    }
  }

  static Future<AppUser?> _getUser(String id) async {
    try {
      final response =
          await _supabase.from('app_users').select('*').eq('id', id).single();
      return AppUser.fromMap(response);
    } catch (e) {
      return null;
    }
  }

  static void _storeLocally(AppUser user) {
    prefs.setString(LocalDatabaseKeys.appUser, user.toJson());
  }

  static Future<void> logout() async {
    await _supabase.auth.signOut();
    prefs.remove(LocalDatabaseKeys.appUser);
  }
}
