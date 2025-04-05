import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/notifiers/authentication.notifier.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPVerificationView extends StatefulWidget {
  final String phoneNumber;
  const OTPVerificationView({super.key, required this.phoneNumber});

  @override
  _OTPVerificationViewState createState() => _OTPVerificationViewState();
}

class _OTPVerificationViewState extends State<OTPVerificationView>
    with CodeAutoFill {
  final TextEditingController _otpController = TextEditingController();
  String? _appSignature;

  @override
  void initState() {
    super.initState();
    _initSmsAutofill();
  }

  Future<void> _initSmsAutofill() async {
    try {
      _appSignature = await SmsAutoFill().getAppSignature;
      await SmsAutoFill().listenForCode();
    } catch (e) {
      print('SMS Autofill initialization error: $e');
    }
  }

  @override
  void codeUpdated() {
    final otp = _extractOtp(code ?? '');
    if (otp != null && otp.length == 6) {
      setState(() {
        _otpController.text = otp;
      });
      Future.delayed(const Duration(milliseconds: 300), _verifyOtp);
    }
  }

  String? _extractOtp(String message) {
    final match =
        RegExp(r'Your OTP for Rhino Bond is (\d{4,6})').firstMatch(message);
    return match?.group(1);
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    try {
      final auth = Provider.of<AuthenticationNotifier>(context, listen: false);
      final result = await auth.verifyPhoneNumber(
        context: context,
        token: _otpController.text,
        phoneNumber: widget.phoneNumber,
      );

      if (result['status'] == 'success') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          result['isNewUser'] == true ? '/complete_profile' : '/',
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Login Failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
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
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 48),
                    const Icon(Icons.account_balance_wallet,
                        size: 64, color: Colors.white),
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
                          PinFieldAutoFill(
                            controller: _otpController,
                            codeLength: 6,
                            keyboardType: TextInputType.number,
                            onCodeChanged: (code) {
                              if (code?.length == 6) _verifyOtp();
                            },
                            decoration: UnderlineDecoration(
                              textStyle: const TextStyle(fontSize: 20),
                              colorBuilder: PinListenColorBuilder(
                                Colors.purple[700]!,
                                Colors.purple[900]!,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _verifyOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade700,
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
