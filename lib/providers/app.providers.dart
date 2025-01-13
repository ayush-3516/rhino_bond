import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rhino_bond/notifiers/authentication.notifier.dart';
import 'package:rhino_bond/notifiers/redemption_notifier.dart';
import 'package:rhino_bond/services/authentication.services.dart';
import 'package:rhino_bond/widgets/providers/user_provider.dart';
import 'package:rhino_bond/providers/theme_provider.dart';

/// Factory function to create an instance of [AuthenticationNotifier] with its dependencies.
AuthenticationNotifier createAuthenticationNotifier(
    AuthenticationService authService, UserProvider userProvider) {
  return AuthenticationNotifier(authService, userProvider);
}

/// Sets up the providers for the application.
class AppProviders {
  /// List of providers used in the application.
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ChangeNotifierProvider(create: (context) => RedemptionNotifier()),
    Provider<AuthenticationService>(
      create: (context) => AuthenticationService(),
    ),
    ChangeNotifierProxyProvider<UserProvider, AuthenticationNotifier>(
      create: (context) => createAuthenticationNotifier(
        context.read<AuthenticationService>(),
        context.read<UserProvider>(),
      ),
      update: (context, userProvider, authNotifier) => authNotifier!,
    ),
  ];
}
