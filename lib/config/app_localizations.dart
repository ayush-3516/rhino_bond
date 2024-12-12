import 'package:flutter/material.dart';
import 'localizations/en.dart' as en;
import 'localizations/gu.dart' as gu;
import 'localizations/hi.dart' as hi;
import 'localizations/mr.dart' as mr;
import 'localizations/pa.dart' as pa;

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': en.en,
    'gu': gu.gu,
    'hi': hi.hi,
    'mr': mr.mr,
    'pa': pa.pa,
  };

  // Getters for translations
  String? get appTitle => _localizedValues[locale.languageCode]?['appTitle'];
  String? get welcome => _localizedValues[locale.languageCode]?['welcome'];
  String? get welcomeBack =>
      _localizedValues[locale.languageCode]?['welcomeBack'];
  String? get signInToContinue =>
      _localizedValues[locale.languageCode]?['signInToContinue'];
  String? get loading => _localizedValues[locale.languageCode]?['loading'];

  // Auth & Profile getters
  String? get login => _localizedValues[locale.languageCode]?['login'];
  String? get register => _localizedValues[locale.languageCode]?['register'];
  String? get phoneNumber =>
      _localizedValues[locale.languageCode]?['phoneNumber'];
  String? get email => _localizedValues[locale.languageCode]?['email'];
  String? get password => _localizedValues[locale.languageCode]?['password'];
  String? get currentPassword =>
      _localizedValues[locale.languageCode]?['currentPassword'];
  String? get newPassword =>
      _localizedValues[locale.languageCode]?['newPassword'];
  String? get confirmPassword =>
      _localizedValues[locale.languageCode]?['confirmPassword'];
  String? get fullName => _localizedValues[locale.languageCode]?['fullName'];
  String? get address => _localizedValues[locale.languageCode]?['address'];
  String? get pincode => _localizedValues[locale.languageCode]?['pincode'];
  String? get state => _localizedValues[locale.languageCode]?['state'];
  String? get enterOtp => _localizedValues[locale.languageCode]?['enterOtp'];
  String? get sendOtp => _localizedValues[locale.languageCode]?['sendOtp'];
  String? get verifyOtp => _localizedValues[locale.languageCode]?['verifyOtp'];
  String? get otpSentSuccessfully =>
      _localizedValues[locale.languageCode]?['otpSentSuccessfully'];
  String? get pleaseEnterPhoneNumber =>
      _localizedValues[locale.languageCode]?['pleaseEnterPhoneNumber'];
  String? get pleaseEnterOtp =>
      _localizedValues[locale.languageCode]?['pleaseEnterOtp'];
  String? get invalidOtp =>
      _localizedValues[locale.languageCode]?['invalidOtp'];
  String? get loginSuccessful =>
      _localizedValues[locale.languageCode]?['loginSuccessful'];

  // Validation Messages
  String? get pleaseEnterName =>
      _localizedValues[locale.languageCode]?['pleaseEnterName'];
  String? get pleaseEnterEmail =>
      _localizedValues[locale.languageCode]?['pleaseEnterEmail'];
  String? get pleaseEnterValidEmail =>
      _localizedValues[locale.languageCode]?['pleaseEnterValidEmail'];
  String? get pleaseEnterPhone =>
      _localizedValues[locale.languageCode]?['pleaseEnterPhone'];
  String? get pleaseEnterPassword =>
      _localizedValues[locale.languageCode]?['pleaseEnterPassword'];
  String? get pleaseEnterCurrentPassword =>
      _localizedValues[locale.languageCode]?['pleaseEnterCurrentPassword'];
  String? get pleaseEnterNewPassword =>
      _localizedValues[locale.languageCode]?['pleaseEnterNewPassword'];
  String? get pleaseConfirmPassword =>
      _localizedValues[locale.languageCode]?['pleaseConfirmPassword'];
  String? get passwordsDoNotMatch =>
      _localizedValues[locale.languageCode]?['passwordsDoNotMatch'];
  String? get passwordMinLength =>
      _localizedValues[locale.languageCode]?['passwordMinLength'];
  String? get pincodeMustBe6Digits =>
      _localizedValues[locale.languageCode]?['pincodeMustBe6Digits'];
  String? get phoneMustBe10Digits =>
      _localizedValues[locale.languageCode]?['phoneMustBe10Digits'];
  String? get pleaseEnterAddress =>
      _localizedValues[locale.languageCode]?['pleaseEnterAddress'];
  String? get pleaseEnterPincode =>
      _localizedValues[locale.languageCode]?['pleaseEnterPincode'];
  String? get pleaseEnterState =>
      _localizedValues[locale.languageCode]?['pleaseEnterState'];

  // Settings getters
  String? get settings => _localizedValues[locale.languageCode]?['settings'];
  String? get profileSettings =>
      _localizedValues[locale.languageCode]?['profileSettings'];
  String? get appSettings =>
      _localizedValues[locale.languageCode]?['appSettings'];
  String? get security => _localizedValues[locale.languageCode]?['security'];
  String? get changePassword =>
      _localizedValues[locale.languageCode]?['changePassword'];
  String? get editProfile =>
      _localizedValues[locale.languageCode]?['editProfile'];
  String? get darkMode => _localizedValues[locale.languageCode]?['darkMode'];
  String? get pushNotifications =>
      _localizedValues[locale.languageCode]?['pushNotifications'];
  String? get notificationsSubtitle =>
      _localizedValues[locale.languageCode]?['notificationsSubtitle'];
  String? get language => _localizedValues[locale.languageCode]?['language'];
  String? get biometricAuth =>
      _localizedValues[locale.languageCode]?['biometricAuth'];
  String? get biometricAuthSubtitle =>
      _localizedValues[locale.languageCode]?['biometricAuthSubtitle'];
  String? get privacyPolicy =>
      _localizedValues[locale.languageCode]?['privacyPolicy'];
  String? get termsOfService =>
      _localizedValues[locale.languageCode]?['termsOfService'];
  String? get about => _localizedValues[locale.languageCode]?['about'];
  String? get appVersion =>
      _localizedValues[locale.languageCode]?['appVersion'];
  String? get checkForUpdates =>
      _localizedValues[locale.languageCode]?['checkForUpdates'];
  String? get deleteAccount =>
      _localizedValues[locale.languageCode]?['deleteAccount'];
  String? get deleteAccountSubtitle =>
      _localizedValues[locale.languageCode]?['deleteAccountSubtitle'];
  String? get cancel => _localizedValues[locale.languageCode]?['cancel'];
  String? get delete => _localizedValues[locale.languageCode]?['delete'];

  // Account getters
  String? get myAccount => _localizedValues[locale.languageCode]?['myAccount'];
  String? get saveProfile =>
      _localizedValues[locale.languageCode]?['saveProfile'];
  String? get saveChanges =>
      _localizedValues[locale.languageCode]?['saveChanges'];
  String? get profileUpdated =>
      _localizedValues[locale.languageCode]?['profileUpdated'];
  String? get passwordChanged =>
      _localizedValues[locale.languageCode]?['passwordChanged'];

  // Rewards getters
  String? get points => _localizedValues[locale.languageCode]?['points'];
  String? get pointsRequired =>
      _localizedValues[locale.languageCode]?['pointsRequired'];
  String? get redeemNow => _localizedValues[locale.languageCode]?['redeemNow'];
  String? get confirmRedemption =>
      _localizedValues[locale.languageCode]?['confirmRedemption'];
  String? get confirm => _localizedValues[locale.languageCode]?['confirm'];

  // Error getters
  String? get fillAllFields =>
      _localizedValues[locale.languageCode]?['fillAllFields'];

  // Missing getters
  String? get pleaseFillInAllFields =>
      _localizedValues[locale.languageCode]?['pleaseFillInAllFields'];
  String? get resendOtp => _localizedValues[locale.languageCode]?['resendOtp'];
  String? get dontHaveAnAccount =>
      _localizedValues[locale.languageCode]?['dontHaveAnAccount'];

  // Parameterized translations
  String? redeemConfirmMessage(String title, int points) {
    String? message =
        _localizedValues[locale.languageCode]?['redeemConfirmMessage'];
    return message
        ?.replaceAll('{title}', title)
        .replaceAll('{points}', points.toString());
  }

  String? successfullyRedeemed(String title) {
    String? message =
        _localizedValues[locale.languageCode]?['successfullyRedeemed'];
    return message?.replaceAll('{title}', title);
  }

  String? loginFailed(String error) {
    String? message = _localizedValues[locale.languageCode]?['loginFailed'];
    return message?.replaceAll('{error}', error);
  }

  String? registrationFailed(String error) {
    String? message =
        _localizedValues[locale.languageCode]?['registrationFailed'];
    return message?.replaceAll('{error}', error);
  }

  String? errorOccurred(String error) {
    String? message = _localizedValues[locale.languageCode]?['errorOccurred'];
    return message?.replaceAll('{error}', error);
  }

  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('gu', ''), // Gujarati
    Locale('hi', ''), // Hindi
    Locale('mr', ''), // Marathi
    Locale('pa', ''), // Punjabi
  ];
}
