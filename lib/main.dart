
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:liftshare/data/models/app_user.dart';
import 'package:liftshare/providers/user_provider.dart';
import 'package:liftshare/ui/screens/main_screen.dart';
import 'package:liftshare/ui/screens/onboarding/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      if (event != null) {
        // User is signed in
        UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

        AppUser user = AppUser(
          uid: event.uid,
          displayName: event.displayName,
          email: event.email,
          photoURL: event.photoURL,
        );

        userProvider.setUser(user);
      } else {
        // User is signed out
        Provider.of<UserProvider>(context, listen: false).clearUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'LiftShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Aeonik'),
      home: Provider.of<UserProvider>(context).user != null
          ? MainScreen()
          : const WelcomeScreen(),
    );
  }
}
