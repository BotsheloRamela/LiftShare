
import 'package:flutter/material.dart';

class AppColors {
  static const Color gradientColor1 = Color(0xFF00E6FF);
  static const Color gradientColor2 = Color(0xFF1201FF);
  static const Color highlightColor = Color(0xFF858A94);
  static const Color backgroundColor = Color(0xFF011019);
  static const Color buttonColor = Color(0xFF141C27);
  static const Color warningColor = Color(0xFFFF3D00);
  static Color enabledBorderColor = highlightColor.withOpacity(0.5);

  static const LinearGradient gradientBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      gradientColor1,
      gradientColor2,
    ],
  );

  static LinearGradient lightGradientBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      gradientColor1.withOpacity(0.4),
      gradientColor2.withOpacity(0.4),
    ],
  );

  static LinearGradient cardGradientBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      buttonColor,
      backgroundColor.withOpacity(0.87),
    ],
  );
}

class AppValues {
  static const double screenPadding = 25;
  static const double largeBorderRadius = 15;
  static const String defaultUserImg = "https://johannesippen.com/img/blog/humans-not-users/header.jpg";
}