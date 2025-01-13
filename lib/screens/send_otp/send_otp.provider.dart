import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/notifiers/authentication.notifier.dart';

class SendOTPProvider with ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();

  void sendVerificationCode(BuildContext context) async {
    final AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    authenticationNotifier.sendVerificationCode(
        context: context, phoneNumber: phoneController.text);
  }
}
