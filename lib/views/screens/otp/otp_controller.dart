import 'package:flutter/material.dart';

class OtpController with ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  void submitOtp(BuildContext context) {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();
      // Simulate OTP submission
      Future.delayed(const Duration(seconds: 2), () {
        isLoading = false;
        notifyListeners();
        Navigator.of(context).pop();
      });
    }
  }
}
