import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liftshare/utils/constants.dart';

import '../../widgets/app_background.dart';
import '../../widgets/back_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = true;
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'Log In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
              fontFamily: 'Aeonik',
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: backButton(context),
        ),
        body: Stack(
          children: [
            appBackground(),
            Padding(
              padding: const EdgeInsets.all(AppValues.screenPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 90),
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
                        'assets/icons/mail_icon.svg',
                        height: 30,
                        width: 30,
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

                          TextFormField(
                            obscureText: _isPasswordVisible,
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              filled: true,
                              fillColor: AppColors.buttonColor,
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                                fontFamily: 'Aeonik',
                              ),

                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons
                                      .visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),

                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.highlightColor,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          AppValues.largeBorderRadius)
                                  )
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          AppValues.largeBorderRadius)
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
                          )
                        ],
                      )
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Navigate to Forgot Password Screen
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Aeonik',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                    thickness: 1,
                    color: AppColors.highlightColor,
                  ),
                  const SizedBox(height: 12),
                  _logInButton(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _emailTextField(controller) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.emailAddress,
    decoration: const InputDecoration(
      labelText: 'Email',
      filled: true,
      fillColor: AppColors.buttonColor,
      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.none,
        fontFamily: 'Aeonik',
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.highlightColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.all(
            Radius.circular(AppValues.largeBorderRadius)
        )
      ),
      focusedBorder: OutlineInputBorder(
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

Widget _logInButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      // TODO: Call Log In Function
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
            'Log In',
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
