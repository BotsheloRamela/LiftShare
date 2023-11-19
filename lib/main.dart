import 'package:flutter/material.dart';
import 'package:liftshare/ui/screens/onboarding/login_screen.dart';
import 'package:liftshare/ui/screens/onboarding/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiftShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Aeonik'),
      home: const WelcomeScreen(),
      // routes: {
      //   '/': (context) => const WelcomeScreen(),
      //   '/login': (context) => const LoginScreen(),
      // }
    );
  }
}
