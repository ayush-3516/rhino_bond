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
  AuthenticationNotifier? _authNotifier;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);

      if (!_authNotifier!.isAuthenticated) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/send_otp', (route) => false);
      } else if (!_authNotifier!.isPhoneNumberVerified) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/verify_otp', (route) => false);
      } else {
        print('User is authenticated, fetching profile...');
        try {
          await _authNotifier!.fetchCurrentUserProfile();
          print('User profile fetched successfully');
        } catch (e) {
          print('Error fetching user profile: $e');
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authNotifier = Provider.of<AuthenticationNotifier>(context);
    _authNotifier?.addListener(_handleAuthChange);
  }

  void _handleAuthChange() {
    if (_authNotifier != null && !_authNotifier!.isAuthenticated) {
      Navigator.pushNamedAndRemoveUntil(context, '/send_otp', (route) => false);
    }
  }

  @override
  void dispose() {
    _authNotifier?.removeListener(_handleAuthChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthenticationNotifier>(context);

    if (authNotifier.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!authNotifier.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/send_otp', (route) => false);
      });
      return const Center(child: CircularProgressIndicator());
    }

    if (!authNotifier.isPhoneNumberVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/verify_otp', (route) => false);
      });
      return const Center(child: CircularProgressIndicator());
    }

    return widget.child;
  }
}
