import 'package:flutter/material.dart';
import 'package:rhino_bond/services/authentication.services.dart';
import 'package:rhino_bond/widgets/providers/user_provider.dart';
import 'package:rhino_bond/utils/logger.dart';

/// Manages authentication state and interacts with the authentication service.
class AuthenticationNotifier extends ChangeNotifier {
  late final AuthenticationService _authenticationService;
  final UserProvider _userProvider;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  AuthenticationNotifier(
    AuthenticationService authenticationService,
    UserProvider userProvider,
  ) : _userProvider = userProvider {
    _authenticationService = authenticationService;
  }

  Future<void> logout() async {
    try {
      setLoading(true);
      await _authenticationService.logout();
      _isAuthenticated = false;
      _currentUser = null;
      notifyListeners();
      Logger.success("Logged out successfully");
    } catch (e) {
      Logger.error("Error during logout: $e");
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Indicates whether the user is authenticated.
  bool _isAuthenticated = false;

  /// Returns the authentication status of the user.
  bool get isAuthenticated => _isAuthenticated;

  /// Updates the authentication status of the user.
  void setAuthenticated(bool value) {
    Logger.info("Setting authentication status to: $value");
    _isAuthenticated = value;
    notifyListeners();
    Logger.info("Authentication status updated and listeners notified");
  }

  /// Starts the authentication listener.
  void startAuthListener() {
    _authenticationService.startAuthListener();
  }

  /// Returns the authentication service instance.
  AuthenticationService get authenticationService => _authenticationService;

  /// Updates the user profile and notifies listeners.
  void notifyUserProfile(Map<String, dynamic> userProfile) {
    try {
      // Only update and notify if the user data has actually changed
      if (_currentUser?['id'] != userProfile['id']) {
        Logger.info(
            "Setting user profile: ${userProfile['name']}, ${userProfile['email']}");
        Logger.info("Full User Data: $userProfile");
        _currentUser = userProfile;
        _isAuthenticated = true;
      }
    } catch (e) {
      Logger.error("Error notifying user profile: $e");
      rethrow;
    }
  }

  /// Fetches the user profile for the current authenticated user.
  Future<void> fetchCurrentUserProfile() async {
    if (_isAuthenticated && _currentUser == null) {
      Logger.info("Fetching current user profile");
      await fetchUserProfile(_authenticationService.currentUserId);
    }
  }

  /// Indicates whether the phone number is verified.
  bool _isPhoneNumberVerified = false;

  /// Returns the phone number verification status.
  bool get isPhoneNumberVerified => _isPhoneNumberVerified;

  /// The current authenticated user.
  Map<String, dynamic>? _currentUser;

  /// Returns the current authenticated user.
  Map<String, dynamic>? get currentUser => _currentUser;

  /// Sends a verification code to the specified phone number.
  Future<String?> sendVerificationCode({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    Logger.info("Sending verification code to phone number: $phoneNumber");
    try {
      await _authenticationService.sendVerificationCode(
          context: context, phoneNumber: phoneNumber);
      _isPhoneNumberVerified = true;
      notifyListeners();
      Logger.success("OTP sent successfully");
      return "Verification Code sent successfully";
    } catch (e) {
      Logger.error("$e");
      return "Failed to send verification code";
    }
  }

  /// Verifies the phone number using the provided token.
  final bool _isShowingRegistration = false;

  Future<Map<String, dynamic>> verifyPhoneNumber({
    required String token,
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      if (_isShowingRegistration) {
        return {
          'status': 'pending',
          'message': 'Registration already in progress'
        };
      }

      final response = await _authenticationService.verifyPhoneNumber(
          token: token, context: context, phoneNumber: phoneNumber);
      final isNewUser = response['isNewUser'] as bool;

      _isPhoneNumberVerified = true;
      _isAuthenticated = true;
      notifyListeners();

      if (isNewUser) {
        Navigator.of(context).pushReplacementNamed('/complete_profile');
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
      return {
        'status': 'success',
        'isNewUser': isNewUser,
      };
    } catch (e) {
      Logger.error("$e");
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  Future<void> completeRegistration({
    required String userId,
    required String name,
    required String email,
  }) async {
    try {
      await _authenticationService.updateUserProfile(
        userId: userId,
        name: name,
        email: email,
      );
      // Refresh user profile
      await fetchUserProfile(userId);
    } catch (e) {
      Logger.error("Error completing registration: $e");
      rethrow;
    }
  }

  /// Fetches the user profile for the specified user ID.
  Future<void> fetchUserProfile(String userId) async {
    Logger.info("Fetching user profile for ID: $userId");
    try {
      final userProfile = await _authenticationService.getUserProfile(userId);
      if (userProfile != null) {
        notifyUserProfile(userProfile);
        Logger.info(
            "User profile fetched: ${userProfile['name']}, ${userProfile['email']}");

        // Update UserProvider with all user data
        _userProvider.setUserData(userProfile);
      } else {
        Logger.info("User profile is null");
      }
    } catch (e) {
      Logger.info("Failed to fetch user profile: $e");
    }
  }
}
