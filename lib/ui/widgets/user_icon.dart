
import 'package:flutter/cupertino.dart';

import '../../utils/constants.dart';

Widget userIcon(String? imageUrl, double size) {
  return Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    padding: const EdgeInsets.all(3),
    decoration: const BoxDecoration(
      gradient: AppColors.gradientBackground,
      shape: BoxShape.circle,
    ),
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(imageUrl ?? AppValues.defaultUserImg),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}