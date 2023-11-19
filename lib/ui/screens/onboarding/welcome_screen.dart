import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liftshare/ui/widgets/app_background.dart';
import 'package:liftshare/utils/constants.dart';
import 'package:text_divider/text_divider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        appBackground(),
        Padding(
          padding: const EdgeInsets.all(25),
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
              _socialsSignInButtons(),
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
              _signInWithEmailButton(),
              const Spacer(),
              _signUpTextWidget(),
            ],
          ),
        )
      ],
    );
  }
}

Widget _socialsSignInButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Google Button
      GestureDetector(
        onTap: () {
          // TODO: Call Google Sign In Function
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

Widget _signInWithEmailButton() {
  return GestureDetector(
    onTap: () {
      // TODO: Navigate to Sign In Screen
    },
    child: Container(
      height: 60,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.gradientBackground,
        borderRadius: BorderRadius.all(Radius.circular(13)),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: AppColors.backgroundColor,
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

Widget _signUpTextWidget() {
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
              // TODO: Navigate to Sign Up Screen
            },
        ),
      ]
    )
  );
}