import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/views/screens/login/login_screen.dart';
import 'package:rhino_bond/views/screens/login/login_controller.dart'
    as login_controller;
import 'package:rhino_bond/views/screens/register/register_screen.dart'
    as register_screen;
import 'package:rhino_bond/views/screens/register/register_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => login_controller.LoginController()),
        ChangeNotifierProvider(create: (_) => RegisterController()),
      ],
      child: MaterialApp(
        title: 'Rhino Bond',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/register': (context) => const register_screen.RegisterScreen(),
        },
      ),
    );
  }
}
