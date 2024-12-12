import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../base/utils/auth_validators.dart';
import '../../../services/auth/auth_view_model.dart';

class LoginViewModel extends BaseViewModel {
  final TextEditingController phoneController = TextEditingController();
  final _authViewModel = AuthViewModel();
  bool isPhoneNumberValid = false;

  void onPhoneNumberChanged(String value) {
    isPhoneNumberValid = AuthValidators.validatePhoneNumber(value) == null;
    notifyListeners();
  }

  Future<void> signInWithPhone() async {
    if (!isPhoneNumberValid) return;

    setBusy(true);
    try {
      final formattedPhone = AuthValidators.formatPhoneNumber(phoneController.text);
      await _authViewModel.signInWithPhone(formattedPhone);
      // Navigate to OTP verification screen
      navigateToVerifyOtp(formattedPhone);
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  void navigateToVerifyOtp(String phoneNumber) {
    // TODO: Implement navigation to OTP verification screen
  }

  void navigateToRegister() {
    // TODO: Implement navigation to registration screen
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
