
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'back_button.dart';

PreferredSizeWidget defaultAppBar(BuildContext context, String? screenName) {
  return AppBar(
    title: Text(
      screenName ?? "",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.none,
        fontFamily: 'Aeonik',
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: backButton(context),
  );
}