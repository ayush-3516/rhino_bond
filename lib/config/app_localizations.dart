import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // General
      'appTitle': 'Rhino Bond',
      'welcome': 'Welcome',
      'welcomeBack': 'Welcome Back',
      'signInToContinue': 'Sign in to continue',
      'loading': 'Loading...',

      // Auth & Profile
      'login': 'Login',
      'register': 'Register',
      'phoneNumber': 'Phone Number',
      'email': 'Email',
      'password': 'Password',
      'currentPassword': 'Current Password',
      'newPassword': 'New Password',
      'confirmPassword': 'Confirm New Password',
      'fullName': 'Full Name',
      'address': 'Address',
      'pincode': 'Pincode',
      'state': 'State',
      'enterOtp': 'Enter OTP',
      'sendOtp': 'Send OTP',
      'verifyOtp': 'Verify OTP',
      'otpSentSuccessfully': 'OTP sent successfully!',
      'pleaseEnterPhoneNumber': 'Please enter your phone number',
      'pleaseEnterOtp': 'Please enter the OTP',
      'invalidOtp': 'Invalid OTP',
      'loginSuccessful': 'Login successful!',

      // Validation Messages
      'pleaseEnterName': 'Please enter your name',
      'pleaseEnterEmail': 'Please enter your email',
      'pleaseEnterValidEmail': 'Please enter a valid email',
      'pleaseEnterPhone': 'Please enter your phone number',
      'pleaseEnterPassword': 'Please enter your password',
      'pleaseEnterCurrentPassword': 'Please enter your current password',
      'pleaseEnterNewPassword': 'Please enter a new password',
      'pleaseConfirmPassword': 'Please confirm your new password',
      'passwordsDoNotMatch': 'Passwords do not match',
      'passwordMinLength': 'Password must be at least 6 characters long',
      'pincodeMustBe6Digits': 'Pincode must be 6 digits',
      'phoneMustBe10Digits': 'Phone number must be 10 digits',

      // Settings
      'settings': 'Settings',
      'profileSettings': 'Profile Settings',
      'appSettings': 'App Settings',
      'security': 'Security',
      'changePassword': 'Change Password',
      'editProfile': 'Edit Profile',
      'darkMode': 'Dark Mode',
      'pushNotifications': 'Push Notifications',
      'notificationsSubtitle': 'Receive notifications about rewards and updates',
      'language': 'Language',
      'biometricAuth': 'Biometric Authentication',
      'biometricAuthSubtitle': 'Use fingerprint or face ID to login',
      'privacyPolicy': 'Privacy Policy',
      'termsOfService': 'Terms of Service',
      'about': 'About',
      'appVersion': 'App Version',
      'checkForUpdates': 'Check for Updates',
      'deleteAccount': 'Delete Account',
      'deleteAccountSubtitle': 'Permanently delete your account and all data',
      'cancel': 'Cancel',
      'delete': 'Delete',

      // Account
      'myAccount': 'My Account',
      'saveProfile': 'Save Profile',
      'saveChanges': 'Save Changes',
      'profileUpdated': 'Profile updated successfully',
      'passwordChanged': 'Password changed successfully',

      // Rewards
      'points': 'points',
      'pointsRequired': 'points required',
      'redeemNow': 'Redeem Now',
      'confirmRedemption': 'Confirm Redemption',
      'redeemConfirmMessage': 'Are you sure you want to redeem {title} for {points} points?',
      'confirm': 'Confirm',
      'successfullyRedeemed': 'Successfully redeemed {title}!',

      // Error Messages
      'loginFailed': 'Login failed: {error}',
      'registrationFailed': 'Registration failed: {error}',
      'errorOccurred': 'Error: {error}',
      'fillAllFields': 'Please fill in all fields',
    },
    'gu': {
      // General
      'appTitle': 'રાઇનો બોન્ડ',
      'welcome': 'સ્વાગત છે',
      'welcomeBack': 'પુનઃ સ્વાગત છે',
      'signInToContinue': 'ચાલુ રાખવા માટે સાઇન ઇન કરો',
      'loading': 'લોડ થઈ રહ્યું છે...',

      // Auth & Profile
      'login': 'લૉગિન',
      'register': 'નોંધણી કરો',
      'phoneNumber': 'ફોન નંબર',
      'email': 'ઈમેલ',
      'password': 'પાસવર્ડ',
      'currentPassword': 'વર્તમાન પાસવર્ડ',
      'newPassword': 'નવો પાસવર્ડ',
      'confirmPassword': 'નવો પાસવર્ડ કન્ફર્મ કરો',
      'fullName': 'પૂરું નામ',
      'address': 'સરનામું',
      'pincode': 'પિનકોડ',
      'state': 'રાજ્ય',
      'enterOtp': 'ઓટીપી દાખલ કરો',
      'sendOtp': 'ઓટીપી મોકલો',
      'verifyOtp': 'ઓટીપી ચેક કરો',
      'otpSentSuccessfully': 'ઓટીપી સફળતાપૂર્વક મોકલવામાં આવ્યો!',
      'pleaseEnterPhoneNumber': 'કૃપા કરી તમારો ફોન નંબર દાખલ કરો',
      'pleaseEnterOtp': 'કૃપા કરી ઓટીપી દાખલ કરો',
      'invalidOtp': 'અમાન્ય ઓટીપી',
      'loginSuccessful': 'લૉગિન સફળતાપૂર્વક થયું!',

      // Validation Messages
      'pleaseEnterName': 'કૃપા કરી તમારું નામ દાખલ કરો',
      'pleaseEnterEmail': 'કૃપા કરી તમારો ઈમેલ દાખલ કરો',
      'pleaseEnterValidEmail': 'કૃપા કરી માન્ય ઈમેલ દાખલ કરો',
      'pleaseEnterPhone': 'કૃપા કરી તમારો ફોન નંબર દાખલ કરો',
      'pleaseEnterPassword': 'કૃપા કરી તમારો પાસવર્ડ દાખલ કરો',
      'pleaseEnterCurrentPassword': 'કૃપા કરી તમારો વર્તમાન પાસવર્ડ દાખલ કરો',
      'pleaseEnterNewPassword': 'કૃપા કરી નવો પાસવર્ડ દાખલ કરો',
      'pleaseConfirmPassword': 'કૃપા કરી તમારો નવો પાસવર્ડ કન્ફર્મ કરો',
      'passwordsDoNotMatch': 'પાસવર્ડ મેળ ખાતા નથી',
      'passwordMinLength': 'પાસવર્ડ ઓછામાં ઓછા 6 અક્ષરનો હોવો જોઈએ',
      'pincodeMustBe6Digits': 'પિનકોડ 6 અંકનો હોવો જોઈએ',
      'phoneMustBe10Digits': 'ફોન નંબર 10 અંકનો હોવો જોઈએ',

      // Settings
      'settings': 'સેટિંગ્સ',
      'profileSettings': 'પ્રોફાઇલ સેટિંગ્સ',
      'appSettings': 'એપ સેટિંગ્સ',
      'security': 'સુરક્ષા',
      'changePassword': 'પાસવર્ડ બદલો',
      'editProfile': 'પ્રોફાઇલ સંપાદિત કરો',
      'darkMode': 'ડાર્ક મોડ',
      'pushNotifications': 'પુશ નોટિફિકેશન',
      'notificationsSubtitle': 'રિવોર્ડ્સ અને અપડેટ્સ વિશે નોટિફિકેશન મેળવો',
      'language': 'ભાષા',
      'biometricAuth': 'બાયોમેટ્રિક પ્રમાણીકરણ',
      'biometricAuthSubtitle': 'લૉગિન માટે ફિંગરપ્રિન્ટ અથવા ફેસ આઈડી વાપરો',
      'privacyPolicy': 'ગોપનીયતા નીતિ',
      'termsOfService': 'સેવાની શરતો',
      'about': 'વિશે',
      'appVersion': 'એપ્લિકેશન વર્ઝન',
      'checkForUpdates': 'અપડેટ્સ તપાસો',
      'deleteAccount': 'એકાઉન્ટ કાઢી નાખો',
      'deleteAccountSubtitle': 'તમારું એકાઉન્ટ અને બધો ડેટા કાયમી રીતે કાઢી નાખો',
      'cancel': 'રદ કરો',
      'delete': 'કાઢી નાખો',

      // Account
      'myAccount': 'મારું એકાઉન્ટ',
      'saveProfile': 'પ્રોફાઇલ સાચવો',
      'saveChanges': 'ફેરફારો સાચવો',
      'profileUpdated': 'પ્રોફાઇલ સફળતાપૂર્વક અપડેટ થયું',
      'passwordChanged': 'પાસવર્ડ સફળતાપૂર્વક બદલાયો',

      // Rewards
      'points': 'પોઈન્ટ્સ',
      'pointsRequired': 'પોઈન્ટ્સ જરૂરી',
      'redeemNow': 'હવે રિડીમ કરો',
      'confirmRedemption': 'રિડેમ્પશનની પુષ્ટિ કરો',
      'redeemConfirmMessage': 'શું તમે ખરેખર {points} પોઈન્ટ્સ માટે {title} રિડીમ કરવા માંગો છો?',
      'confirm': 'પુષ્ટિ કરો',
      'successfullyRedeemed': '{title} સફળતાપૂર્વક રિડીમ થયું!',

      // Error Messages
      'loginFailed': 'લૉગિન નિષ્ફળ: {error}',
      'registrationFailed': 'નોંધણી નિષ્ફળ: {error}',
      'errorOccurred': 'ભૂલ: {error}',
      'fillAllFields': 'કૃપા કરી બધા ક્ષેત્રો ભરો',
    },
    'hi': {
      // General
      'appTitle': 'राइनो बॉन्ड',
      'welcome': 'स्वागत है',
      'welcomeBack': 'पुनः स्वागत है',
      'signInToContinue': 'जारी रखने के लिए साइन इन करें',
      'loading': 'लोड हो रहा है...',

      // Auth & Profile
      'login': 'लॉगिन',
      'register': 'पंजीकरण',
      'phoneNumber': 'फोन नंबर',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'currentPassword': 'वर्तमान पासवर्ड',
      'newPassword': 'नया पासवर्ड',
      'confirmPassword': 'नया पासवर्ड पुष्टि करें',
      'fullName': 'पूरा नाम',
      'address': 'पता',
      'pincode': 'पिनकोड',
      'state': 'राज्य',
      'enterOtp': 'ओटीपी दर्ज करें',
      'sendOtp': 'ओटीपी भेजें',
      'verifyOtp': 'ओटीपी सत्यापित करें',
      'otpSentSuccessfully': 'ओटीपी सफलतापूर्वक भेजा गया!',
      'pleaseEnterPhoneNumber': 'कृपया अपना फोन नंबर दर्ज करें',
      'pleaseEnterOtp': 'कृपया ओटीपी दर्ज करें',
      'invalidOtp': 'अमान्य ओटीपी',
      'loginSuccessful': 'लॉगिन सफलतापूर्वक हुआ!',

      // Validation Messages
      'pleaseEnterName': 'कृपया अपना नाम दर्ज करें',
      'pleaseEnterEmail': 'कृपया अपना ईमेल दर्ज करें',
      'pleaseEnterValidEmail': 'कृपया मान्य ईमेल दर्ज करें',
      'pleaseEnterPhone': 'कृपया अपना फोन नंबर दर्ज करें',
      'pleaseEnterPassword': 'कृपया अपना पासवर्ड दर्ज करें',
      'pleaseEnterCurrentPassword': 'कृपया अपना वर्तमान पासवर्ड दर्ज करें',
      'pleaseEnterNewPassword': 'कृपया नया पासवर्ड दर्ज करें',
      'pleaseConfirmPassword': 'कृपया अपने नए पासवर्ड की पुष्टि करें',
      'passwordsDoNotMatch': 'पासवर्ड मेल नहीं खाते',
      'passwordMinLength': 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए',
      'pincodeMustBe6Digits': 'पिनकोड 6 अंकों का होना चाहिए',
      'phoneMustBe10Digits': 'फोन नंबर 10 अंकों का होना चाहिए',

      // Settings
      'settings': 'सेटिंग्स',
      'profileSettings': 'प्रोफाइल सेटिंग्स',
      'appSettings': 'ऐप सेटिंग्स',
      'security': 'सुरक्षा',
      'changePassword': 'पासवर्ड बदलें',
      'editProfile': 'प्रोफाइल संपादित करें',
      'darkMode': 'डार्क मोड',
      'pushNotifications': 'पुश नोटिफिकेशन',
      'notificationsSubtitle': 'रिवॉर्ड्स और अपडेट्स के बारे में नोटिफिकेशन प्राप्त करें',
      'language': 'भाषा',
      'biometricAuth': 'बायोमेट्रिक प्रमाणीकरण',
      'biometricAuthSubtitle': 'लॉगिन के लिए फिंगरप्रिंट या फेस आईडी का उपयोग करें',
      'privacyPolicy': 'गोपनीयता नीति',
      'termsOfService': 'सेवा की शर्तें',
      'about': 'के बारे में',
      'appVersion': 'ऐप वर्जन',
      'checkForUpdates': 'अपडेट के लिए जाँच करें',
      'deleteAccount': 'खाता हटाएं',
      'deleteAccountSubtitle': 'अपना खाता और सभी डेटा स्थायी रूप से हटाएं',
      'cancel': 'रद्द करें',
      'delete': 'हटाएं',

      // Account
      'myAccount': 'मेरा खाता',
      'saveProfile': 'प्रोफाइल सहेजें',
      'saveChanges': 'परिवर्तन सहेजें',
      'profileUpdated': 'प्रोफाइल सफलतापूर्वक अपडेट किया गया',
      'passwordChanged': 'पासवर्ड सफलतापूर्वक बदल दिया गया',

      // Rewards
      'points': 'पॉइंट्स',
      'pointsRequired': 'आवश्यक पॉइंट्स',
      'redeemNow': 'अभी रिडीम करें',
      'confirmRedemption': 'रिडेम्पशन की पुष्टि करें',
      'redeemConfirmMessage': 'क्या आप वाकई {points} पॉइंट्स के लिए {title} रिडीम करना चाहते हैं?',
      'confirm': 'पुष्टि करें',
      'successfullyRedeemed': '{title} सफलतापूर्वक रिडीम किया गया!',

      // Error Messages
      'loginFailed': 'लॉगिन विफल: {error}',
      'registrationFailed': 'पंजीकरण विफल: {error}',
      'errorOccurred': 'त्रुटि: {error}',
      'fillAllFields': 'कृपया सभी फ़ील्ड भरें',
    },
    'mr': {
      // General
      'appTitle': 'रायनो बाँड',
      'welcome': 'स्वागत आहे',
      'welcomeBack': 'पुन्हा स्वागत आहे',
      'signInToContinue': 'सुरू ठेवण्यासाठी साइन इन करा',
      'loading': 'लोड होत आहे...',

      // Auth & Profile
      'login': 'लॉगिन',
      'register': 'नोंदणी करा',
      'phoneNumber': 'फोन नंबर',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'currentPassword': 'सध्याचा पासवर्ड',
      'newPassword': 'नवीन पासवर्ड',
      'confirmPassword': 'नवीन पासवर्ड पुष्टी करा',
      'fullName': 'पूर्ण नाव',
      'address': 'पत्ता',
      'pincode': 'पिनकोड',
      'state': 'राज्य',
      'enterOtp': 'ओटीपी प्रविष्ट करा',
      'sendOtp': 'ओटीपी पाठवा',
      'verifyOtp': 'ओटीपी तपासा',
      'otpSentSuccessfully': 'ओटीपी यशस्वीरित्या पाठवला गेला!',
      'pleaseEnterPhoneNumber': 'कृपया आपला फोन नंबर प्रविष्ट करा',
      'pleaseEnterOtp': 'कृपया ओटीपी प्रविष्ट करा',
      'invalidOtp': 'अमान्य ओटीपी',
      'loginSuccessful': 'लॉगिन यशस्वीरित्या झाले!',

      // Validation Messages
      'pleaseEnterName': 'कृपया आपले नाव प्रविष्ट करा',
      'pleaseEnterEmail': 'कृपया आपला ईमेल प्रविष्ट करा',
      'pleaseEnterValidEmail': 'कृपया वैध ईमेल प्रविष्ट करा',
      'pleaseEnterPhone': 'कृपया आपला फोन नंबर प्रविष्ट करा',
      'pleaseEnterPassword': 'कृपया आपला पासवर्ड प्रविष्ट करा',
      'pleaseEnterCurrentPassword': 'कृपया आपला सध्याचा पासवर्ड प्रविष्ट करा',
      'pleaseEnterNewPassword': 'कृपया नवीन पासवर्ड प्रविष्ट करा',
      'pleaseConfirmPassword': 'कृपया आपल्या नवीन पासवर्डची पुष्टी करा',
      'passwordsDoNotMatch': 'पासवर्ड जुळत नाहीत',
      'passwordMinLength': 'पासवर्ड किमान 6 अक्षरांचा असावा',
      'pincodeMustBe6Digits': 'पिनकोड 6 अंकी असावा',
      'phoneMustBe10Digits': 'फोन नंबर 10 अंकी असावा',

      // Settings
      'settings': 'सेटिंग्ज',
      'profileSettings': 'प्रोफाइल सेटिंग्ज',
      'appSettings': 'अॅप सेटिंग्ज',
      'security': 'सुरक्षा',
      'changePassword': 'पासवर्ड बदला',
      'editProfile': 'प्रोफाइल संपादित करा',
      'darkMode': 'डार्क मोड',
      'pushNotifications': 'पुश नोटिफिकेशन्स',
      'notificationsSubtitle': 'रिवॉर्ड्स आणि अपडेट्सबद्दल नोटिफिकेशन्स मिळवा',
      'language': 'भाषा',
      'biometricAuth': 'बायोमेट्रिक प्रमाणीकरण',
      'biometricAuthSubtitle': 'लॉगिनसाठी फिंगरप्रिंट किंवा फेस आयडी वापरा',
      'privacyPolicy': 'गोपनीयता धोरण',
      'termsOfService': 'सेवेच्या अटी',
      'about': 'बद्दल',
      'appVersion': 'अॅप आवृत्ती',
      'checkForUpdates': 'अपडेट्स तपासा',
      'deleteAccount': 'खाते हटवा',
      'deleteAccountSubtitle': 'तुमचे खाते आणि सर्व डेटा कायमचा हटवा',
      'cancel': 'रद्द करा',
      'delete': 'हटवा',

      // Account
      'myAccount': 'माझे खाते',
      'saveProfile': 'प्रोफाइल जतन करा',
      'saveChanges': 'बदल जतन करा',
      'profileUpdated': 'प्रोफाइल यशस्वीरित्या अपडेट केले',
      'passwordChanged': 'पासवर्ड यशस्वीरित्या बदलला',

      // Rewards
      'points': 'पॉइंट्स',
      'pointsRequired': 'आवश्यक पॉइंट्स',
      'redeemNow': 'आता रिडीम करा',
      'confirmRedemption': 'रिडेम्पशनची पुष्टी करा',
      'redeemConfirmMessage': 'तुम्हाला खरोखर {points} पॉइंट्ससाठी {title} रिडीम करायचे आहे का?',
      'confirm': 'पुष्टी करा',
      'successfullyRedeemed': '{title} यशस्वीरित्या रिडीम केले!',

      // Error Messages
      'loginFailed': 'लॉगिन अयशस्वी: {error}',
      'registrationFailed': 'नोंदणी अयशस्वी: {error}',
      'errorOccurred': 'त्रुटी: {error}',
      'fillAllFields': 'कृपया सर्व फील्ड भरा',
    },
    'pa': {
      // General
      'appTitle': 'ਰਾਈਨੋ ਬਾਂਡ',
      'welcome': 'ਜੀ ਆਇਆਂ ਨੂੰ',
      'welcomeBack': 'ਵਾਪਸ ਆਉਣ ਤੇ ਜੀ ਆਇਆਂ ਨੂੰ',
      'signInToContinue': 'ਜਾਰੀ ਰੱਖਣ ਲਈ ਸਾਈਨ ਇਨ ਕਰੋ',
      'loading': 'ਲੋਡ ਹੋ ਰਿਹਾ ਹੈ...',

      // Auth & Profile
      'login': 'ਲੌਗਿਨ',
      'register': 'ਰਜਿਸਟਰ',
      'phoneNumber': 'ਫ਼ੋਨ ਨੰਬਰ',
      'email': 'ਈਮੇਲ',
      'password': 'ਪਾਸਵਰਡ',
      'currentPassword': 'ਮੌਜੂਦਾ ਪਾਸਵਰਡ',
      'newPassword': 'ਨਵਾਂ ਪਾਸਵਰਡ',
      'confirmPassword': 'ਨਵੇਂ ਪਾਸਵਰਡ ਦੀ ਪੁਸ਼ਟੀ ਕਰੋ',
      'fullName': 'ਪੂਰਾ ਨਾਮ',
      'address': 'ਪਤਾ',
      'pincode': 'ਪਿੰਨ ਕੋਡ',
      'state': 'ਰਾਜ',
      'enterOtp': 'ਓਟੀਪੀ ਦਾਖਲ ਕਰੋ',
      'sendOtp': 'ਓਟੀਪੀ ਭੇਜੋ',
      'verifyOtp': 'ਓਟੀਪੀ ਪੁਸ਼ਟੀ ਕਰੋ',
      'otpSentSuccessfully': 'ਓਟੀਪੀ ਸਫਲਤਾਪੂਰਵਕ ਭੇਜ ਦਿੱਤਾ ਗਿਆ!',
      'pleaseEnterPhoneNumber': 'ਕਿਰਪਾ ਕਰਕੇ ਆਪਣਾ ਫ਼ੋਨ ਨੰਬਰ ਦਾਖਲ ਕਰੋ',
      'pleaseEnterOtp': 'ਕਿਰਪਾ ਕਰਕੇ ਓਟੀਪੀ ਦਾਖਲ ਕਰੋ',
      'invalidOtp': 'ਗਲਤ ਓਟੀਪੀ',
      'loginSuccessful': 'ਲੌਗਿਨ ਸਫਲਤਾਪੂਰਵਕ ਹੋ ਗਿਆ!',

      // Validation Messages
      'pleaseEnterName': 'ਕਿਰਪਾ ਕਰਕੇ ਆਪਣਾ ਨਾਮ ਦਰਜ ਕਰੋ',
      'pleaseEnterEmail': 'ਕਿਰਪਾ ਕਰਕੇ ਆਪਣੀ ਈਮੇਲ ਦਰਜ ਕਰੋ',
      'pleaseEnterValidEmail': 'ਕਿਰਪਾ ਕਰਕੇ ਵੈਧ ਈਮੇਲ ਦਰਜ ਕਰੋ',
      'pleaseEnterPhone': 'ਕਿਰਪਾ ਕਰਕੇ ਆਪਣਾ ਫ਼ੋਨ ਨੰਬਰ ਦਰਜ ਕਰੋ',
      'pleaseEnterPassword': 'ਕਿਰਪਾ ਕਰਕੇ ਆਪਣਾ ਪਾਸਵਰਡ ਦਰਜ ਕਰੋ',
      'pleaseEnterCurrentPassword': 'ਕਿਰਪਾ ਕਰਕੇ ਆਪਣਾ ਮੌਜੂਦਾ ਪਾਸਵਰਡ ਦਰਜ ਕਰੋ',
      'pleaseEnterNewPassword': 'ਕਿਰਪਾ ਕਰਕੇ ਨਵਾਂ ਪਾਸਵਰਡ ਦਰਜ ਕਰੋ',
      'pleaseConfirmPassword': 'ਕਿਰਪਾ ਕਰਕੇ ਆਪਣੇ ਨਵੇਂ ਪਾਸਵਰਡ ਦੀ ਪੁਸ਼ਟੀ ਕਰੋ',
      'passwordsDoNotMatch': 'ਪਾਸਵਰਡ ਮੇਲ ਨਹੀਂ ਖਾਂਦੇ',
      'passwordMinLength': 'ਪਾਸਵਰਡ ਘੱਟੋ-ਘੱਟ 6 ਅੱਖਰਾਂ ਦਾ ਹੋਣਾ ਚਾਹੀਦਾ ਹੈ',
      'pincodeMustBe6Digits': 'ਪਿੰਨ ਕੋਡ 6 ਅੰਕਾਂ ਦਾ ਹੋਣਾ ਚਾਹੀਦਾ ਹੈ',
      'phoneMustBe10Digits': 'ਫ਼ੋਨ ਨੰਬਰ 10 ਅੰਕਾਂ ਦਾ ਹੋਣਾ ਚਾਹੀਦਾ ਹੈ',

      // Settings
      'settings': 'ਸੈਟਿੰਗਾਂ',
      'profileSettings': 'ਪ੍ਰੋਫਾਈਲ ਸੈਟਿੰਗਾਂ',
      'appSettings': 'ਐਪ ਸੈਟਿੰਗਾਂ',
      'security': 'ਸੁਰੱਖਿਆ',
      'changePassword': 'ਪਾਸਵਰਡ ਬਦਲੋ',
      'editProfile': 'ਪ੍ਰੋਫਾਈਲ ਸੰਪਾਦਿਤ ਕਰੋ',
      'darkMode': 'ਡਾਰਕ ਮੋਡ',
      'pushNotifications': 'ਪੁਸ਼ ਨੋਟੀਫਿਕੇਸ਼ਨ',
      'notificationsSubtitle': 'ਰਿਵਾਰਡਾਂ ਅਤੇ ਅੱਪਡੇਟਾਂ ਬਾਰੇ ਨੋਟੀਫਿਕੇਸ਼ਨ ਪ੍ਰਾਪਤ ਕਰੋ',
      'language': 'ਭਾਸ਼ਾ',
      'biometricAuth': 'ਬਾਇਓਮੈਟ੍ਰਿਕ ਪ੍ਰਮਾਣੀਕਰਨ',
      'biometricAuthSubtitle': 'ਲੌਗਿਨ ਲਈ ਫਿੰਗਰਪ੍ਰਿੰਟ ਜਾਂ ਫੇਸ ਆਈਡੀ ਵਰਤੋ',
      'privacyPolicy': 'ਪਰਾਈਵੇਸੀ ਨੀਤੀ',
      'termsOfService': 'ਸੇਵਾ ਦੀਆਂ ਸ਼ਰਤਾਂ',
      'about': 'ਬਾਰੇ',
      'appVersion': 'ਐਪ ਵਰਜਨ',
      'checkForUpdates': 'ਅੱਪਡੇਟਾਂ ਲਈ ਜਾਂਚ ਕਰੋ',
      'deleteAccount': 'ਖਾਤਾ ਮਿਟਾਓ',
      'deleteAccountSubtitle': 'ਆਪਣਾ ਖਾਤਾ ਅਤੇ ਸਾਰਾ ਡੇਟਾ ਸਥਾਈ ਤੌਰ ਤੇ ਮਿਟਾਓ',
      'cancel': 'ਰੱਦ ਕਰੋ',
      'delete': 'ਮਿਟਾਓ',

      // Account
      'myAccount': 'ਮੇਰਾ ਖਾਤਾ',
      'saveProfile': 'ਪ੍ਰੋਫਾਈਲ ਸਾਂਭ ਕੇ ਰੱਖੋ',
      'saveChanges': 'ਤਬਦੀਲੀਆਂ ਸਾਂਭ ਕੇ ਰੱਖੋ',
      'profileUpdated': 'ਪ੍ਰੋਫਾਈਲ ਸਫਲਤਾਪੂਰਵਕ ਅੱਪਡੇਟ ਕੀਤਾ ਗਿਆ',
      'passwordChanged': 'ਪਾਸਵਰਡ ਸਫਲਤਾਪੂਰਵਕ ਬਦਲ ਦਿੱਤਾ ਗਿਆ',

      // Rewards
      'points': 'ਪੁਆਇੰਟ',
      'pointsRequired': 'ਲੋੜੀਂਦੇ ਪੁਆਇੰਟ',
      'redeemNow': 'ਹੁਣ ਰਿਡੀਮ ਕਰੋ',
      'confirmRedemption': 'ਰਿਡੈਂਪਸ਼ਨ ਦੀ ਪੁਸ਼ਟੀ ਕਰੋ',
      'redeemConfirmMessage': 'ਕੀ ਤੁਸੀਂ ਸੱਚਮੁੱਚ {points} ਪੁਆਇੰਟਾਂ ਲਈ {title} ਰਿਡੀਮ ਕਰਨਾ ਚਾਹੁੰਦੇ ਹੋ?',
      'confirm': 'ਪੁਸ਼ਟੀ ਕਰੋ',
      'successfullyRedeemed': '{title} ਸਫਲਤਾਪੂਰਵਕ ਰਿਡੀਮ ਕੀਤਾ ਗਿਆ!',

      // Error Messages
      'loginFailed': 'ਲੌਗਿਨ ਅਸਫਲ: {error}',
      'registrationFailed': 'ਰਜਿਸਟ੍ਰੇਸ਼ਨ ਅਸਫਲ: {error}',
      'errorOccurred': 'ਗਲਤੀ: {error}',
      'fillAllFields': 'ਕਿਰਪਾ ਕਰਕੇ ਸਾਰੇ ਖੇਤਰ ਭਰੋ',
    },
  };

  // Getters for translations
  String? get appTitle => _localizedValues[locale.languageCode]?['appTitle'];
  String? get welcome => _localizedValues[locale.languageCode]?['welcome'];
  String? get welcomeBack => _localizedValues[locale.languageCode]?['welcomeBack'];
  String? get signInToContinue => _localizedValues[locale.languageCode]?['signInToContinue'];
  String? get loading => _localizedValues[locale.languageCode]?['loading'];

  // Auth & Profile getters
  String? get login => _localizedValues[locale.languageCode]?['login'];
  String? get register => _localizedValues[locale.languageCode]?['register'];
  String? get phoneNumber => _localizedValues[locale.languageCode]?['phoneNumber'];
  String? get email => _localizedValues[locale.languageCode]?['email'];
  String? get password => _localizedValues[locale.languageCode]?['password'];
  String? get currentPassword => _localizedValues[locale.languageCode]?['currentPassword'];
  String? get newPassword => _localizedValues[locale.languageCode]?['newPassword'];
  String? get confirmPassword => _localizedValues[locale.languageCode]?['confirmPassword'];
  String? get fullName => _localizedValues[locale.languageCode]?['fullName'];
  String? get address => _localizedValues[locale.languageCode]?['address'];
  String? get pincode => _localizedValues[locale.languageCode]?['pincode'];
  String? get state => _localizedValues[locale.languageCode]?['state'];
  String? get enterOtp => _localizedValues[locale.languageCode]?['enterOtp'];
  String? get sendOtp => _localizedValues[locale.languageCode]?['sendOtp'];
  String? get verifyOtp => _localizedValues[locale.languageCode]?['verifyOtp'];
  String? get otpSentSuccessfully => _localizedValues[locale.languageCode]?['otpSentSuccessfully'];
  String? get pleaseEnterPhoneNumber => _localizedValues[locale.languageCode]?['pleaseEnterPhoneNumber'];
  String? get pleaseEnterOtp => _localizedValues[locale.languageCode]?['pleaseEnterOtp'];
  String? get invalidOtp => _localizedValues[locale.languageCode]?['invalidOtp'];
  String? get loginSuccessful => _localizedValues[locale.languageCode]?['loginSuccessful'];

  // Validation Messages
  String? get pleaseEnterName => _localizedValues[locale.languageCode]?['pleaseEnterName'];
  String? get pleaseEnterEmail => _localizedValues[locale.languageCode]?['pleaseEnterEmail'];
  String? get pleaseEnterValidEmail => _localizedValues[locale.languageCode]?['pleaseEnterValidEmail'];
  String? get pleaseEnterPhone => _localizedValues[locale.languageCode]?['pleaseEnterPhone'];
  String? get pleaseEnterPassword => _localizedValues[locale.languageCode]?['pleaseEnterPassword'];
  String? get pleaseEnterCurrentPassword => _localizedValues[locale.languageCode]?['pleaseEnterCurrentPassword'];
  String? get pleaseEnterNewPassword => _localizedValues[locale.languageCode]?['pleaseEnterNewPassword'];
  String? get pleaseConfirmPassword => _localizedValues[locale.languageCode]?['pleaseConfirmPassword'];
  String? get passwordsDoNotMatch => _localizedValues[locale.languageCode]?['passwordsDoNotMatch'];
  String? get passwordMinLength => _localizedValues[locale.languageCode]?['passwordMinLength'];
  String? get pincodeMustBe6Digits => _localizedValues[locale.languageCode]?['pincodeMustBe6Digits'];
  String? get phoneMustBe10Digits => _localizedValues[locale.languageCode]?['phoneMustBe10Digits'];

  // Settings getters
  String? get settings => _localizedValues[locale.languageCode]?['settings'];
  String? get profileSettings => _localizedValues[locale.languageCode]?['profileSettings'];
  String? get appSettings => _localizedValues[locale.languageCode]?['appSettings'];
  String? get security => _localizedValues[locale.languageCode]?['security'];
  String? get changePassword => _localizedValues[locale.languageCode]?['changePassword'];
  String? get editProfile => _localizedValues[locale.languageCode]?['editProfile'];
  String? get darkMode => _localizedValues[locale.languageCode]?['darkMode'];
  String? get pushNotifications => _localizedValues[locale.languageCode]?['pushNotifications'];
  String? get notificationsSubtitle => _localizedValues[locale.languageCode]?['notificationsSubtitle'];
  String? get language => _localizedValues[locale.languageCode]?['language'];
  String? get biometricAuth => _localizedValues[locale.languageCode]?['biometricAuth'];
  String? get biometricAuthSubtitle => _localizedValues[locale.languageCode]?['biometricAuthSubtitle'];
  String? get privacyPolicy => _localizedValues[locale.languageCode]?['privacyPolicy'];
  String? get termsOfService => _localizedValues[locale.languageCode]?['termsOfService'];
  String? get about => _localizedValues[locale.languageCode]?['about'];
  String? get appVersion => _localizedValues[locale.languageCode]?['appVersion'];
  String? get checkForUpdates => _localizedValues[locale.languageCode]?['checkForUpdates'];
  String? get deleteAccount => _localizedValues[locale.languageCode]?['deleteAccount'];
  String? get deleteAccountSubtitle => _localizedValues[locale.languageCode]?['deleteAccountSubtitle'];
  String? get cancel => _localizedValues[locale.languageCode]?['cancel'];
  String? get delete => _localizedValues[locale.languageCode]?['delete'];

  // Account getters
  String? get myAccount => _localizedValues[locale.languageCode]?['myAccount'];
  String? get saveProfile => _localizedValues[locale.languageCode]?['saveProfile'];
  String? get saveChanges => _localizedValues[locale.languageCode]?['saveChanges'];
  String? get profileUpdated => _localizedValues[locale.languageCode]?['profileUpdated'];
  String? get passwordChanged => _localizedValues[locale.languageCode]?['passwordChanged'];

  // Rewards getters
  String? get points => _localizedValues[locale.languageCode]?['points'];
  String? get pointsRequired => _localizedValues[locale.languageCode]?['pointsRequired'];
  String? get redeemNow => _localizedValues[locale.languageCode]?['redeemNow'];
  String? get confirmRedemption => _localizedValues[locale.languageCode]?['confirmRedemption'];
  String? get confirm => _localizedValues[locale.languageCode]?['confirm'];

  // Error getters
  String? get fillAllFields => _localizedValues[locale.languageCode]?['fillAllFields'];

  // Parameterized translations
  String? redeemConfirmMessage(String title, int points) {
    String? message = _localizedValues[locale.languageCode]?['redeemConfirmMessage'];
    return message?.replaceAll('{title}', title).replaceAll('{points}', points.toString());
  }

  String? successfullyRedeemed(String title) {
    String? message = _localizedValues[locale.languageCode]?['successfullyRedeemed'];
    return message?.replaceAll('{title}', title);
  }

  String? loginFailed(String error) {
    String? message = _localizedValues[locale.languageCode]?['loginFailed'];
    return message?.replaceAll('{error}', error);
  }

  String? registrationFailed(String error) {
    String? message = _localizedValues[locale.languageCode]?['registrationFailed'];
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
