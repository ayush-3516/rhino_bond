import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/notifiers/authentication.notifier.dart';

/// A StatefulWidget that represents the OTP verification view for users.
class OTPVerificationView extends StatefulWidget {
  /// The phone number to which the OTP was sent.
  final String phoneNumber;

  /// Creates an instance of [OTPVerificationView].
  const OTPVerificationView({super.key, required this.phoneNumber});

  @override
  _OTPVerificationViewState createState() => _OTPVerificationViewState();
}

/// The state class for the [OTPVerificationView] widget.
class _OTPVerificationViewState extends State<OTPVerificationView> {
  /// Controller for the OTP input field.
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /// Retrieves the [AuthenticationNotifier] from the provider.
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);

    return Scaffold(
      body: Stack(
        children: [
          /// Background gradient for the OTP verification view.
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
                    /// Back button to navigate back to the previous screen.
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 48),
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the OTP sent to ${widget.phoneNumber}',
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
                          /// Input field for entering the OTP.
                          TextFormField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              labelText: 'OTP',
                              prefixIcon:
                                  Icon(Icons.lock, color: Colors.purple[700]),
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

                          /// Button to verify the OTP.
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final result = await authenticationNotifier
                                    .verifyPhoneNumber(
                                  context: context,
                                  token: _otpController.text,
                                  phoneNumber: widget.phoneNumber,
                                );

                                if (result['status'] == 'success') {
                                  // Navigate to appropriate screen based on user status
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    result['isNewUser'] == true
                                        ? '/complete_profile'
                                        : '/',
                                    (route) => false,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          result['message'] ?? "Login Failed"),
                                    ),
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
                                'Verify OTP',
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
