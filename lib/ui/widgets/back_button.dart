import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/constants.dart';

Widget backButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
        height: 30,
        width: 30,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: AppColors.buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          'assets/icons/chevron_icon.svg',
          height: 140,
          width: 140,
        )
    ),
  );
}