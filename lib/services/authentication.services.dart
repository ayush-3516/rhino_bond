import 'package:supabase/supabase.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;
import 'package:rhino_bond/models/user.dart';
import 'package:flutter/material.dart';
import 'package:rhino_bond/utils/logger.dart';
import 'package:rhino_bond/services/secure_storage_service.dart';

/// Handles authentication-related operations such as sending verification codes, verifying phone numbers, and fetching user profiles.
class AuthenticationService {
  static final supabaseClient = supabase_flutter.Supabase.instance.client;
  final SecureStorageService _secureStorage = SecureStorageService();

  /// Changes the user's password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Update password using Supabase auth
      await supabaseClient.auth.updateUser(
        supabase_flutter.UserAttributes(password: newPassword),
      );
      Logger.success("Password changed successfully");
    } catch (e) {
      Logger.error("Error changing password: $e");
      rethrow;
    }
  }

  /// Logs out the current user.
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
      await _secureStorage.deleteAll();
      Logger.success("User logged out successfully and tokens cleared");
    } catch (e) {
      Logger.error("Error during logout: $e");
      rethrow;
    }
  }

  /// Sets up an authentication state listener to handle user login and logout events.
  void setupAuthListener() {
    Logger.debug("Setting up authentication state listener");
    supabaseClient.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      final session = data.session;
      Logger.debug(
          "Auth state changed - Event: $event, Session: ${session != null}");

      try {
        if (session != null) {
          Logger.info("User logged in - ID: ${session.user.id}");
          // Store access token securely
          await _secureStorage.write('access_token', session.accessToken);
          if (session.refreshToken != null) {
            await _secureStorage.write('refresh_token', session.refreshToken!);
          }

          // Fetch user profile and notify listeners
          final userProfile = await getUserProfile(session.user.id);
          if (userProfile != null) {
            Logger.success("User profile loaded successfully");
          }
        } else if (event == supabase_flutter.AuthChangeEvent.signedOut) {
          Logger.info("User signed out successfully");
        } else if (event == supabase_flutter.AuthChangeEvent.tokenRefreshed) {
          Logger.debug("Session token refreshed successfully");
        }
      } catch (e) {
        Logger.error("Error handling auth state change: $e");
      }
    });
  }

  /// Starts the authentication listener.
  void startAuthListener() {
    setupAuthListener();
  }

  /// Fetches the user profile for the specified user ID.
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      Logger.debug("Fetching user profile for ID: $userId");
      final response = await supabaseClient
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        final userProfile = User.fromJson(response);
        Logger.success(
            "User profile fetched: ${userProfile.name}, ${userProfile.email}");
        return userProfile.toJson();
      }
      Logger.warning("No user profile found for ID: $userId");
      return null;
    } on supabase.PostgrestException catch (e) {
      Logger.error("Database error fetching user profile: ${e.message}");
      return null;
    } catch (e) {
      Logger.error("Error fetching user profile: $e");
      return null;
    }
  }

  /// Sends a verification code to the specified phone number.
  Future sendVerificationCode({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    Logger.debug("Entering sendVerificationCode method");
    Logger.info("Sending verification code to phone number: $phoneNumber");
    try {
      await supabaseClient.auth.signInWithOtp(
        phone: phoneNumber,
      );
      Logger.success("OTP sent successfully to $phoneNumber");
      return (null);
    } on supabase.AuthException catch (e) {
      Logger.error("Error sending verification code: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Process Failed: ${e.toString()}")));
      rethrow;
    }
  }

  /// Returns the current user ID from the session.
  String get currentUserId {
    final user = supabaseClient.auth.currentUser;
    return user?.id ?? '';
  }

  /// Creates a new user profile in the database.
  Future<void> createUserProfile(String userId, String phoneNumber) async {
    try {
      // Create minimal profile with just ID and phone number
      await supabaseClient.from('users').insert({
        'id': userId,
        'phone': phoneNumber,
        'name': 'User',
        'email': '$userId@rhinobond.com'
      });
      Logger.success("Minimal user profile created successfully for $userId");
    } catch (e) {
      Logger.error("Error creating user profile: $e");
      rethrow;
    }
  }

  /// Verifies the phone number using the provided token.
  Future<Map<String, dynamic>> verifyPhoneNumber({
    required BuildContext context,
    required String token,
    required String phoneNumber,
  }) async {
    Logger.debug("Entering verifyPhoneNumber method");
    try {
      final response = await supabaseClient.auth.verifyOTP(
          type: supabase_flutter.OtpType.sms, phone: phoneNumber, token: token);
      Logger.debug("verifyPhoneNumber response: $response");

      // Check if user profile exists before creating
      if (response.user != null) {
        final userId = response.user!.id;
        final existingProfile = await getUserProfile(userId);
        if (existingProfile == null) {
          // Create minimal profile, user will complete registration later
          await createUserProfile(userId, phoneNumber);
          return {'status': 'success', 'isNewUser': true, 'userId': userId};
        } else {
          Logger.debug("User profile already exists, skipping creation");
          return {'status': 'success', 'isNewUser': false, 'userId': userId};
        }
      }
      return {'status': 'error', 'message': 'User not found in response'};
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Process Failed: ${e.toString()}")));
      rethrow;
    }
  }

  /// Updates user profile with name and email
  Future<void> updateUserProfile({
    required String userId,
    required String name,
    required String email,
  }) async {
    try {
      await supabaseClient.from('users').update({
        'name': name,
        'email': email,
      }).eq('id', userId);
      Logger.success("User profile updated successfully for $userId");
    } catch (e) {
      Logger.error("Error updating user profile: $e");
      rethrow;
    }
  }

  /// Fetches active events from the database
  Future<List<Map<String, dynamic>>> getActiveEvents() async {
    try {
      Logger.debug("Fetching all active events");

      // Get all active events without date filtering
      final response = await supabaseClient
          .from('events')
          .select('*')
          .eq('is_active', true)
          .order('start_date');

      Logger.debug("Found ${response.length} active events");

      return response;
    } catch (e) {
      Logger.error("Error fetching events: $e");
      return [];
    }
  }
}
