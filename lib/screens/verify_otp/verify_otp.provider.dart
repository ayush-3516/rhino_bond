import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/notifiers/authentication.notifier.dart';

class VerifyOTPProvider with ChangeNotifier {
  final TextEditingController otpController = TextEditingController();

  void verifyPhoneNumber(BuildContext context, String phoneNumber) async {
    final AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    authenticationNotifier.verifyPhoneNumber(
        context: context, token: otpController.text, phoneNumber: phoneNumber);
  }
}
