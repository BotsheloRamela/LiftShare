
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

PreferredSizeWidget homeAppBar(String? userPhotoUrl) {
  return AppBar(
    title: const Text(
      'LiftShare',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.none,
        fontFamily: 'Aeonik',
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      GestureDetector(
        onTap: () {
          // TODO: Navigate to chat screen
        },
        child: Container(
          height: 30,
          width: 30,
          margin: const EdgeInsets.only(right: 15),
          child: SvgPicture.asset(
            'assets/icons/chat_icon.svg',
          ),
        )
      )
    ],
    leading: userPhotoUrl != null ? GestureDetector(
      onTap: () {
        // TODO: Navigate to account/profile screen
      },
      child: Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.only(left: 15, top: 12, bottom: 12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(userPhotoUrl ?? ''),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ) : Container(
      height: 20,
      width: 20,
      margin: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
      child: SvgPicture.asset(
        'assets/icons/user_avatar_icon.svg',
      ),
    ),
  );
}