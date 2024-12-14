import 'package:flutter/material.dart';

class LoginWidgets {
  static Widget buildPhoneNumberField(
      TextEditingController phoneController, bool isLoading) {
    return TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      enabled: !isLoading,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Phone Number',
        prefixIcon: const Icon(Icons.phone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
      ),
    );
  }

  static Widget buildOtpField(
      TextEditingController otpController, bool isLoading) {
    return TextFormField(
      controller: otpController,
      keyboardType: TextInputType.number,
      enabled: !isLoading,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Enter OTP',
        prefixIcon: const Icon(Icons.lock),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
      ),
    );
  }

  static Widget buildSendOtpButton(bool isLoading, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              )
            : const Text(
                'Send OTP',
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }

  static Widget buildVerifyButton(bool isLoading, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
            )
          : const Text(
              'Verify',
              style: TextStyle(fontSize: 16),
            ),
    );
  }

  static Widget buildBackButton(bool isLoading, VoidCallback onPressed) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: const Text(
        'Back',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  static Widget buildNoAccountSignUpButton(
      bool isLoading, VoidCallback onPressed) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: const Text(
        'No account? Sign up',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
