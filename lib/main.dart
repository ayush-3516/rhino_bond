import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rhino_bond/l10n/localization.dart';
import 'package:rhino_bond/credentials/supabase.credentials.dart';
import 'package:rhino_bond/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/routes/app.routes.dart';
import 'package:rhino_bond/providers/app.providers.dart';
import 'package:rhino_bond/providers/theme_provider.dart';
import 'package:rhino_bond/providers/language_provider.dart';
import 'package:rhino_bond/utils/logger.dart';

final supabase = Supabase.instance.client;

class AppRoutes {
  static const String initialRoute = '/home';
  static const String verifyOtpRoute = '/verify_otp';
  static const String homeRoute = '/home';
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authNotifier = Provider.of<AuthenticationNotifier>(
        navigatorKey.currentContext!,
        listen: false,
      );
      authNotifier.startAuthListener();
    });
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...AppProviders.providers,
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  physics: const BouncingScrollPhysics(),
                ),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  navigatorKey: navigatorKey,
                  initialRoute: AppRoutes.initialRoute,
                  routes: routes,
                  theme: themeProvider.themeData,
                  localizationsDelegates: [
                    const AppLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('en'), // English
                    Locale('gu'), // Gujarati
                    Locale('hi'), // Hindi
                    Locale('mr'), // Marathi
                    Locale('pa'), // Punjabi
                  ],
                  locale: languageProvider.locale,
                  localeResolutionCallback: (locale, supportedLocales) {
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode ==
                          locale?.languageCode) {
                        return supportedLocale;
                      }
                    }
                    return supportedLocales.first;
                  },
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      builder: (context) => Scaffold(
                        body: Center(
                          child: Text(AppLocalizations.of(context).appTitle),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() async {
  try {
    await Supabase.initialize(
      url: SupabaseCredentials.url,
      anonKey: SupabaseCredentials.anonKey,
    );
    Logger.success("Supabase initialized successfully");
  } catch (e) {
    Logger.error("Error initializing Supabase: $e");
  }

  runApp(const App());
}
