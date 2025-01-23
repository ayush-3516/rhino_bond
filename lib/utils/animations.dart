import 'package:flutter/material.dart';

class AppAnimations {
  // Page transitions
  static const Duration pageTransitionDuration = Duration(milliseconds: 250);
  static const Curve pageTransitionCurve = Curves.fastLinearToSlowEaseIn;

  // Button animations
  static const Duration buttonScaleDuration = Duration(milliseconds: 120);
  static const Curve buttonScaleCurve = Curves.easeOutBack;

  // List animations
  static const Duration listItemDuration = Duration(milliseconds: 180);
  static const Curve listItemCurve = Curves.easeOutQuad;

  // Loading animations
  static const Duration shimmerDuration = Duration(milliseconds: 800);
  static const Curve shimmerCurve = Curves.easeInOutCirc;

  // Hero animations
  static const Duration heroDuration = Duration(milliseconds: 280);
  static const Curve heroCurve = Curves.fastOutSlowIn;

  // Common animation configurations
  static Widget fadeTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: child,
    );
  }

  static Widget scaleTransition(Animation<double> animation, Widget child) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: child,
    );
  }

  static Widget slideTransition(Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 0.1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      )),
      child: child,
    );
  }

  static Widget fadeScaleTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      ),
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
        child: child,
      ),
    );
  }

  static Widget rotateTransition(Animation<double> animation, Widget child) {
    return RotationTransition(
      turns: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCirc,
      )),
      child: child,
    );
  }
}
