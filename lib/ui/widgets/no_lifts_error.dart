
import 'package:flutter/cupertino.dart';
import 'package:liftshare/utils/enums.dart';
import 'package:lottie/lottie.dart';

import '../../utils/constants.dart';

Widget noLiftsFound(ErrorScreen errorScreen) {
  return Column(
    children: [
      Lottie.asset(
        'assets/animations/not_found.json',
        height: 150,
        width: 150,
        frameRate: FrameRate(60),
        fit: BoxFit.cover,
      ),
      const SizedBox(height: 20),
      Text(
        errorScreen == ErrorScreen.offerALift
            ? "No upcoming lifts"
            : (errorScreen == ErrorScreen.getALift
              ? "No Bookings or Lifts Available"
              : "No Activity"),
        style: const TextStyle(
          color: AppColors.highlightColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.none,
          fontFamily: 'Aeonik',
        ),
      ),
    ],
  );
}