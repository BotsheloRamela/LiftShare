import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liftshare/services/authentication_service.dart';
import 'package:liftshare/ui/screens/onboarding/reset_password_screen.dart';
import 'package:liftshare/ui/screens/onboarding/welcome_screen.dart';
import 'package:liftshare/ui/widgets/default_app_bar.dart';
import 'package:liftshare/ui/widgets/user_icon.dart';
import 'package:provider/provider.dart';

import '../../../data/models/app_user.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/constants.dart';
import '../../widgets/app_background.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AppUser _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _user = (userProvider.user)!;
    });
  }

  @override
  Widget build(BuildContext context) {

    FirebaseAuthService _authService = FirebaseAuthService();

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: defaultAppBar(context, "Profile"),
        body: DecoratedBox(
          decoration: appBackground(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppValues.screenPadding, AppValues.screenPadding,
                AppValues.screenPadding, 0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                userIcon(_user.photoURL, 160),
                const SizedBox(height: 40),
                Text(
                  _user.displayName ?? "Unknown",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontFamily: 'Aeonik',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _user.email ?? "email",
                  style: const TextStyle(
                    color: AppColors.highlightColor,
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: 'Aeonik',
                  ),
                ),
                const Spacer(),
                // Logout Button
                GestureDetector(
                  onTap: () async {
                    await _authService.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const WelcomeScreen())
                    );
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
                      border: Border.all(
                        color: AppColors.enabledBorderColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/logout_icon.svg",
                          color: Colors.white,
                          height: 20,
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                            fontFamily: 'Aeonik',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Reset Password Button
                GestureDetector(
                  onTap: () async {
                    await _authService.resetPassword(_user.email!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ResetPasswordScreen())
                    );
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
                      border: Border.all(
                        color: AppColors.enabledBorderColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/reset_password_icon.svg",
                          color: Colors.white,
                          height: 20,
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          "Reset Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                            fontFamily: 'Aeonik',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Delete Account Button
                GestureDetector(
                  onTap: () async {
                    await _authService.deleteUser();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const WelcomeScreen())
                    );
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
                      border: Border.all(
                        color: AppColors.enabledBorderColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/delete_icon.svg",
                          color: AppColors.warningColor,
                          height: 20,
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          "Delete Account",
                          style: TextStyle(
                            color: AppColors.warningColor,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                            fontFamily: 'Aeonik',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
