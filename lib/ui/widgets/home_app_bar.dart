
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liftshare/ui/screens/chats/chats_screen.dart';
import 'package:liftshare/utils/constants.dart';

import '../screens/user/profile_screen.dart';

PreferredSizeWidget homeAppBar(String? userPhotoUrl, BuildContext context) {
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatsScreen())
          );
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
    leading: GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen())
        );
      },
      child: Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.only(left: 13, top: 8, bottom: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(userPhotoUrl ?? AppValues.defaultUserImg),
            fit: BoxFit.cover,
          ),
        ),
      ),
    )
  );
}