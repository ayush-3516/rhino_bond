import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'features/auth/view/dashboard_screen.dart';
import 'features/auth/view/reward_products_screen.dart';
import 'features/auth/view/qr_scanner_screen.dart';
import 'features/auth/view/account_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platform = Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android;

    return MaterialApp(
      title: 'Rhino Bond',
      theme: ThemeData(
        platform: platform,
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: platform == TargetPlatform.iOS ? CupertinoColors.systemBackground : Colors.white,
          foregroundColor: platform == TargetPlatform.iOS ? CupertinoColors.label : Colors.black,
          elevation: 0,
        ),
        // Use system font for iOS
        fontFamily: platform == TargetPlatform.iOS ? '.SF Pro Text' : null,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/rewards': (context) => const RewardProductsScreen(),
        '/scan': (context) => const QRScannerScreen(),
        '/account': (context) => const AccountScreen(),
      },
    );
  }
}
