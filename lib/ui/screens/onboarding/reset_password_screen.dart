import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liftshare/ui/screens/onboarding/welcome_screen.dart';
import 'package:liftshare/ui/widgets/default_app_bar.dart';

import '../../../services/authentication_service.dart';
import '../../../utils/constants.dart';
import '../../widgets/app_background.dart';
import '../../widgets/back_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: defaultAppBar(context, "Reset Password"),
          body: DecoratedBox(
            decoration: appBackground(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppValues.screenPadding, AppValues.screenPadding,
                  AppValues.screenPadding, 0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Container(
                        height: 60,
                        width: 60,
                        padding: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                          gradient: AppColors.gradientBackground,
                          borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius)),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius - 3)),
                            color: AppColors.buttonColor,
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/icons/padlock_icon.svg',
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Enter your email address and we will send a link to reset your password.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.highlightColor,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                            fontFamily: 'Aeonik',
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [

                              _emailTextField(emailController),
                              const SizedBox(height: 15),
                            ],
                          )
                      ),
                      const SizedBox(height: 12),
                      const Divider(
                        thickness: 1,
                        color: AppColors.highlightColor,
                      ),
                      const SizedBox(height: 12),
                      _resetPasswordButton(context),
                    ],
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }

  Widget _emailTextField(controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        filled: true,
        fillColor: AppColors.buttonColor,
        labelStyle: const TextStyle(
          color: AppColors.highlightColor,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
          fontFamily: 'Aeonik',
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.enabledBorderColor,
              width: 1.5,
            ),
            borderRadius: const BorderRadius.all(
                Radius.circular(AppValues.largeBorderRadius)
            )
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1.5,
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(AppValues.largeBorderRadius)
            )
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.none,
        fontFamily: 'Aeonik',
      ),
    );
  }

  Widget _resetPasswordButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await FirebaseAuthService().resetPassword(emailController.text);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WelcomeScreen())
        );
      },
      child: Container(
          height: 60,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius)),
          ),
          child: const Center(
            child: Text(
              'Reset',
              style: TextStyle(
                color: AppColors.backgroundColor,
                fontSize: 20,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold,
                fontFamily: 'Aeonik',
              ),
            ),
          )
      ),
    );
  }
}

