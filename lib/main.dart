import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/features/auth/view/dashboard_screen.dart';
import 'package:rhino_bond/features/auth/view/reward_products_screen.dart';
import 'package:rhino_bond/features/auth/view/qr_scanner_screen.dart';
import 'package:rhino_bond/features/auth/view/account_screen.dart';
import 'package:rhino_bond/features/auth/view/edit_profile_screen.dart';
import 'package:rhino_bond/features/auth/view/change_password_screen.dart';
import 'package:rhino_bond/features/auth/view/register_screen.dart'; // Import RegisterScreen
import 'package:rhino_bond/features/auth/view/login_screen.dart'; // Import LoginScreen
import 'package:rhino_bond/theme/theme_provider.dart';
import 'package:rhino_bond/theme/app_theme.dart';
import 'package:rhino_bond/providers/user_provider.dart';
import 'package:rhino_bond/providers/language_provider.dart';
import 'package:rhino_bond/config/app_localizations_delegate.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          title: 'Rhino Bond',
          theme: themeProvider.isDarkMode
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
          locale: languageProvider.currentLocale,
          supportedLocales: const [
            Locale('en'),
            Locale('gu'),
            Locale('hi'),
            Locale('mr'),
            Locale('pa'),
          ],
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: '/',
          routes: {
            '/': (context) => const DashboardScreen(),
            '/dashboard': (context) =>
                const DashboardScreen(), // Add "/dashboard" route
            '/rewards': (context) => const RewardProductsScreen(),
            '/scan': (context) => const QRScannerScreen(),
            '/account': (context) => const AccountScreen(),
            '/editProfile': (context) => const EditProfileScreen(),
            '/changePassword': (context) => const ChangePasswordScreen(),
            '/register': (context) =>
                const RegisterScreen(), // Add RegisterScreen route
            '/login': (context) => const LoginScreen(), // Add LoginScreen route
          },
        );
      },
    );
  }
}
