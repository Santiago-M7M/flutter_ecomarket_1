import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_ecomarket_1/core/routes.dart';
import 'package:flutter_ecomarket_1/screens/screen_splash.dart';
import 'package:flutter_ecomarket_1/screens/screen_home.dart';
import 'package:flutter_ecomarket_1/screens/screen_register.dart';
import 'package:flutter_ecomarket_1/screens/screen_hompage.dart';
import 'package:flutter_ecomarket_1/screens/screen_login.dart';
import 'core/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Appstrings.appName,

      initialRoute: Routes.splash,
      routes: {
        Routes.splash: (context) => const Splashscreen(),
        Routes.home: (context) => const HomeScreen(),
        Routes.register: (context) => const RegisterScreen(),
        Routes.login: (context) => const ScreenLogin(),
        Routes.homePage: (context) => ScreenHompage(),
      },
    );
  }
}
