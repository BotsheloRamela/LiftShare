
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

Widget actionIconButton(Icon icon, double size) {
  return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
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
        child: icon,
      )
  );
}