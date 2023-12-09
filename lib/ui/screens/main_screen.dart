import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liftshare/ui/screens/activity/home_screen.dart';
import 'package:liftshare/ui/screens/get_a_lift/home_screen.dart';
import 'package:liftshare/ui/screens/offer_a_lift/home_screen.dart';
import 'package:liftshare/ui/screens/wallet/home_screen.dart';

import '../../utils/constants.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    const OfferALiftHomeScreen(),
    const GetALiftHomeScreen(),
    const ActivityHomeScreen(),
    const WalletHomeScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.buttonColor,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: AppColors.highlightColor,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/car_icon.svg",
              color: _currentIndex == 0 ? Colors.white : AppColors.highlightColor,
            ),
            label: 'Offer a Lift',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/get_lift_icon.svg",
              color: _currentIndex == 1 ? Colors.white : AppColors.highlightColor,
            ),
            label: 'Get a Lift',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/reports_icon.svg",
              color: _currentIndex == 2 ? Colors.white : AppColors.highlightColor,
            ),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.wallet,
              color: _currentIndex == 3 ? Colors.white : AppColors.highlightColor,
            ),
            label: 'Wallet',
          ),
        ],
      )
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
