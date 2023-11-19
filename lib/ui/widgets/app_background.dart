import 'dart:ui';

import 'package:flutter/material.dart';

import '../../utils/constants.dart';

Widget appBackground() {
  return Stack(
    children: [
      // Background Image
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/app_background.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      // Blur Layer
      Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColors.backgroundColor.withOpacity(0.6),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
    ],
  );
}