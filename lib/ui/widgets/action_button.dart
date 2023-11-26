
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

Widget actionButton(String buttonText, Function() onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.all(1.3),
        decoration: const BoxDecoration(
          gradient: AppColors.gradientBackground,
          borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius + 3)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius + 3)),
            color: AppColors.buttonColor,
          ),
          child: Center(
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w500,
                fontFamily: 'Aeonik',
              ),
            ),
          ),
        )
    ),
  );
}