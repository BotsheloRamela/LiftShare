
import 'package:flutter/cupertino.dart';

import '../../utils/constants.dart';

Widget cancelButton(String buttonText, Function() onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      alignment: Alignment.center,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
        border: Border.all(
          color: AppColors.warningColor,
          width: 1,
        ),
        color: AppColors.buttonColor,
      ),
      child: const Text(
        "Cancel Lift",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.warningColor,
        ),
      ),
    ),
  );
}