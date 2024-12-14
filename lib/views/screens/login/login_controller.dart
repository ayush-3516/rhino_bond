import 'package:flutter/material.dart';
import 'package:rhino_bond/views/screens/otp/otp_screen.dart'; // Import OtpScreen

class LoginController extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  bool otpSent = false;

  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  Future<void> sendOtp(BuildContext context) async {
    final phoneNumber = phoneController.text;

    if (phoneNumber.isEmpty) {
      _showErrorSnackBar(context, 'Phone number is required');
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      // Simulate sending OTP
      await Future.delayed(const Duration(seconds: 2));
      otpSent = true;
      _showSuccessSnackBar(context, 'OTP sent successfully');

      // Navigate to OtpScreen after sending OTP
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OtpScreen()),
      );
    } catch (e) {
      _showErrorSnackBar(context, e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(BuildContext context) async {
    final phoneNumber = phoneController.text;
    final otp = otpController.text;

    if (phoneNumber.isEmpty || otp.isEmpty) {
      _showErrorSnackBar(context, 'Phone number and OTP are required');
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      // Simulate verifying OTP
      await Future.delayed(const Duration(seconds: 2));

      // Simulate successful login
      _showSuccessSnackBar(context, 'Login successful');
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      _showErrorSnackBar(context, e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
