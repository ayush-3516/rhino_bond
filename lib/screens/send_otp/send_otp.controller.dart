import 'package:flutter/material.dart';
import 'package:rhino_bond/screens/verify_otp/verify_otp.view.dart';

class SendOTPController {
  void navigateToOTPVerification(BuildContext context, String phoneNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPVerificationView(phoneNumber: phoneNumber),
      ),
    );
  }
}
