import 'package:flutter/material.dart';

import 'src/features/user_management/welcomepage_screen.dart';
import 'src/features/user_management/login_screen.dart';
import 'src/features/user_management/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        // '/login': (context) => const LoginPage(),
        // '/signup': (context) => const SignupPage(),
      },
    );
  }
}
