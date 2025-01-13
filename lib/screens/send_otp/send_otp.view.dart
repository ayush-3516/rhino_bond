import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/screens/verify_otp/verify_otp.view.dart';
import 'package:rhino_bond/notifiers/authentication.notifier.dart';

/// Represents the view for sending OTP (One-Time Password).
class AuthenticationView extends StatefulWidget {
  /// Creates an instance of [AuthenticationView].
  const AuthenticationView({super.key});

  @override
  _AuthenticationViewState createState() => _AuthenticationViewState();
}

/// Manages the state of the [AuthenticationView].
class _AuthenticationViewState extends State<AuthenticationView> {
  /// Controller for the phone number input field.
  final TextEditingController _phoneController =
      TextEditingController(text: '+91');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Retrieves the [AuthenticationNotifier] from the provider.
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);

    return Scaffold(
      body: Stack(
        children: [
          /// Background gradient for the authentication view.
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.purple.shade800,
                  Colors.purple.shade600,
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Input field for entering the phone number.
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon:
                                  Icon(Icons.phone, color: Colors.purple[700]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.purple[700]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.purple[700]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.purple[900]!,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.purple[700],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// Button to send the verification code.
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final result = await authenticationNotifier
                                    .sendVerificationCode(
                                  context: context,
                                  phoneNumber: _phoneController.text,
                                );
                                print(
                                    "Result of sendVerificationCode: $result");
                                if (result ==
                                    "Verification Code sent successfully") {
                                  // Navigate to OTP verification screen
                                  print("Navigating to /verify_otp");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OTPVerificationView(
                                        phoneNumber: _phoneController.text,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(result ??
                                            "Failed to send verification code")),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.purple.shade700,
                              ),
                              child: const Text(
                                'Send Verification',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
