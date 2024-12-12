import 'auth_constants.dart';

class AuthValidators {
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AuthConstants.invalidPhoneNumber;
    }
    
    // Remove any non-digit characters
    final cleanNumber = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cleanNumber.length < AuthConstants.phoneNumberMinLength ||
        cleanNumber.length > AuthConstants.phoneNumberMaxLength) {
      return AuthConstants.invalidPhoneNumber;
    }
    
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return AuthConstants.invalidOtp;
    }
    
    if (value.length != AuthConstants.otpLength) {
      return AuthConstants.invalidOtp;
    }
    
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return AuthConstants.invalidOtp;
    }
    
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AuthConstants.invalidName;
    }
    return null;
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Add country code if not present
    if (!cleanNumber.startsWith('+')) {
      return '+$cleanNumber';
    }
    return cleanNumber;
  }
}
