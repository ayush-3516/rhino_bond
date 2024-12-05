import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'features/auth/view/dashboard_screen.dart';
import 'features/auth/view/reward_products_screen.dart';
import 'features/auth/view/qr_scanner_screen.dart';
import 'features/auth/view/account_screen.dart';
import 'features/auth/view/edit_profile_screen.dart';
import 'features/auth/view/change_password_screen.dart';
import 'theme/theme_provider.dart';
import 'theme/app_theme.dart';
import 'package:rhino_bond/providers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platform = Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Rhino Bond',
      theme: AppTheme.lightTheme.copyWith(platform: platform),
      darkTheme: AppTheme.darkTheme.copyWith(platform: platform),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/rewards': (context) => const RewardProductsScreen(),
        '/scan': (context) => const QRScannerScreen(),
        '/account': (context) => const AccountScreen(),
        '/editProfile': (context) => EditProfileScreen(),
        '/changePassword': (context) => ChangePasswordScreen(),
      },
    );
  }
}
