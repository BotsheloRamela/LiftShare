import 'package:flutter/material.dart';

class AppColors {
  static const Color gradientColor1 = Color(0xFF00E6FF);
  static const Color gradientColor2 = Color(0xFF1201FF);
  static const Color highlightColor = Color(0xFF858A94);
  static const Color textColor2 = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0xFF011019);
  static const Color buttonColor = Color(0xFF141C27);
  static const Color warningColor = Color(0xFFFF3D00);

  static const LinearGradient gradientBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      gradientColor1,
      gradientColor2,
    ],
  );
}
