import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'firebase_options.dart';

import 'package:silviamaharjan_2408228_fyp/src/core/services/deep_link_service.dart';
import 'package:silviamaharjan_2408228_fyp/src/features/user_management/reset_password_screen.dart';

import 'src/core/theme/theme.dart';
import 'src/core/theme/themecontroller.dart';
import 'src/common_widgets/main_navigation_shell.dart';
import 'src/features/user_management/welcomepage_screen.dart';

final ThemeController themeController = ThemeController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  tz.initializeTimeZones();
  await dotenv.load(fileName: ".env");

  // Existing Theme Listener
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((doc) {
      final data = doc.data();
      final isDark = data?['isDarkMode'] ?? false;
      themeController.setDarkMode(isDark);
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  final DeepLinkService _deepLinkService =
      DeepLinkService.instance;

  @override
  void initState() {
    super.initState();

    _deepLinkService.init(navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return
          MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'SAKHI',

          theme: getAppTheme(Brightness.light),
          darkTheme: getAppTheme(Brightness.dark),
          themeMode: themeController.themeMode,

          initialRoute: '/',

          routes: {
            '/': (context) => const WelcomePage(),
            '/main': (context) => const MainNavigationShell(),

          },
        );
      },
    );
  }
}
