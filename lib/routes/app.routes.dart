import 'package:flutter/material.dart';
import 'package:rhino_bond/screens/home/home_view.dart';
import 'package:rhino_bond/screens/send_otp/send_otp.view.dart';
import 'package:rhino_bond/screens/verify_otp/verify_otp.view.dart';
import 'package:rhino_bond/widgets/auth_wrapper.dart';
import 'package:rhino_bond/screens/settings/settings_screen.dart';
import 'package:rhino_bond/screens/contact_faq/contact_faq_screen.dart';
import 'package:rhino_bond/screens/edit_profile/edit_profile_screen.dart';
import 'package:rhino_bond/screens/user_details/user_details_screen.dart';
import 'package:rhino_bond/screens/reward_products_screen.dart';
import 'package:rhino_bond/screens/rewards_history_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/rewards_history': (context) => const RewardsHistoryScreen(),
  '/': (context) => const AuthWrapper(child: HomeView()),
  '/home': (context) => WillPopScope(
        onWillPop: () async => false,
        child: const AuthWrapper(child: HomeView()),
      ),
  '/send_otp': (context) => WillPopScope(
        onWillPop: () async => false,
        child: const AuthenticationView(),
      ),
  '/verify_otp': (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! String) {
      Navigator.pop(context);
      return const SizedBox.shrink();
    }
    return OTPVerificationView(phoneNumber: args);
  },
  '/settings': (context) => const SettingsScreen(),
  '/contact_faq': (context) => const ContactFAQScreen(),
  '/edit_profile': (context) => const EditProfileScreen(),
  '/user-details': (context) => const UserDetailsScreen(),
  '/rewards': (context) => const RewardProductsScreen(),
};
