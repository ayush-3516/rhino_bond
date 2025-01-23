import 'package:flutter/material.dart';
import 'package:rhino_bond/utils/animations.dart';
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
import 'package:rhino_bond/screens/complete_profile_screen.dart';

class CustomPageTransitions {
  static Route createRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      transitionDuration: AppAnimations.pageTransitionDuration,
      reverseTransitionDuration: AppAnimations.pageTransitionDuration,
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final isPop = (secondaryAnimation.status == AnimationStatus.forward);

        // Use different transitions based on route hierarchy
        if (settings.name == '/') {
          return AppAnimations.fadeScaleTransition(animation, child);
        }

        // Use shared axis transitions for related routes
        if (settings.name?.startsWith('/home') ?? false) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        }

        // Default to slide transition with direction based on navigation
        return SlideTransition(
          position: Tween<Offset>(
            begin: isPop ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AppAnimations.pageTransitionCurve,
          )),
          child: child,
        );
      },
    );
  }
}

class SharedAxisTransition extends AnimatedWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final SharedAxisTransitionType transitionType;
  final Widget child;

  const SharedAxisTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.transitionType,
    required this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(
      parent: animation,
      curve: AppAnimations.pageTransitionCurve,
    );

    switch (transitionType) {
      case SharedAxisTransitionType.horizontal:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curve),
          child: child,
        );
      case SharedAxisTransitionType.vertical:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curve),
          child: child,
        );
      case SharedAxisTransitionType.scaled:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curve),
          child: child,
        );
    }
  }
}

enum SharedAxisTransitionType {
  horizontal,
  vertical,
  scaled,
}

final Map<String, Widget Function(BuildContext)> routes = {
  '/complete_profile': (context) =>
      const AuthWrapper(child: CompleteProfileScreen()),
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

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  final builder = routes[settings.name];
  if (builder != null) {
    return CustomPageTransitions.createRoute(
      Builder(
        builder: (context) => builder(context),
      ),
      settings,
    );
  }
  return null;
}
