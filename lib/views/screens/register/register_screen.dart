import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register_controller.dart';
import 'register_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RegisterController>(context);

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
                    RegisterWidgets.buildHeader(context),
                    RegisterWidgets.buildDevelopmentModeSection(
                        context, () => controller.bypassRegister(context)),
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
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RegisterWidgets.buildFormField(
                              controller.nameController,
                              'Full Name',
                              Icons.person,
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            RegisterWidgets.buildFormField(
                              controller.emailController,
                              'Email',
                              Icons.email,
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return null; // Email is optional
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            RegisterWidgets.buildFormField(
                              controller.phoneController,
                              'Phone Number',
                              Icons.phone,
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            RegisterWidgets.buildOtpSection(
                              controller.isLoading,
                              controller.otpSent,
                              () => controller.sendOtp(context),
                              () => controller.register(context),
                              controller.otpController,
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the OTP';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    RegisterWidgets.buildLoginLink(context),
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
