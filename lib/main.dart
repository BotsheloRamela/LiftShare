import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:liftshare/ui/screens/get_a_lift/home_screen.dart';
import 'package:liftshare/ui/screens/onboarding/welcome_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'LiftShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Aeonik'),
      home: _user != null ? const GetALiftHomeScreen() : const WelcomeScreen(),
    );
  }
}
