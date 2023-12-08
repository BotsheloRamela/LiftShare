import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liftshare/ui/screens/main_screen.dart';
import 'package:liftshare/ui/screens/onboarding/reset_password_screen.dart';
import 'package:liftshare/utils/constants.dart';

import '../../../services/authentication_service.dart';
import '../../widgets/app_background.dart';
import '../../widgets/back_button.dart';
import '../get_a_lift/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      User? user = await _firebaseAuthService.signInWithEmailAndPassword(email, password);

      if (user != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainScreen())
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to sign in.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch(e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
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
                            _emailTextField(_emailController),

                            const SizedBox(height: 15),

                            TextFormField(
                              obscureText: _isPasswordVisible,
                              controller: _passwordController,
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ResetPasswordScreen())
                          );
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
                    GestureDetector(
                      onTap: () {_signIn();},
                      child: _logInButton()
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
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

Widget _logInButton() {
  return Container(
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
  );
}
