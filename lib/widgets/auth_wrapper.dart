import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/authentication.notifier.dart';

/// A wrapper widget that conditionally displays either the authenticated child widget or the authentication view.
class AuthWrapper extends StatefulWidget {
  /// The child widget to display if the user is authenticated.
  final Widget child;

  /// Creates an instance of [AuthWrapper].
  const AuthWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);

      if (!authNotifier.isAuthenticated) {
        Navigator.pushNamed(context, '/send_otp');
      } else if (!authNotifier.isPhoneNumberVerified) {
        Navigator.pushNamed(context, '/verify_otp');
      } else {
        print('User is authenticated, fetching profile...');
        try {
          await authNotifier.fetchCurrentUserProfile();
          print('User profile fetched successfully');
        } catch (e) {
          print('Error fetching user profile: $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthenticationNotifier>(context);

    if (authNotifier.isAuthenticated && authNotifier.isPhoneNumberVerified) {
      return widget.child;
    }

    return const Center(child: CircularProgressIndicator());
  }
}
