class AuthConstants {
  static const String phoneNumberKey = 'phone_number';
  static const String userIdKey = 'user_id';
  static const String authTokenKey = 'auth_token';
  
  // Validation Constants
  static const int otpLength = 6;
  static const int phoneNumberMinLength = 10;
  static const int phoneNumberMaxLength = 15;
  
  // Error Messages
  static const String invalidPhoneNumber = 'Please enter a valid phone number';
  static const String invalidOtp = 'Please enter a valid OTP';
  static const String invalidName = 'Please enter your name';
  static const String userNotFound = 'No user found with this phone number';
  static const String userExists = 'User already exists with this phone number';
  static const String networkError = 'Please check your internet connection';
  static const String unknownError = 'Something went wrong. Please try again';
  
  // Success Messages
  static const String otpSent = 'OTP sent successfully';
  static const String loginSuccess = 'Login successful';
  static const String registrationSuccess = 'Registration successful';
  static const String logoutSuccess = 'Logged out successfully';
}
