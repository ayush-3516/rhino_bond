import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/views/screens/login/login_controller.dart';
import 'package:rhino_bond/views/screens/login/login_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
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
                      child: Consumer<LoginController>(
                        builder: (context, loginController, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LoginWidgets.buildPhoneNumberField(
                                  loginController.phoneController,
                                  loginController.isLoading),
                              const SizedBox(height: 16),
                              if (!loginController.otpSent) ...[
                                LoginWidgets.buildSendOtpButton(
                                    loginController.isLoading,
                                    () => loginController.sendOtp(context)),
                              ] else ...[
                                LoginWidgets.buildOtpField(
                                    loginController.otpController,
                                    loginController.isLoading),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: LoginWidgets.buildBackButton(
                                          loginController.isLoading, () {
                                        setState(() {
                                          loginController.otpSent = false;
                                          loginController.otpController.clear();
                                        });
                                      }),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: LoginWidgets.buildVerifyButton(
                                          loginController.isLoading,
                                          () => loginController.login(context)),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 24),
                              Center(
                                child: LoginWidgets.buildNoAccountSignUpButton(
                                    loginController.isLoading, () {
                                  Navigator.pushReplacementNamed(
                                      context, '/register');
                                }),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Consumer<LoginController>(
            builder: (context, loginController, child) {
              return loginController.isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}
