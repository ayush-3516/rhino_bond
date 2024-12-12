import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:rhino_bond/services/connectivity_service.dart';
import 'package:rhino_bond/models/app_user.dart';
import 'package:rhino_bond/services/remote/exceptions.dart';

class SupabaseAuthService {
  final SupabaseClient _supabase;
  final ConnectivityService _connectivityService;
  final ValueNotifier<AppUser?> _appUser = ValueNotifier(null);

  SupabaseAuthService(this._supabase, this._connectivityService);

  Future<bool> register(String phoneNumber, String email) async {
    if (!(await _connectivityService.isInternetConnected)) {
      throw CustomNoInternetException(message: 'No Internet Connection');
    }
    try {
      final userExists =
          await checkUserExistsWithPhoneNumberAndEmail(phoneNumber, email);
      if (userExists) {
        throw AuthApiException(
            message:
                'User with this phone number already exist, please login to continue',
            statusCode: 400);
      }
      final otpResponse =
          await _supabase.auth.signInWithOtp(phone: phoneNumber);
      return true;
    } on AuthApiException catch (e) {
      throw AuthApiException(message: e.message, statusCode: e.statusCode);
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
      final response = await _supabase.auth
          .verifyOTP(phone: phone, token: otp, type: OtpType.sms);
      if (response.user == null) {
        throw AuthApiException(
            message: 'Please enter a valid code', statusCode: 400);
      }
      final AppUser user = AppUser(
          id: response.user?.id, email: email, name: name, phone: phone);
      final createdUser = await _createUser(user);
      if (createdUser == null) {
        throw AuthApiException(
            message: 'Unable to create user', statusCode: 500);
      }
      _appUser.value = createdUser;
      _storeLocally();
      return createdUser;
    } on AuthApiException catch (e) {
      print(e.statusCode);
      print('error: ${e.message}');
      if (e.statusCode == 403 &&
          e.message.toLowerCase().startsWith('token has expired')) {
        throw AuthApiException(
            message: 'Please enter a valid code', statusCode: 403);
      }
      throw AuthApiException(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      rethrow;
    }
  }

  Future<AppUser?> verifyPhoneNumberAndLogin({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _supabase.auth
          .verifyOTP(phone: phone, token: otp, type: OtpType.sms);
      if (response.user == null) {
        throw AuthApiException(
            message: 'Please enter a valid code', statusCode: 400);
      }
      final AppUser user = AppUser(
          id: response.user?.id,
          email: response.user?.email ?? '', // Handle nullable email
          name: response.user?.name ?? '', // Handle nullable name
          phone: phone);
      _appUser.value = user;
      _storeLocally();
      return user;
    } on AuthApiException catch (e) {
      print(e.statusCode);
      print('error: ${e.message}');
      if (e.statusCode == 403 &&
          e.message.toLowerCase().startsWith('token has expired')) {
        throw AuthApiException(
            message: 'Please enter a valid code', statusCode: 403);
      }
      throw AuthApiException(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> login(String phoneNumber) async {
    if (!(await _connectivityService.isInternetConnected)) {
      throw CustomNoInternetException(message: 'No Internet Connection');
    }
    try {
      final otpResponse =
          await _supabase.auth.signInWithOtp(phone: phoneNumber);
      return true;
    } on AuthApiException catch (e) {
      throw AuthApiException(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _appUser.value = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  Future<void> _storeLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(_appUser.value));
  }

  Future<AppUser?> _createUser(AppUser user) async {
    final response =
        await _supabase.from('users').insert(user.toJson()).execute();
    if (response.status == 201) {
      return user;
    }
    return null;
  }

  Future<bool> checkUserExistsWithPhoneNumberAndEmail(
      String phoneNumber, String email) async {
    final response = await _supabase
        .from('users')
        .select()
        .eq('phone', phoneNumber)
        .eq('email', email)
        .execute();
    return response.data.length > 0;
  }
}
