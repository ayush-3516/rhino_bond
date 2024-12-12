import 'package:flutter/material.dart';
import 'view/account_screen.dart';
import 'view/change_password_screen.dart';
import 'view/contact_faq_screen.dart';
import 'view/dashboard_screen.dart';
import 'view/edit_profile_screen.dart';
import 'view/kyc_request_screen.dart';
import 'view/login_screen.dart';
import 'view/my_rewards_screen.dart';
import 'view/qr_scanner_screen.dart';
import 'view/register_screen.dart';
import 'view/rewards_catalog_screen.dart';
import 'view/rewards_history_screen.dart';
import 'view/reward_products_screen.dart';
import 'view/scanner_screen.dart';
import 'view/settings_screen.dart';
import 'view/user_profile_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/account': (context) => const AccountScreen(),
  '/changePassword': (context) => const ChangePasswordScreen(),
  '/contactFAQ': (context) => const ContactFAQScreen(),
  '/dashboard': (context) => const DashboardScreen(),
  '/editProfile': (context) => const EditProfileScreen(),
  '/kycRequest': (context) => const KYCRequestScreen(),
  '/login': (context) => const LoginScreen(),
  '/myRewards': (context) => MyRewardsScreen(),
  '/qrScanner': (context) => const QRScannerScreen(),
  '/register': (context) => const RegisterScreen(),
  '/rewardsCatalog': (context) => const RewardsCatalogScreen(),
  '/rewardsHistory': (context) => const RewardsHistoryScreen(),
  '/rewardProducts': (context) => const RewardProductsScreen(),
  '/scanner': (context) => const ScannerScreen(),
  '/settings': (context) => const SettingsScreen(),
  '/userProfile': (context) => const UserProfileScreen(),
};
