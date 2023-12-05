
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

Widget mapsNavigateButton() {
  return Container(
      width: 50,
      alignment: Alignment.center,
      height: 50,
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
        child: const Icon(
          Icons.directions,
          color: Colors.white,
          size: 30,
        ),
      )
  );
}