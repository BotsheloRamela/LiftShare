import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../widgets/app_background.dart';
import '../../widgets/back_button.dart';

class GetALiftHomeScreen extends StatefulWidget {
  const GetALiftHomeScreen({super.key});

  @override
  State<GetALiftHomeScreen> createState() => _GetALiftHomeScreenState();
}

class _GetALiftHomeScreenState extends State<GetALiftHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ShareLift',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
              fontFamily: 'Aeonik',
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: backButton(context),
        ),
        body: DecoratedBox(
            decoration: appBackground(),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(
                  AppValues.screenPadding, AppValues.screenPadding,
                  AppValues.screenPadding, 0),
              child: Text('ShareLift'),
            )
        ),
      ),
    );
  }
}