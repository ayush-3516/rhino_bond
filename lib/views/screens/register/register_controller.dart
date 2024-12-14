import 'package:flutter/material.dart';
import 'package:rhino_bond/views/screens/otp/otp_screen.dart'; // Import OtpScreen

class RegisterController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool otpSent = false;

  void dispose() {
    nameController.dispose();
    emailController.dispose();
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

  Future<void> register(BuildContext context) async {
    final name = nameController.text;
    final email = emailController.text;
    final phoneNumber = phoneController.text;
    final otp = otpController.text;

    if (name.isEmpty || phoneNumber.isEmpty || otp.isEmpty) {
      _showErrorSnackBar(context, 'Name, phone number, and OTP are required');
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      // Simulate verifying OTP
      await Future.delayed(const Duration(seconds: 2));

      // Simulate successful registration
      _showSuccessSnackBar(context, 'Registration successful');
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      _showErrorSnackBar(context, e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void bypassRegister(BuildContext context) {
    // Simulate bypassing registration
    _showSuccessSnackBar(context, 'Bypassing registration');
    Navigator.pushReplacementNamed(context, '/dashboard');
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
