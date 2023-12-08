import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liftshare/ui/screens/main_screen.dart';
import 'package:liftshare/ui/screens/onboarding/create_account_screen.dart';
import 'package:liftshare/ui/widgets/app_background.dart';
import 'package:liftshare/utils/constants.dart';
import 'package:text_divider/text_divider.dart';

import '../../../services/authentication_service.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

    void _signInWithGoogle() async {

      try {
        User? user = await _firebaseAuthService.signInWithGoogle();

        if (user == null) {
          Fluttertoast.showToast(
            msg: 'Failed to sign in.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainScreen())
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }

    }

    return SafeArea(
      child: DecoratedBox(
        decoration: appBackground(),
        child: Padding(
          padding: const EdgeInsets.all(AppValues.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 90),
              SvgPicture.asset(
                'assets/icons/liftshare_logo.svg',
                height: 140,
                width: 140,
              ),
              const SizedBox(height: 60),
              const Text(
                'Log In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
              const SizedBox(height: 20),
              _socialsSignInButtons(_signInWithGoogle),
              const SizedBox(height: 40),
              TextDivider.horizontal(
                thickness: 1,
                color: AppColors.highlightColor,
                text: const Text('Or',
                  style: TextStyle(
                    color: AppColors.highlightColor,
                    fontSize: 16,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Aeonik',
                  ),
                )
              ),
              const SizedBox(height: 40),
              // Email Sign In Button
              _signInWithEmailButton(context),
              const Spacer(),
              _signUpTextWidget(context),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _socialsSignInButtons(signInWithGoogle) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Google Button
      GestureDetector(
        onTap: () {
          signInWithGoogle();
        },
        child: Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: AppColors.buttonColor,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: SvgPicture.asset(
            'assets/icons/google_logo.svg',
            height: 5,
            width: 5,
          ),
        ),
      ),
      const SizedBox(width: 20),
      // Apple Button
      Container(
        height: 60,
        width: 60,
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: AppColors.buttonColor,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: SvgPicture.asset(
          'assets/icons/apple_logo.svg',
          height: 5,
          width: 5,
        ),
      ),
    ],
  );
}

Widget _signInWithEmailButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen())
      );
    },
    child: Container(
      height: 60,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.gradientBackground,
        borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius)),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius - 1)),
          color: AppColors.buttonColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/mail_icon.svg',
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 10),
            const Text(
              'Continue with Email',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w500,
                fontFamily: 'Aeonik',
              ),
            ),
          ],
        ),
      )
    ),
  );
}

Widget _signUpTextWidget(BuildContext context) {
  return RichText(
    text: TextSpan(
      children: <TextSpan>[
        const TextSpan(
          text: 'Don\'t have an account? ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Aeonik',
          ),
        ),
        TextSpan(
          text: 'Sign Up',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Aeonik',
            fontWeight: FontWeight.bold,
            foreground: Paint()..shader = AppColors.gradientBackground
                .createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateAccountScreen())
              );
            },
        ),
      ]
    )
  );
}