import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:phone_auth_twillio/src/base/utils/local_db_keys.dart';
import 'package:phone_auth_twillio/src/base/utils/supabase_tables.dart';
import 'package:phone_auth_twillio/src/configs/app_setup.locator.dart';
import 'package:phone_auth_twillio/src/models/app_user.dart';
import 'package:phone_auth_twillio/src/services/local/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService with ListenableServiceMixin {
  static late final SharedPreferences prefs;

  static final ConnectivityService _connectivityService =
      locator<ConnectivityService>();

  static final _supabase = Supabase.instance.client;

  final ReactiveValue<bool> _userLoggedIn =
      ReactiveValue(_supabase.auth.currentSession != null);

  bool get userLoggedIn => _userLoggedIn.value;

  final ReactiveValue<AppUser?> _appUser = ReactiveValue<AppUser?>(null);

  AppUser? get user => _appUser.value;

  SupabaseAuthService() {
    listenToReactiveValues([_appUser, _userLoggedIn]);
    _syncUser();
    _restoreUserFromLocal();
    _setupAuthListner();
  }

  _setupAuthListner() {
    _supabase.auth.onAuthStateChange.listen(
      (data) {
        _userLoggedIn.value = data.session != null;
      },
    );
  }

  Future<bool> register(
    String phoneNumber,
    String email,
  ) async {
    if (!_connectivityService.isInternetConnected) {
      throw CustomNoInternetException(message: 'No Internet Connection');
    }
    try {
      // Check if user exists
      final userExists = await checkUserExistsWithPhoneNumberAndEmail(
        phoneNumber,
        email,
      );

      if (userExists) {
        throw AuthExcepection(
          message:
              'User with this phone number already exist, please login to continue',
        );
      }

      // Send OTP to phone number
      final otpResponse = await _supabase.auth.signInWithOtp(
        phone: phoneNumber,
      );

      return true;
    } on AuthApiException catch (e) {
      throw AuthExcepection(message: e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<AppUser?> verifyPhoneNumberAndRegister({
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
        throw AuthExcepection(message: 'Please enter a valid code');
      }

      final AppUser user = AppUser(
        id: response.user?.id,
        email: email,
        name: name,
        phone: phone,
      );

      final createdUser = await _createUser(user);

      if (createdUser == null) {
        throw AuthExcepection(message: 'Unable to create user');
      }

      _appUser.value = createdUser;
      _storeLocally();

      return createdUser;
    } on AuthApiException catch (e) {
      print(e.statusCode);
      print('error: ${e.message}');
      if (e.statusCode == '403' &&
          e.message.toLowerCase().startsWith('token has expired')) {
        throw AuthExcepection(message: 'Please enter a valid code');
      }
      throw AuthExcepection(message: e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<AppUser?> verifyPhoneNumberAndLogin({
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
        throw AuthExcepection(message: 'Please enter a valid code');
      }

      final user = await _getUser(response.user!.id);

      if (user == null) {
        throw AuthExcepection(message: 'Unable to find user');
      }

      _appUser.value = user;
      _storeLocally();

      return user;
    } on AuthApiException catch (e) {
      print(e.statusCode);
      print('error: ${e.message}');
      if (e.statusCode == '403' &&
          e.message.toLowerCase().startsWith('token has expired')) {
        throw AuthExcepection(message: 'Please enter a valid code');
      }
      throw AuthExcepection(message: e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> login(String phoneNumber) async {
    if (!_connectivityService.isInternetConnected) {
      throw CustomNoInternetException(message: 'No Internet Connection');
    }
    try {
      // Check if user exists
      final userExists = await checkUserExistsWithPhoneNumber(phoneNumber);
      if (!userExists) {
        throw AuthExcepection(
            message: 'User does not exist, please register first');
      }

      // Send OTP to phone number
      final otpResponse = await _supabase.auth.signInWithOtp(
        phone: phoneNumber,
      );

      return true;
    } on AuthApiException catch (e) {
      throw AuthExcepection(message: e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUserExistsWithPhoneNumber(String phoneNumber) async {
    try {
      print('checkUserExistsWithPhoneNumber called');
      final response = await _supabase
          .from(SupabaseTables.appUsers)
          .select()
          .eq('phone', phoneNumber)
          .single();
      print('checkUserExistsWithPhoneNumber called');

      return response['id'] != null;
    } catch (e) {
      print('checkUserExistsWithPhoneNumber called');

      print('error in checkUserExistsWithPhoneNumber: $e');
      return false;
    }
  }

  Future<bool> checkUserExistsWithPhoneNumberAndEmail(
      String phoneNumber, String email) async {
    try {
      print('checkUserExistsWithPhoneNumberAndEmail called');
      final response = await _supabase
          .from(SupabaseTables.appUsers)
          .select()
          .or('phone.eq.${phoneNumber},email.eq.${email}');
      print('checkUserExistsWithPhoneNumberAndEmail called');

      return response.isNotEmpty;
    } catch (e) {
      print('checkUserExistsWithPhoneNumberAndEmail called');

      print('error in checkUserExistsWithPhoneNumberAndEmail: $e');
      return false;
    }
  }

  Future logout() async {
    if (!_connectivityService.isInternetConnected) {
      throw CustomNoInternetException(message: 'No Internet Connection');
    }
    try {
      await _supabase.auth.signOut();
      _clearUserFromLocal();
    } catch (e) {
      throw AuthExcepection(message: e.toString());
    }
  }

  Future<AppUser?> _createUser(AppUser? user) async {
    try {
      print('create user called');

      print(user?.toMap());
      AppUser? response;
      if (user != null) {
        final createdUser = await _supabase
            .from(SupabaseTables.appUsers)
            .insert(user.toMap())
            .select()
            .single();

        print('created user: $createdUser');
        response = AppUser.fromMap(createdUser);
      }

      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<AppUser?> _getUser(String id) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.appUsers)
          .select('*')
          .eq('id', id)
          .single();
      print('user: $response');
      return AppUser.fromMap(response);
    } catch (e) {
      print(e);
      return null;
    }
  }

  _syncUser() async {
    if (!_connectivityService.isInternetConnected) {
      print('no internet');
    }
    if (_supabase.auth.currentSession == null) {
      print('supabase auth session is null');
      return;
    }

    final response = await _getUser(_supabase.auth.currentUser!.id);

    if (response != null) {
      _appUser.value = response;
      _storeLocally();
    }
  }

  //FOR LOCAL DB
  _storeLocally() async {
    if (_appUser.value == null) return;
    prefs.setString(
        LocalDatabaseKeys.appUser, _appUser.value?.toJson() ?? "{}");
  }

  _restoreUserFromLocal() async {
    if (!prefs.containsKey(LocalDatabaseKeys.appUser)) return;

    final savedUser = prefs.getString(LocalDatabaseKeys.appUser) ?? "{}";

    if (savedUser == "{}") {
      _appUser.value = null;
      return;
    }

    _appUser.value = AppUser.fromMap(
        jsonDecode(prefs.getString(LocalDatabaseKeys.appUser) ?? "{}")
            as Map<String, dynamic>);
  }

  _clearUserFromLocal() async {
    if (!prefs.containsKey(LocalDatabaseKeys.appUser)) return;
    prefs.remove(LocalDatabaseKeys.appUser);
    _appUser.value = null;
  }
}

class AuthExcepection implements Exception {
  final String message;

  AuthExcepection({required this.message});
}

class CustomNoInternetException implements Exception {
  final String message;

  CustomNoInternetException({required this.message});
}
