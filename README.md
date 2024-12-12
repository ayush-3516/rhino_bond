# Project Overview

This project is a Flutter application that implements phone number authentication using Supabase. The application allows users to register, log in, and verify their phone numbers using OTP (One-Time Password). This README provides a comprehensive and detailed explanation of the project structure, authentication workflow, key files, dependencies, and instructions on how to run the project.

## Project Structure

The project is structured as follows:

- **android/**: Contains the Android-specific configuration files.
  - **build.gradle**: The main build configuration file for the Android project.
  - **gradle.properties**: Contains properties used by the Gradle build system.
  - **settings.gradle**: Defines the project name and includes sub-projects.
  - **app/**: Contains the Android application module.
    - **build.gradle**: The build configuration file for the app module.
    - **src/**: Contains the source code for the Android app.
      - **debug/**: Contains the debug configuration files.
      - **main/**: Contains the main source code and resources.
        - **java/**: Contains the Java/Kotlin source code.
        - **res/**: Contains resources such as drawables, layouts, and values.
      - **profile/**: Contains the profile configuration files.
- **ios/**: Contains the iOS-specific configuration files.
  - **Podfile**: Defines the dependencies for the iOS project.
  - **Flutter/**: Contains Flutter-specific configuration files.
  - **Runner/**: Contains the main iOS application files.
    - **AppDelegate.swift**: The main application delegate.
    - **Info.plist**: The property list file containing application metadata.
    - **Assets.xcassets/**: Contains application assets such as icons and launch images.
    - **Base.lproj/**: Contains localized resources.
- **lib/**: Contains the Dart code for the application.
  - **main.dart**: The entry point of the application.
  - **src/**: Contains the source code organized into various directories.
    - **app/**: Contains the main application view.
      - **app_view.dart**
    - **base/**: Contains base utilities and enums.
      - **enums/**: Contains enumerations used throughout the application.
        - **verification_mode.dart**
      - **utils/**: Contains utility functions and constants.
        - **constants.dart**
        - **local_db_keys.dart**
        - **supabase_tables.dart**
        - **utils.dart**
    - **configs/**: Contains configuration files for the application.
      - **app_setup.dart**
      - **app_setup.locator.dart**
      - **app_setup.router.dart**
      - **supabase_setup.dart**
    - **models/**: Contains data models used in the application.
      - **app_user.dart**
      - **wrappers/**: Contains wrapper classes.
        - **response_wrapper.dart**
    - **services/**: Contains services for handling local and remote operations.
      - **local/**: Contains services for local operations such as connectivity and navigation.
        - **connectivity_service.dart**
        - **flavor_service.dart**
        - **navigation_service.dart**
        - **base/**: Contains base classes for local services.
          - **connectivity_view_model.dart**
      - **remote/**: Contains services for remote operations such as authentication.
        - **supabase_auth_service.dart**
        - **base/**: Contains base classes for remote services.
          - **supabase_auth_view_model.dart**
    - **shared/**: Contains shared widgets and components.
      - **custom_app_bar.dart**
      - **custom_form_field.dart**
      - **custom_phone_number_field.dart**
      - **loading_indicator.dart**
      - **main_button.dart**
      - **spacing.dart**
      - **text_field_heading.dart**
    - **styles/**: Contains styling definitions for the application.
      - **app_colors.dart**
      - **text_theme.dart**
    - **views/**: Contains the views for different screens in the application.
      - **home/**: Contains the home view and its associated view model.
        - **home_view_model.dart**
        - **home_view.dart**
      - **login/**: Contains the login view and its associated view model.
        - **login_view_model.dart**
        - **login_view.dart**
      - **register/**: Contains the registration view and its associated view model.
        - **register_view_model.dart**
        - **register_view.dart**
      - **splash/**: Contains the splash screen view and its associated view model.
        - **splash_view_model.dart**
        - **splash_view.dart**
      - **verify_otp/**: Contains the OTP verification view and its associated view model.
        - **verify_otp_view_model.dart**
        - **verify_otp_view.dart**

## Authentication Workflow

### Registration

1. **User Input**: The user provides their name, email, and phone number.
2. **OTP Sending**: The application sends an OTP to the provided phone number using Supabase.
3. **OTP Verification**: The user enters the OTP received on their phone.
4. **User Creation**: If the OTP is verified, the user is created in the database and logged in.

### Login

1. **User Input**: The user provides their phone number.
2. **OTP Sending**: The application sends an OTP to the provided phone number using Supabase.
3. **OTP Verification**: The user enters the OTP received on their phone.
4. **User Login**: If the OTP is verified, the user is logged in.

### Logout

1. **Logout**: The user can log out, which clears the user session and local storage.

## Key Files

### `supabase_auth_service.dart`

This file contains the core authentication logic. It handles user registration, login, and logout using Supabase.

### `login_view_model.dart`

This file contains the logic for the login view. It handles the user interaction for logging in and navigates to the OTP verification screen after sending the OTP.

### `register_view_model.dart`

This file contains the logic for the registration view. It handles the user interaction for registering and navigates to the OTP verification screen after sending the OTP.

### `verify_otp_view_model.dart`

This file contains the logic for the OTP verification view. It handles the user interaction for verifying the OTP and completes the login or registration process based on the mode.

## Dependencies

- **supabase_flutter**: For integrating Supabase authentication.
- **shared_preferences**: For storing user data locally.
- **stacked**: For state management and view models.

## How to Run the Project

1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Run `flutter run` to start the application.

## Conclusion

This project demonstrates a robust implementation of phone number authentication using Supabase in a Flutter application. The structured codebase and clear separation of concerns make it easy to understand and extend.

## Files in 'lib/' Directory

### `main.dart`

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phone_auth_twillio/src/configs/supabase_setup.dart';
import 'package:phone_auth_twillio/src/services/remote/supabase_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phone_auth_twillio/src/app/app_view.dart';
import 'package:phone_auth_twillio/src/configs/app_setup.locator.dart';
import 'package:phone_auth_twillio/src/services/local/flavor_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //LOAD ENV
  await dotenv.load(fileName: ".env");

  //initialize supabase
  await SupabaseSetup.init();
  SupabaseAuthService.prefs = await SharedPreferences.getInstance();

  // getting package
  final package = await PackageInfo.fromPlatform();

  setupLocator();

  // app flavor init
  FlavorService.init(package);

  runApp(const AppView());
}

```

### `src/app/app_view.dart`

```dart
import 'package:phone_auth_twillio/src/services/local/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_auth_twillio/src/base/utils/constants.dart';
import 'package:phone_auth_twillio/src/styles/app_colors.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // statusBarColor: AppColors.primary.withOpacity(0.7),

        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, snapshot) {
        return MaterialApp(
          title: Constants.appTitle,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: NavService.onGenerateRoute,
          navigatorKey: NavService.key,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
            colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              secondary: AppColors.secondary,
              onSecondary: AppColors.white,
              error: AppColors.red,
              onError: AppColors.white,
              background: AppColors.white,
              onBackground: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.primary,
            ),
            fontFamily: 'Poppins',
          ),
          builder: (context, child) {
            return Stack(
              children: [child!],
            );
          },
        );
      },
    );
  }
}

```

### `src/base/enums/verification_mode.dart`

```dart
enum VerificationMode { login, register }

```

### `src/base/utils/constants.dart`

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_auth_twillio/generated/assets.dart';
import 'package:phone_auth_twillio/src/styles/app_colors.dart';
import 'package:phone_auth_twillio/src/styles/text_theme.dart';

class Constants {
  Constants._();

  static String get appTitle => "Example";

  static customErrorSnack(String? msg, {String? title}) {
    Get.snackbar(
      title ?? "Error",
      msg ?? "Error",
      titleText: Text(
        title ?? "Error",
        style: TextStyling.large2Bold.copyWith(
          color: AppColors.error,
          fontSize: 15.sp,
        ),
      ),
      messageText: Text(
        msg.toString(),
        style: TextStyling.mediumRegular.copyWith(
          color: AppColors.white,
          fontSize: 12.sp,
        ),
      ),
      backgroundColor: AppColors.primary.withOpacity(0.8),
      duration: Duration(seconds: 3),
      icon: Image.asset(
        Assets.errorIcon,
        height: 20.h,
      ),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
    );
  }

  static customSuccessSnack(String? msg, {String? title}) {
    Get.snackbar(
      title ?? "Congrats",
      msg ?? "Congrats",
      titleText: Text(
        title ?? "Congrats",
        style: TextStyling.large2Bold.copyWith(
          color: AppColors.green,
          fontSize: 15.sp,
        ),
      ),
      messageText: Text(
        msg.toString(),
        style: TextStyling.mediumRegular.copyWith(
          color: AppColors.white,
          fontSize: 12.sp,
        ),
      ),
      backgroundColor: AppColors.primary,
      duration: Duration(seconds: 3),
      icon: Image.asset(
        Assets.successIcon,
        height: 20.h,
      ),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
    );
  }

  static customWarningSnack(String? msg, {String? title}) {
    Get.snackbar(
      title ?? "Warning",
      msg ?? "Warning",
      titleText: Text(
        title ?? "Warning",
        style: TextStyling.large2Bold.copyWith(
          color: AppColors.white,
          // color: AppColors.warning,
          fontSize: 15.sp,
        ),
      ),
      messageText: Text(
        msg.toString(),
        style: TextStyling.mediumRegular.copyWith(
          color: AppColors.white,
          fontSize: 12.sp,
        ),
      ),
      backgroundColor: AppColors.primary,
      duration: Duration(seconds: 3),
      icon: Image.asset(
        Assets.warningIcon,
        height: 20.h,
      ),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
    );
  }
}

```

### `src/base/utils/local_db_keys.dart`

```dart
class LocalDatabaseKeys {
  LocalDatabaseKeys._();

  static const String appUser = "app_user";
}

class EnvKeys {
  static const String supabaseAnonKey = "ANON_KEY";
  static const String supabaseUrl = "URL";
}

```

### `src/base/utils/supabase_tables.dart`

```dart
class SupabaseTables {
  SupabaseTables._();

  static const appUsers = 'app_users';
}

```

### `src/base/utils/utils.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension UIExt on BuildContext {
  double topSpace() => MediaQuery.of(this).padding.top;
  double appBarHeight() => AppBar().preferredSize.height;
  Size screenSize() => MediaQuery.of(this).size;
  ThemeData appTheme() => Theme.of(this);
  TextTheme appTextTheme() => Theme.of(this).textTheme;

  void closeKeyboardIfOpen() {
    FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
  }
}

class ValidationUtils {
  static String? validateName(String? value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(pattern);
    if (value?.isEmpty ?? true) {
      return "Name is required";
    } else if (!regExp.hasMatch(value ?? '')) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  static String? validateMobile(String? value) {
    String pattern = r'(^\+?[0-9]*$)';
    RegExp regExp = RegExp(pattern);
    if (value?.isEmpty ?? true) {
      return "Mobile phone number is required";
    } else if (!regExp.hasMatch(value ?? '')) {
      return "Invalid Mobile Number";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if ((value?.length ?? 0) < 6) {
      return 'Password must be atleast 6 characters';
    } else {
      return null;
    }
  }

  // static String? validateTextFormFieldForEmptyInput(String? value) {
  //   if ((value?.length ?? 0) < 1) {
  //     return 'Empty input not allowed';
  //   } else {
  //     return null;
  //   }
  // }

  static String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value ?? '')) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (password != confirmPassword) {
      return 'Password doesn\'t match';
    } else if (confirmPassword?.isEmpty ?? true) {
      return 'Please confirm your password';
    } else {
      return null;
    }
  }

  static List<TextInputFormatter> numberTextInputFormater = [
    FilteringTextInputFormatter.digitsOnly
  ];
}

```

### `src/configs/app_setup.dart`

```dart
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:phone_auth_twillio/src/services/local/connectivity_service.dart';
import 'package:phone_auth_twillio/src/services/remote/supabase_auth_service.dart';
import 'package:phone_auth_twillio/src/views/home/home_view.dart';
import 'package:phone_auth_twillio/src/views/login/login_view.dart';
import 'package:phone_auth_twillio/src/views/register/register_view.dart';
import 'package:phone_auth_twillio/src/views/splash/splash_view.dart';
import 'package:phone_auth_twillio/src/views/verify_otp/verify_otp_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: SplashView, initial: true),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: VerifyOtpView),
    MaterialRoute(page: HomeView),
  ],
  dependencies: [
    // Singletons
    Singleton(classType: ConnectivityService),
    // Lazy singletons
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SupabaseAuthService),
  ],
)
class AppSetup {
  /** This class has no puporse besides housing the annotation that generates the required functionality **/
}

```

### `src/configs/app_setup.locator.dart`

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_shared/stacked_shared.dart';

import '../services/local/connectivity_service.dart';
import '../services/remote/supabase_auth_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerSingleton(ConnectivityService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SupabaseAuthService());
}

```

### `src/configs/app_setup.router.dart`

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i7;
import 'package:flutter/material.dart';
import 'package:phone_auth_twillio/src/base/enums/verification_mode.dart'
    as _i8;
import 'package:phone_auth_twillio/src/views/home/home_view.dart' as _i6;
import 'package:phone_auth_twillio/src/views/login/login_view.dart' as _i3;
import 'package:phone_auth_twillio/src/views/register/register_view.dart'
    as _i4;
import 'package:phone_auth_twillio/src/views/splash/splash_view.dart' as _i2;
import 'package:phone_auth_twillio/src/views/verify_otp/verify_otp_view.dart'
    as _i5;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i9;

class Routes {
  static const splashView = '/';

  static const loginView = '/login-view';

  static const registerView = '/register-view';

  static const verifyOtpView = '/verify-otp-view';

  static const cSDashboardView = '/c-sdashboard-view';

  static const all = <String>{
    splashView,
    loginView,
    registerView,
    verifyOtpView,
    cSDashboardView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.splashView,
      page: _i2.SplashView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i3.LoginView,
    ),
    _i1.RouteDef(
      Routes.registerView,
      page: _i4.RegisterView,
    ),
    _i1.RouteDef(
      Routes.verifyOtpView,
      page: _i5.VerifyOtpView,
    ),
    _i1.RouteDef(
      Routes.cSDashboardView,
      page: _i6.HomeView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.SplashView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.SplashView(),
        settings: data,
      );
    },
    _i3.LoginView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.LoginView(),
        settings: data,
      );
    },
    _i4.RegisterView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.RegisterView(),
        settings: data,
      );
    },
    _i5.VerifyOtpView: (data) {
      final args = data.getArgs<VerifyOtpViewArguments>(nullOk: false);
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.VerifyOtpView(
            key: args.key,
            phone: args.phone,
            mode: args.mode,
            email: args.email,
            name: args.name),
        settings: data,
      );
    },
    _i6.HomeView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.HomeView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class VerifyOtpViewArguments {
  const VerifyOtpViewArguments({
    this.key,
    required this.phone,
    required this.mode,
    required this.email,
    required this.name,
  });

  final _i7.Key? key;

  final String phone;

  final _i8.VerificationMode mode;

  final String? email;

  final String? name;

  @override
  String toString() {
    return '{"key": "$key", "phone": "$phone", "mode": "$mode", "email": "$email", "name": "$name"}';
  }

  @override
  bool operator ==(covariant VerifyOtpViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.phone == phone &&
        other.mode == mode &&
        other.email == email &&
        other.name == name;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        phone.hashCode ^
        mode.hashCode ^
        email.hashCode ^
        name.hashCode;
  }
}

extension NavigatorStateExtension on _i9.NavigationService {
  Future<dynamic> navigateToSplashView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.splashView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRegisterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.registerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToVerifyOtpView({
    _i7.Key? key,
    required String phone,
    required _i8.VerificationMode mode,
    required String? email,
    required String? name,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.verifyOtpView,
        arguments: VerifyOtpViewArguments(
            key: key, phone: phone, mode: mode, email: email, name: name),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCSDashboardView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.cSDashboardView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSplashView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.splashView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRegisterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.registerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithVerifyOtpView({
    _i7.Key? key,
    required String phone,
    required _i8.VerificationMode mode,
    required String? email,
    required String? name,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.verifyOtpView,
        arguments: VerifyOtpViewArguments(
            key: key, phone: phone, mode: mode, email: email, name: name),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCSDashboardView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.cSDashboardView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}

```

### `src/configs/supabase_setup.dart`

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:phone_auth_twillio/src/base/utils/local_db_keys.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseSetup {
  static final String _supabaseUrl = dotenv.env[EnvKeys.supabaseUrl]!;
  static final String _supabaseAnonKey = dotenv.env[EnvKeys.supabaseAnonKey]!;

  static Future<void> init() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }
}

```

### `src/models/app_user.dart`

```dart
import 'dart:convert';

class AppUser {
  final String? id;
  final DateTime? createdAt;
  final String? phone;
  final String? name;
  final String? email;
  AppUser({
    this.id,
    this.createdAt,
    this.phone,
    this.name,
    this.email,
  });

  AppUser copyWith({
    String? id,
    String? user,
    String? profilePic,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? loggedInAt,
    String? phone,
    String? name,
    String? email,
    bool? loggedInAsCustomer,
    bool? isCustomer,
    bool? isServiceProvider,
    bool? isVerified,
    String? lastLoginAs,
    bool? verifiedAsSp,
    String? identityDocument,
    String? insuranceDocument,
  }) {
    return AppUser(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'phone': phone,
      'name': name,
      'email': email,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] != null ? map['id'] as String : null,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  static List<AppUser>? fromJsonList(List<dynamic>? jsonList) {
    return jsonList?.map((e) => AppUser.fromMap(e)).toList();
  }
}

```

### `src/models/wrappers/response_wrapper.dart`

```dart
class ResponseWrapper<T> {
  final T? data;
  final bool success;
  final String? message;
  final int? statusCode;

  ResponseWrapper({
    this.data,
    this.success = true,
    this.message,
    this.statusCode,
  });
}

```

### `src/services/local/connectivity_service.dart`

```dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:stacked/stacked.dart';

class ConnectivityService with ListenableServiceMixin {
  final ReactiveValue<bool> _isInternetConnected = ReactiveValue<bool>(true);
  bool get isInternetConnected => _isInternetConnected.value;

  ConnectivityService() {
    listenToReactiveValues([_isInternetConnected]);
    updateStatus();
    Connectivity().onConnectivityChanged.listen((result) {
      _isInternetConnected.value = result != ConnectivityResult.none;
      notifyListeners();
    });
  }

  updateStatus() async {
    _isInternetConnected.value =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;
  }
}

```

### `src/services/local/flavor_service.dart`

```dart
import 'package:package_info_plus/package_info_plus.dart';

enum Env {
  prod,
  dev,
}

class FlavorService {
  FlavorService._();

  static Env? env;

  static init(PackageInfo info) {
    final flavor = info.packageName.split(".").last;
    if (flavor == 'dev') {
      env = Env.dev;
    } else {
      env = Env.prod;
    }
  }

  static String get getBaseApi {
    // return prod url
    if (env == Env.prod) {
      return "";
    }
    // return url other than prod one
    return "";
  }
}

```

### `src/services/local/navigation_service.dart`

```dart
import 'package:phone_auth_twillio/src/configs/app_setup.locator.dart';
import 'package:phone_auth_twillio/src/configs/app_setup.router.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class NavService {
  //for all the navigation things it will be used.
  static final NavigationService _service = locator<NavigationService>();

  //navigator key
  static GlobalKey<NavigatorState>? get key => StackedService.navigatorKey;

  //home screen scaffold key
  static final GlobalKey<ScaffoldState> _sKey = GlobalKey<ScaffoldState>();
  static GlobalKey<ScaffoldState> get scaffoldKey => _sKey;

  //onGenerateRoute
  static Route<dynamic>? Function(RouteSettings) get onGenerateRoute =>
      StackedRouter().onGenerateRoute;

  // CLEAR STACK & SHOW
  static Future<dynamic>? login({dynamic arguments}) =>
      _service.clearStackAndShow(Routes.loginView, arguments: arguments);

  static Future<dynamic>? register({dynamic arguments}) =>
      _service.clearStackAndShow(Routes.registerView, arguments: arguments);

  // NAVIGATE TO
  static Future<dynamic>? navigateToRegister({dynamic arguments}) =>
      _service.navigateTo(Routes.registerView, arguments: arguments);

  static Future<dynamic>? navigateToverifyOtp({dynamic arguments}) =>
      _service.navigateTo(
        Routes.verifyOtpView,
        arguments: arguments,
      );

  static Future<dynamic>? home({dynamic arguments}) =>
      _service.clearStackAndShow(Routes.cSDashboardView, arguments: arguments);

  // BACK
  static bool back({dynamic arguments}) => _service.back();
}

```

### `src/services/local/base/connectivity_view_model.dart`

```dart
import 'package:phone_auth_twillio/src/configs/app_setup.locator.dart';
import 'package:phone_auth_twillio/src/services/local/connectivity_service.dart';
import 'package:stacked/stacked.dart';

mixin ConnectivityViewModel on ReactiveViewModel {
  final ConnectivityService _connectivityService =
      locator<ConnectivityService>();
  ConnectivityService get connectivityService => _connectivityService;

  @override
  List<ListenableServiceMixin> get listenableServices => [_connectivityService];
}

```

### `src/services/remote/supabase_auth_service.dart`

```dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:phone_auth_twillio/src/base/utils/local_db_keys.dart';
import 'package:phone_auth_twillio/src/base/utils/supabase_tables.dart';
import 'package:phone_auth_twillio/src/configs/app_setup.locator.dart';
import 'package:phone_auth_twillio/src/models/app_user.dart';
import 'package:phone_auth_twillio/src/services/local/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService with ListenableServiceMixin {
  static late final SharedPreferences prefs;

  static final ConnectivityService _connectivityService =
      locator<ConnectivityService>();

  static final _supabase = Supabase.instance.client;

  final ReactiveValue<bool> _userLoggedIn =
      ReactiveValue(_supabase.auth.currentSession != null);

  bool get userLoggedIn => _userLoggedIn.value;

  final ReactiveValue<AppUser?> _appUser = ReactiveValue<AppUser?>(null);

  AppUser? get user => _appUser.value;

  SupabaseAuthService() {
    listenToReactiveValues([_appUser, _userLoggedIn]);
    _syncUser();
    _restoreUserFromLocal();
    _setupAuthListner();
  }

  _setupAuthListner() {
    _supabase.auth.onAuthStateChange.listen(
      (data) {
        _userLoggedIn.value = data.session != null;
      },
    );
  }

  Future<bool> register(
    String phoneNumber,
    String email,
  ) async {
    if (!_connectivityService.isInternetConnected) {
      throw CustomNoInternetException(message: 'No Internet Connection');
    }
    try {
      // Check if user exists
      final userExists = await checkUserExistsWithPhoneNumberAndEmail(
        phoneNumber,
        email,
      );

      if (userExists) {
        throw AuthExcepection(
          message:
              'User with this phone number already exist, please login to continue',
        );
      }

      // Send OTP to phone number
      final otpResponse = await _supabase.auth.signInWithOtp(
        phone: phoneNumber,
      );

      return true;
    } on AuthApiException catch (e) {
      throw AuthExcepection(message: e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<AppUser?> verifyPhoneNumberAndRegister({
    required String email,
    required String name,
    required String phone,
    required String otp,
  }) async {
    try {
      // Verify OTP
      final response = await _supabase.auth.verifyOTP(
        phone: phone,
        token: otp,
        type: OtpType.sms,
      );
      if (response.user == null) {
        throw AuthExcepection(message: 'Please enter a valid code');
      }

      final AppUser user = AppUser(
        id: response.user?.id,
        email: email,
        name: name,
        phone: phone,
      );

      final createdUser = await _createUser(user);

      if (createdUser == null) {
        throw AuthExcepection(message: 'Unable to create user');
      }

      _appUser.value = createdUser;
      _storeLocally();

      return createdUser;
    } on AuthApiException catch (e) {
      print(e.statusCode);
      print('error: ${e.message}');
      if (e.statusCode == '403' &&
          e.message.toLowerCase().startsWith('token has expired')) {
        throw AuthExcepection(message: 'Please enter a valid code');
      }
      throw AuthExcepection(message: e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<AppUser?> verifyPhoneNumberAndLogin({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        phone: phone,
        token: otp,
        type: OtpType.sms,
      );
      if (response.user == null) {
        throw AuthExcepection(message: 'Please enter a valid code');
      }

      final user = await _getUser(response.user!.id);

      if (user == null) {
        throw AuthExcepection(message: 'Unable to find user');
      }

      _appUser.value = user;
      _storeLocally();

      return user;
    } on AuthApiException catch (e) {
      print(e.statusCode);
      print('error: ${e.message}');
      if (e.statusCode == '403' &&
          e.message.toLowerCase().startsWith('token has expired')) {
        throw AuthExcepection(message: 'Please enter a valid code');
      }
      throw AuthExcepection(message: e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> login(String phoneNumber) async {
    if (!_connectivityService.isInternetConnected) {
      throw CustomNoInternetException(message: 'No Internet Connection');
    }
    try {
      // Check if user exists
      final userExists = await checkUserExistsWithPhoneNumber(phoneNumber);
      if (!userExists) {
        throw AuthExcepection(
            message: 'User does not exist, please register first');
      }

      // Send OTP to phone number
      final otpResponse = await _supabase.auth.signInWithOtp(
        phone: phoneNumber,
      );

      return true;
    } on AuthApiException catch (e) {
      throw AuthExcepection(message: e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUserExistsWithPhoneNumber(String phoneNumber) async {
    try {
      print('checkUserExistsWithPhoneNumber called');
      final response = await _supabase
          .from(SupabaseTables.appUsers)
          .select()
          .eq('phone', phoneNumber)
          .single();
      print('checkUserExistsWithPhoneNumber called');

      return response['id'] != null;
    } catch (e) {
      print('checkUserExistsWithPhoneNumber called');

      print('error in checkUserExistsWithPhoneNumber: $e');
      return false;
    }
  }

  Future<bool> checkUserExistsWithPhoneNumberAndEmail(
      String phoneNumber, String email) async {
    try {
      print('checkUserExistsWithPhoneNumberAndEmail called');
      final response = await _supabase
          .from(SupabaseTables.appUsers)
          .select()
          .or('phone.eq.${phoneNumber},email.eq.${email}');
      print('checkUserExistsWithPhoneNumberAndEmail called');

      return response.isNotEmpty;
    } catch (e) {
      print('checkUserExistsWithPhoneNumberAndEmail called');

      print('error in checkUserExistsWithPhoneNumberAndEmail: $e');
      return false;
    }
  }

  Future logout() async {
    if (!_connectivityService.isInternetConnected) {
      throw CustomNoInternetException(message: 'No Internet Connection');
    }
    try {
      await _supabase.auth.signOut();
      _clearUserFromLocal();
    } catch (e) {
      throw AuthExcepection(message: e.toString());
    }
  }

  Future<AppUser?> _createUser(AppUser? user) async {
    try {
      print('create user called');

      print(user?.toMap());
      AppUser? response;
      if (user != null) {
        final createdUser = await _supabase
            .from(SupabaseTables.appUsers)
            .insert(user.toMap())
            .select()
            .single();

        print('created user: $createdUser');
        response = AppUser.fromMap(createdUser);
      }

      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<AppUser?> _getUser(String id) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.appUsers)
          .select('*')
          .eq('id', id)
          .single();
      print('user: $response');
      return AppUser.fromMap(response);
    } catch (e) {
      print(e);
      return null;
    }
  }

  _syncUser() async {
    if (!_connectivityService.isInternetConnected) {
      print('no internet');
    }
    if (_supabase.auth.currentSession == null) {
      print('supabase auth session is null');
      return;
    }

    final response = await _getUser(_supabase.auth.currentUser!.id);

    if (response != null) {
      _appUser.value = response;
      _storeLocally();
    }
  }

  //FOR LOCAL DB
  _storeLocally() async {
    if (_appUser.value == null) return;
    prefs.setString(
        LocalDatabaseKeys.appUser, _appUser.value?.toJson() ?? "{}");
  }

  _restoreUserFromLocal() async {
    if (!prefs.containsKey(LocalDatabaseKeys.appUser)) return;

    final savedUser = prefs.getString(LocalDatabaseKeys.appUser) ?? "{}";

    if (savedUser == "{}") {
      _appUser.value = null;
      return;
    }

    _appUser.value = AppUser.fromMap(
        jsonDecode(prefs.getString(LocalDatabaseKeys.appUser) ?? "{}")
            as Map<String, dynamic>);
  }

  _clearUserFromLocal() async {
    if (!prefs.containsKey(LocalDatabaseKeys.appUser)) return;
    prefs.remove(LocalDatabaseKeys.appUser);
    _appUser.value = null;
  }
}

class AuthExcepection implements Exception {
  final String message;

  AuthExcepection({required this.message});
}

class CustomNoInternetException implements Exception {
  final String message;

  CustomNoInternetException({required this.message});
}

```

### `src/services/remote/base/supabase_auth_view_model.dart`

```dart
import 'package:stacked/stacked.dart';
import 'package:phone_auth_twillio/src/configs/app_setup.locator.dart';
import 'package:phone_auth_twillio/src/services/remote/supabase_auth_service.dart';

mixin SupabaseAuthViewModel on ReactiveViewModel {
  final SupabaseAuthService _authService = locator<SupabaseAuthService>();

  SupabaseAuthService get supabaseAuthService => _authService;

  @override
  List<ListenableServiceMixin> get listenableServices =>
      super.listenableServices + [_authService];
}

```

### `src/shared/custom_app_bar.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_auth_twillio/src/services/local/navigation_service.dart';
import 'package:phone_auth_twillio/src/styles/app_colors.dart';
import 'package:phone_auth_twillio/src/styles/text_theme.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    this.title,
    this.titleText,
    this.showBackButton = true,
    this.trailingWidget,
    this.titleTextStyle,
    this.backButtonColor,
    this.backButtonIcon,
  }) : super(key: key);

  final bool showBackButton;

  final Widget? title;
  final String? titleText;
  final Widget? trailingWidget;
  final TextStyle? titleTextStyle;
  final Color? backButtonColor;
  final IconData? backButtonIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50.h, left: 24.w, right: 24.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showBackButton)
            IconButton(
              onPressed: () {
                NavService.back();
              },
              iconSize: 20.sp,
              icon: Icon(
                backButtonIcon ?? Icons.arrow_back_ios,
                color: backButtonColor ?? AppColors.black,
              ),
            ),
          if (!showBackButton)
            Visibility(
              visible: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: IconButton(
                onPressed: () {
                  NavService.back();
                },
                iconSize: 20.sp,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: backButtonColor ?? AppColors.black,
                ),
              ),
            ),
          const Spacer(),
          title ??
              Text(
                titleText ?? '',
                style: titleTextStyle ??
                    TextStyling.mediumBold.copyWith(fontSize: 20.sp),
              ),
          const Spacer(),
          Row(
            children: [
              if (trailingWidget != null)
                trailingWidget!
              else
                Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.black,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

```

### `src/shared/custom_form_field.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_auth_twillio/src/styles/app_colors.dart';
import 'package:phone_auth_twillio/src/styles/text_theme.dart';

import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.labelText,
    this.isPassword = false,
    required this.validatorFunction,
    this.controller,
    // required this.textColor,
    this.textFieldBgColor,
    this.isLabelCenter = false,
    this.readOnly = false,
    this.showLabel = false,
    this.borderRadius,
    this.textInputType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.suffixWidget,
    this.prefixWidget,
    this.maxLength,
    this.textInputFormatters,
    this.togglePasswordVisibility,
    this.isFilled = false,
    this.obscureText = false,
    this.onChanged,
  });

  final String labelText;
  final bool isPassword;
  final bool obscureText;
  final String? Function(String?) validatorFunction;
  final TextEditingController? controller;
  // final Color textColor;
  final Color? textFieldBgColor;
  final bool isLabelCenter;
  final bool readOnly;
  final bool showLabel;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final int? maxLength;
  final List<TextInputFormatter>? textInputFormatters;
  final BorderRadius? borderRadius;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final bool isFilled;
  final VoidCallback? togglePasswordVisibility;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction ?? TextInputAction.next,
      keyboardType: textInputType,
      readOnly: readOnly,
      controller: controller,
      obscureText: obscureText,
      validator: validatorFunction,
      style: TextStyling.mediumRegular,
      cursorColor: AppColors.primary.withOpacity(0.5),
      maxLength: maxLength,
      inputFormatters: textInputFormatters,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      decoration: InputDecoration(
        counterText: '',
        prefixIcon: prefixWidget != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: prefixWidget,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: isFilled,
        fillColor: textFieldBgColor ?? AppColors.primary.withOpacity(0.5),
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: togglePasswordVisibility,
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
              )
            : suffixWidget,
        contentPadding: const EdgeInsets.only(left: 12, right: 12),
        floatingLabelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.black.withOpacity(0.5),
            ),
        floatingLabelBehavior: !showLabel ? FloatingLabelBehavior.never : null,
        label: isLabelCenter
            ? Center(
                child: Text(
                  labelText,
                  style: TextStyling.smallRegular.copyWith(
                    fontSize: 13.sp,
                    color: AppColors.grey,
                  ),
                ),
              )
            : Text(
                labelText,
                style: TextStyling.smallRegular.copyWith(
                  fontSize: 13.sp,
                  color: AppColors.grey,
                ),
              ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.red,
          ),
          borderRadius: borderRadius ??
              const BorderRadius.all(
                Radius.circular(8),
              ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.red,
          ),
          borderRadius: borderRadius ??
              const BorderRadius.all(
                Radius.circular(8),
              ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.5),
          ),
          borderRadius: borderRadius ??
              const BorderRadius.all(
                Radius.circular(8),
              ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.5),
          ),
          borderRadius: borderRadius ??
              const BorderRadius.all(
                Radius.circular(8),
              ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.5),
          ),
          borderRadius: borderRadius ??
              const BorderRadius.all(
                Radius.circular(8),
              ),
        ),
      ),
    );
  }
}

```

### `src/shared/custom_phone_number_field.dart`

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:phone_auth_twillio/src/base/utils/utils.dart';
import 'package:phone_auth_twillio/src/styles/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:phone_auth_twillio/src/styles/text_theme.dart';

class CustomPhoneNumberField extends StatelessWidget {
  const CustomPhoneNumberField({
    super.key,
    required this.controller,
    this.initialCountryCodeOrPrefix = "PK",
    this.onChanged,
  });

  final TextEditingController controller;
  final String initialCountryCodeOrPrefix;
  final void Function(PhoneNumber)? onChanged;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      onChanged: onChanged,
      textAlign: TextAlign.left,
      dropdownIconPosition: IconPosition.leading,
      decoration: InputDecoration(
        counterText: '',
        // contentPadding: const EdgeInsets.only(
        //   left: 12,
        //   right: 12,
        // ),
        contentPadding: EdgeInsets.zero,
        isDense: false,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.red,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.red,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.5),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.5),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.5),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        hintText: 'xxxxxxx',
        hintStyle: TextStyling.mediumRegular
            .copyWith(color: AppColors.lightGrey, fontSize: 14.sp),
      ),
      initialCountryCode: initialCountryCodeOrPrefix,
      style: TextStyling.mediumRegular,
      controller: controller,
      textInputAction: TextInputAction.next,
      dropdownTextStyle: TextStyling.mediumRegular,
      textAlignVertical: TextAlignVertical.center,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (phone) {
        print('validator called: ${phone?.number}');
        print('validator called: ${phone?.completeNumber}');

        return ValidationUtils.validateMobile(phone?.number);
      },
    );
  }
}

```

### `src/shared/loading_indicator.dart`

```dart
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;
  final double? value;

  const LoadingIndicator({
    Key? key,
    this.size = 30,
    this.strokeWidth = 3,
    this.color = Colors.black,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}

```

### `src/shared/main_button.dart`

```dart
import 'package:phone_auth_twillio/src/styles/app_colors.dart';
import 'package:phone_auth_twillio/src/styles/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainButton extends StatelessWidget {
  final String buttonText;
  final Color buttonFontColor;
  final VoidCallback onPressed;
  final bool fullWidth;
  final bool isLoading;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final double? fontSize;
  final BorderRadius? borderRadius;
  final Color? buttonColor;
  const MainButton({
    Key? key,
    required this.buttonText,
    this.buttonFontColor = Colors.black,
    required this.onPressed,
    this.fullWidth = true,
    required this.isLoading,
    this.height,
    this.width,
    this.padding,
    this.fontSize,
    this.borderRadius,
    this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50.h,
      width: fullWidth ? double.infinity : width,
      decoration: BoxDecoration(
        color: buttonColor ?? AppColors.primary,
        borderRadius: borderRadius ?? BorderRadius.circular(10.r),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(3),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(10.r),
            ),
          ),
          padding: MaterialStatePropertyAll(
            padding ?? EdgeInsets.symmetric(vertical: 10.h, horizontal: 24.w),
          ),
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: isLoading
            ? Padding(
                padding: const EdgeInsets.all(4.0),
                child: Transform.scale(
                  scale: 0.6,
                  child: CircularProgressIndicator(
                    color: buttonFontColor,
                  ),
                ),
              )
            : Text(
                buttonText,
                style: TextStyling.mediumBold.copyWith(
                  fontSize: fontSize ?? 16.sp,
                  color: buttonFontColor,
                ),
              ),
      ),
    );
  }
}

```

### `src/shared/spacing.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class VerticalSpacing extends SizedBox {
  const VerticalSpacing([double height = 8, Key? key])
      : super(key: key, height: height);
}

class HorizontalSpacing extends SizedBox {
  const HorizontalSpacing([double width = 8, Key? key])
      : super(key: key, width: width);
}

```

### `src/shared/text_field_heading.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_auth_twillio/src/styles/app_colors.dart';
import 'package:phone_auth_twillio/src/styles/text_theme.dart';

class TextFieldHeading extends StatelessWidget {
  const TextFieldHeading({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 2.w),
      child: Text(
        label,
        style: TextStyling.smallBold.copyWith(
          color: AppColors.grey,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}

```

### `src/styles/app_colors.dart`

```dart
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColors {
  AppColors._();

  //FOR DIALOGS
  static Color success = HexColor("#64EDB2");
  static Color error = HexColor("#FF5757");
  // static Color warning = HexColor("#bf9b30");
  static Color warning = HexColor("#FFD643");

  static HexColor primary = HexColor("#e87b7b"); //app primary
  static HexColor secondary = HexColor("#a06fdb");

  static HexColor grey = HexColor("#949494");
  static HexColor lightGrey = HexColor("#D9D9D9");
  static HexColor darkGrey = HexColor("#474747");
  static HexColor black = HexColor("#000000");
  static HexColor white = HexColor("#ffffff");
  static HexColor peach = HexColor("#FCEFDA");
  static HexColor yellow = HexColor("#FFDB45");
  static HexColor purple = HexColor("#743FA9");
  static HexColor green = HexColor("#41BD6F");
  static HexColor red = HexColor("#BD0000");
}

```

### `src/styles/text_theme.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phone_auth_twillio/src/styles/app_colors.dart';

class TextStyling {
  TextStyling._();

  static TextStyle extraLargeBold = GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 26.sp,
    color: AppColors.black,
  );
  static TextStyle extraLargeRegular = GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
    fontSize: 26.sp,
    color: AppColors.black,
  );
  static TextStyle large2Bold = GoogleFonts.poppins(
      fontWeight: FontWeight.w600, fontSize: 24.sp, color: AppColors.black);
  static TextStyle large2Regular = GoogleFonts.poppins(
      fontWeight: FontWeight.w500, fontSize: 24.sp, color: AppColors.black);
  static TextStyle largeBold = GoogleFonts.poppins(
      fontWeight: FontWeight.w600, fontSize: 20.sp, color: AppColors.black);
  static TextStyle largeRegular = GoogleFonts.poppins(
      fontWeight: FontWeight.w500, fontSize: 20.sp, color: AppColors.black);
  static TextStyle mediumBold = GoogleFonts.poppins(
      fontWeight: FontWeight.w600, fontSize: 16.sp, color: AppColors.black);
  static TextStyle mediumRegular = GoogleFonts.poppins(
      fontWeight: FontWeight.w500, fontSize: 16.sp, color: AppColors.black);
  static TextStyle smallBold = GoogleFonts.poppins(
      fontWeight: FontWeight.w600, fontSize: 12.sp, color: AppColors.black);
  static TextStyle smallRegular = GoogleFonts.poppins(
      fontWeight: FontWeight.w500, fontSize: 12.sp, color: AppColors.black);
  static TextStyle extraSmallBold = GoogleFonts.poppins(
      fontWeight: FontWeight.w600, fontSize: 8.sp, color: AppColors.black);
  static TextStyle extraSmallRegular = GoogleFonts.poppins(
      fontWeight: FontWeight.w400, fontSize: 8.sp, color: AppColors.black);
}

```

### `src/views/home/home_view_model.dart`

```dart
import 'package:phone_auth_twillio/src/services/local/navigation_service.dart';
import 'package:phone_auth_twillio/src/services/remote/base/supabase_auth_view_model.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends ReactiveViewModel with SupabaseAuthViewModel {
  init() {}

  onClickLogout() async {
    setBusy(true);
    await supabaseAuthService.logout();
    setBusy(false);
    NavService.login();
  }
}

```

### `src/views/home/home_view.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_auth_twillio/src/shared/main_button.dart';
import 'package:phone_auth_twillio/src/shared/spacing.dart';
import 'package:phone_auth_twillio/src/styles/text_theme.dart';
import 'package:stacked/stacked.dart';

import 'home_view_model.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel model, Widget? child) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 16.h,
        ),
        child: Column(
          children: [
            VerticalSpacing(20.h),
            Center(
              child: Text(
                'Home Screen',
                style: TextStyling.largeRegular,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Name: ',
                        style: TextStyling.mediumRegular,
                      ),
                      Text(
                        model.supabaseAuthService.user?.name ?? '',
                        style: TextStyling.mediumBold,
                      ),
                    ],
                  ),
                  VerticalSpacing(20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Phone: ',
                        style: TextStyling.mediumRegular,
                      ),
                      Text(
                        model.supabaseAuthService.user?.phone ?? '',
                        style: TextStyling.mediumBold,
                      ),
                    ],
                  ),
                  VerticalSpacing(20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Email: ',
                        style: TextStyling.mediumRegular,
                      ),
                      Text(
                        model.supabaseAuthService.user?.email ?? '',
                        style: TextStyling.mediumBold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            MainButton(
              buttonText: 'Logout',
              onPressed: model.onClickLogout,
              isLoading: model.isBusy,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel model) => model.init();
}

```

### `src/views/login/login_view_model.dart`

```dart
import 'package:phone_auth_twillio/src/base/enums/verification_mode.dart';
import 'package:phone_auth_twillio/src/base/utils/constants.dart';
import 'package:phone_auth_twillio/src/configs/app_setup.router.dart';
import 'package:phone_auth_twillio/src/services/local/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth_twillio/src/services/remote/base/supabase_auth_view_model.dart';
import 'package:phone_auth_twillio/src/services/remote/supabase_auth_service.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends ReactiveViewModel with SupabaseAuthViewModel {
  init() {}

  // final TextEditingController email = TextEditingController();

  final initialCountryCodeOrPrefix = "PK";
  String phone = '';
  // final TextEditingController password = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  onClickLogin() async {
    if (phone.isNotEmpty && phoneController.text.length > 4) {
      setBusy(true);
      try {
        bool didLogin = await supabaseAuthService.login(
          phone,
        );

        if (didLogin) {
          Constants.customSuccessSnack(
            'Please enter the code sent to $phone to login!',
          );
          setBusy(false);
          NavService.navigateToverifyOtp(
            arguments: VerifyOtpViewArguments(
              phone: phone,
              mode: VerificationMode.login,
              email: null,
              name: null,
            ),
          );
        }
        // NavService.navigateToverifyOtp(
        //   arguments: VerifyOtpViewArguments(
        //     phone: phone,
        //     mode: VerificationMode.login,
        //     email: null,
        //     name: null,
        //     isCustomer: null,
        //   ),
        // );
        setBusy(false);
      } on AuthExcepection catch (e) {
        setBusy(false);
        print(e);
        Constants.customErrorSnack(e.message);
      } on CustomNoInternetException catch (e) {
        print(e.message);
        Constants.customErrorSnack(e.message);
        setBusy(false);
      } catch (e) {
        setBusy(false);
        print(e);
        Constants.customErrorSnack(e.toString());
      }
    } else {
      print('not validated');
    }
    // NavService.navigateToProfile();
    // if (formKey.currentState!.validate()) {
    //   setBusy(true);
    //   try {
    //     AppUser? user = await supabaseAuthService.login(
    //       email.text.trim(),
    //       password.text.trim(),
    //     );

    //     if (user != null && supabaseAuthService.userLoggedIn) {
    //       Constants.customSuccessSnack('Welcome back, ${user.name}!');
    //       setBusy(false);
    //       NavService.customerDashboard();
    //     }
    //     setBusy(false);
    //   } on AuthExcepection catch (e) {
    //     setBusy(false);
    //     print(e);
    //     Constants.customErrorSnack(e.message);
    //   } on CustomNoInternetException catch (e) {
    //     print(e.message);
    //     Constants.customErrorSnack(e.message);
    //     setBusy(false);
    //   } catch (e) {
    //     setBusy(false);
    //     print(e);
    //     Constants.customErrorSnack(e.toString());
    //   }
    // }
  }

  onClickRegister() {
    // NavService.selectRole();
    NavService.register();
  }

  bool hidePassword = true;
  toggleObscureText() {
    hidePassword = !hidePassword;
    notifyListeners();
  }
}

```

### `src/views/login/login_view.dart`

```dart
import 'package:phone_auth_twillio/src/shared/custom_app_bar.dart';
import 'package:phone_auth_twillio/src/shared/custom_phone_number_field.dart';
import 'package:phone_auth_twillio/src/shared/main_button.dart';
import 'package:phone_auth_twillio/src/shared/spacing.dart';
import 'package:phone_auth_twillio/src/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_auth_twillio/src/styles/text_theme.dart';
import 'package:stacked/stacked.dart';
import 'package:phone_auth_twillio/src/base/utils/utils.dart';

import 'login_view_model.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(BuildContext context, LoginViewModel model, Widget? child) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: context.screenSize().width,
        height: context.screenSize().height,
        child: Form(
          key: model.formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 10.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // VerticalSpacing(100.h),
                const CustomAppBar(
                  titleText: 'Login',
                  showBackButton: false,
                ),
                const Spacer(),
                CustomPhoneNumberField(
                  controller: model.phoneController,
                  initialCountryCodeOrPrefix: model.initialCountryCodeOrPrefix,
                  onChanged: (phonenumber) {
                    // model.initialCountryCodeOrPrefix = phonenumber.;
                    model.phone = phonenumber.completeNumber;
                    print(model.phone);
                  },
                ),
                VerticalSpacing(40.h),
                MainButton(
                  buttonText: 'Login',
                  onPressed: model.onClickLogin,
                  isLoading: model.isBusy,
                  buttonFontColor: AppColors.white,
                ),
                // VerticalSpacing(80.h),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyling.mediumRegular,
                    ),
                    TextButton(
                      onPressed: model.onClickRegister,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        "Register",
                        style: TextStyling.mediumBold,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();

  @override
  void onViewModelReady(LoginViewModel model) => model.init();
}

```

### `src/views/register/register_view_model.dart`

```dart
import 'package:phone_auth_twillio/src/base/enums/verification_mode.dart';
import 'package:phone_auth_twillio/src/base/utils/constants.dart';
import 'package:phone_auth_twillio/src/configs/app_setup.router.dart';
import 'package:phone_auth_twillio/src/services/local/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth_twillio/src/services/remote/base/supabase_auth_view_model.dart';
import 'package:phone_auth_twillio/src/services/remote/supabase_auth_service.dart';
import 'package:stacked/stacked.dart';

class RegisterViewModel extends ReactiveViewModel with SupabaseAuthViewModel {
  init() {}

  final initialCountryCodeOrPrefix = "PK";
  String phone = '';

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  onClickLogin() {
    NavService.login();
  }

  onClickRegister() async {
    if (formKey.currentState!.validate() &&
        phone.isNotEmpty &&
        phoneController.text.length > 4) {
      setBusy(true);
      try {
        final response = await supabaseAuthService.register(phone, email.text);
        setBusy(false);

        if (response) {
          NavService.navigateToverifyOtp(
            arguments: VerifyOtpViewArguments(
              phone: phone,
              mode: VerificationMode.register,
              email: email.text,
              name: name.text,
            ),
          );
        }
      } on AuthExcepection catch (e) {
        Constants.customErrorSnack(e.message);

        setBusy(false);
        return;
      } on CustomNoInternetException catch (e) {
        Constants.customErrorSnack(e.message);
        setBusy(false);
        return;
      } catch (e) {
        setBusy(false);
        Constants.customErrorSnack(e.toString());
        return;
      }
    }
  }
}

```

### `src/views/register/register_view.dart`

```dart
import 'package:phone_auth_twillio/src/shared/custom_app_bar.dart';
import 'package:phone_auth_twillio/src/shared/custom_form_field.dart';
import 'package:phone_auth_twillio/src/shared/custom_phone_number_field.dart';
import 'package:phone_auth_twillio/src/shared/main_button.dart';
import 'package:phone_auth_twillio/src/shared/spacing.dart';
import 'package:phone_auth_twillio/src/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_auth_twillio/src/styles/text_theme.dart';
import 'package:stacked/stacked.dart';
import 'package:phone_auth_twillio/src/base/utils/utils.dart';

import 'register_view_model.dart';

class RegisterView extends StackedView<RegisterViewModel> {
  const RegisterView({super.key});

  @override
  Widget builder(BuildContext context, RegisterViewModel model, Widget? child) {
    return Scaffold(
      body: SizedBox(
        width: context.screenSize().width,
        height: context.screenSize().height,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 10.h,
          ),
          child: Form(
            key: model.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomAppBar(
                  titleText: 'Create an account',
                  showBackButton: false,
                ),

                VerticalSpacing(40.h),
                CustomFormField(
                  labelText: 'Name',
                  validatorFunction: (c) {
                    return ValidationUtils.validateName(c);
                  },
                  prefixWidget: const Icon(Icons.person),
                  controller: model.name,
                ),
                VerticalSpacing(25.h),
                // CustomFormField(
                //   labelText: 'Phone',
                //   validatorFunction: (c) {
                //     return ValidationUtils.validateMobile(c);
                //   },
                //   showLabel: false,
                //   prefixWidget: const Icon(Icons.phone),
                //   controller: model.phone,
                // ),
                CustomPhoneNumberField(
                  controller: model.phoneController,
                  initialCountryCodeOrPrefix: model.initialCountryCodeOrPrefix,
                  onChanged: (phonenumber) {
                    // model.initialCountryCodeOrPrefix = phonenumber.;
                    model.phone = phonenumber.completeNumber;
                    print(model.phone);
                  },
                ),

                VerticalSpacing(25.h),
                CustomFormField(
                  labelText: 'Email',
                  validatorFunction: (c) {
                    return ValidationUtils.validateEmail(c);
                  },
                  prefixWidget: const Icon(Icons.email),
                  controller: model.email,
                ),
                VerticalSpacing(80.h),
                MainButton(
                  buttonText: 'Register',
                  onPressed: model.onClickRegister,
                  isLoading: model.isBusy,
                  buttonFontColor: AppColors.white,
                ),
                VerticalSpacing(80.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyling.mediumRegular,
                    ),
                    TextButton(
                      onPressed: model.onClickLogin,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        // minimumSize: Size.zero,
                      ),
                      child: Text(
                        "Login",
                        style: TextStyling.mediumBold,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  RegisterViewModel viewModelBuilder(BuildContext context) =>
      RegisterViewModel();

  @override
  void onViewModelReady(RegisterViewModel model) => model.init();
}

```

### `src/views/splash/splash_view_model.dart`

```dart
import 'package:phone_auth_twillio/src/services/local/navigation_service.dart';
import 'package:phone_auth_twillio/src/services/remote/base/supabase_auth_view_model.dart';
import 'package:stacked/stacked.dart';

class SplashViewModel extends ReactiveViewModel with SupabaseAuthViewModel {
  init() {
    Future.delayed(
      const Duration(milliseconds: 1200),
      () {
        if (supabaseAuthService.userLoggedIn) {
          NavService.home();
        } else {
          NavService.login();
        }
      },
    );
  }
}

```

### `src/views/splash/splash_view.dart`

```dart
import 'package:flutter/material.dart';
import 'package:phone_auth_twillio/src/shared/loading_indicator.dart';
import 'package:stacked/stacked.dart';

import 'splash_view_model.dart';

class SplashView extends StackedView<SplashViewModel> {
  const SplashView({super.key});

  @override
  Widget builder(BuildContext context, SplashViewModel model, Widget? child) {
    return const Scaffold(
      body: Center(
        child: LoadingIndicator(),
      ),
    );
  }

  @override
  SplashViewModel viewModelBuilder(BuildContext context) => SplashViewModel();

  @override
  void onViewModelReady(SplashViewModel model) => model.init();
}

```

### `src/views/verify_otp/verify_otp_view_model.dart`

```dart
import 'package:flutter/material.dart';
import 'package:phone_auth_twillio/src/base/utils/constants.dart';
import 'package:phone_auth_twillio/src/services/remote/supabase_auth_service.dart';
import 'package:stacked/stacked.dart';

import 'package:phone_auth_twillio/src/base/enums/verification_mode.dart';
import 'package:phone_auth_twillio/src/services/local/navigation_service.dart';
import 'package:phone_auth_twillio/src/services/remote/base/supabase_auth_view_model.dart';

class VerifyOtpViewModel extends ReactiveViewModel with SupabaseAuthViewModel {
  final VerificationMode mode;
  final String phone;
  final String? email;
  final String? name;

  VerifyOtpViewModel({
    required this.mode,
    required this.phone,
    required this.email,
    required this.name,
  });

  final otpController = TextEditingController();

  init() {}

  onClickVerifyOTP() async {
    if (otpController.text.length >= 6) {
      if (mode == VerificationMode.login) {
        onLoginVerify();
      } else if (mode == VerificationMode.register) {
        onRegisterVerify();
      }
    }
  }

  onRegisterVerify() async {
    setBusy(true);
    try {
      final response = await supabaseAuthService.verifyPhoneNumberAndRegister(
        email: email ?? '',
        name: name ?? '',
        phone: phone,
        otp: otpController.text,
      );

      if (response == null) {
        Constants.customWarningSnack('Error registering the user');
        setBusy(false);
        return;
      }
      setBusy(false);
      Constants.customSuccessSnack('Welcome ${response.name}');
      _navigateToDashboard();
    } on CustomNoInternetException catch (e) {
      Constants.customErrorSnack(e.message);
      setBusy(false);
    } on AuthExcepection catch (e) {
      Constants.customErrorSnack(e.message);
      setBusy(false);
    } catch (e) {
      Constants.customErrorSnack(e.toString());
      setBusy(false);
    }
  }

  onLoginVerify() async {
    setBusy(true);
    try {
      final response = await supabaseAuthService.verifyPhoneNumberAndLogin(
        phone: phone,
        otp: otpController.text,
      );

      if (response == null) {
        Constants.customWarningSnack('Error logging in the user');
        setBusy(false);
        return;
      }
      setBusy(false);
      Constants.customSuccessSnack('Welcome ${response.name}');
      _navigateToDashboard();
    } on CustomNoInternetException catch (e) {
      setBusy(false);
      Constants.customErrorSnack(e.message);
    } on AuthExcepection catch (e) {
      setBusy(false);
      Constants.customErrorSnack(e.message);
    } catch (e) {
      setBusy(false);
      Constants.customErrorSnack(e.toString());
    }
  }

  void _navigateToDashboard() {
    NavService.home();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }
}

```

### `src/views/verify_otp/verify_otp_view.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_auth_twillio/src/base/enums/verification_mode.dart';
import 'package:phone_auth_twillio/src/shared/custom_app_bar.dart';

import 'package:phone_auth_twillio/src/shared/main_button.dart';
import 'package:phone_auth_twillio/src/shared/spacing.dart';
import 'package:phone_auth_twillio/src/styles/text_theme.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stacked/stacked.dart';
import 'package:phone_auth_twillio/src/styles/app_colors.dart';

import 'verify_otp_view_model.dart';

class VerifyOtpView extends StackedView<VerifyOtpViewModel> {
  const VerifyOtpView({
    super.key,
    required this.phone,
    required this.mode,
    required this.email,
    required this.name,
  });

  final String phone;
  final VerificationMode mode;
  final String? email;
  final String? name;

  @override
  Widget builder(
      BuildContext context, VerifyOtpViewModel model, Widget? child) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
            titleText: 'Verify OTP',
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalSpacing(40.h),
                  Text(
                    'Verify your account',
                    style: TextStyling.mediumBold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  VerticalSpacing(10.h),
                  Text(
                    'We have sent a verification code to your phone number $phone, please enter code here',
                    style: TextStyling.smallRegular.copyWith(),
                  ),
                  VerticalSpacing(40.h),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: PinCodeTextField(
                        backgroundColor: AppColors.white,
                        cursorColor: AppColors.primary,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10.r),
                          fieldHeight: 55.h,
                          fieldWidth: 50.w,
                          activeColor: AppColors.primary,
                          activeFillColor: AppColors.primary,
                          selectedColor: AppColors.primary,
                          inactiveColor: AppColors.lightGrey,
                          inactiveFillColor: AppColors.black,
                        ),
                        textStyle: TextStyling.mediumBold.copyWith(
                          color: AppColors.black,
                        ),
                        appContext: context,
                        length: 6,
                        onChanged: (value) {},
                        controller: model.otpController,
                        autovalidateMode: AutovalidateMode.always,
                      ),
                    ),
                  ),
                  Spacer(),
                  MainButton(
                    onPressed: model.onClickVerifyOTP,
                    isLoading: model.isBusy,
                    buttonText: 'Verify',
                  ),
                  VerticalSpacing(40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  VerifyOtpViewModel viewModelBuilder(BuildContext context) =>
      VerifyOtpViewModel(
        mode: mode,
        phone: phone,
        email: email,
        name: name,
      );

  @override
  void onViewModelReady(VerifyOtpViewModel model) => model.init();
}

```
