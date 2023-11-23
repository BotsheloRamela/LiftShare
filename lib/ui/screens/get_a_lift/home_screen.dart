import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liftshare/ui/screens/get_a_lift/search_lift_screen.dart';

import '../../../utils/constants.dart';
import '../../widgets/app_background.dart';
import '../../widgets/available_lift_item.dart';
import '../../widgets/home_app_bar.dart';

class GetALiftHomeScreen extends StatefulWidget {
  const GetALiftHomeScreen({super.key});

  @override
  State<GetALiftHomeScreen> createState() => _GetALiftHomeScreenState();
}

class _GetALiftHomeScreenState extends State<GetALiftHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    User? user = _auth.currentUser;
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: homeAppBar(_user?.photoURL),
        body: DecoratedBox(
          decoration: appBackground(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppValues.screenPadding, AppValues.screenPadding,
                AppValues.screenPadding, 0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  whereToButton(context),

                  const SizedBox(height: 40),
                  const Text(
                    "Booked Lifts",
                    style: TextStyle(
                      color: AppColors.highlightColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                      fontFamily: 'Aeonik',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20.0), // Adjust the spacing as needed
                          child: bookedLiftItem(
                              "https://thezoneatrosebank.co.za/the_zone/uploads/EMB-2.jpg",
                              "Rosebank Mall",
                              "12 Dec 2023",
                              "12:00 PM"
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Available Lifts",
                    style: TextStyle(
                      color: AppColors.highlightColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                      fontFamily: 'Aeonik',
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 310,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      itemCount: 5,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0), // Adjust the spacing as needed
                          child: availableLiftItem(
                            "https://images.unsplash.com/photo-1565990315145-9b2f389b0927?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                            "John Doe", "Rosebank Mall", "12 Dec", 3, 4
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}

Widget whereToButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchForLiftScreen())
      );
    },
    child: Container(
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.all(1.3),
        decoration: const BoxDecoration(
          gradient: AppColors.gradientBackground,
          borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius + 3)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius + 3)),
            color: AppColors.buttonColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/icons/search_icon.svg',
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 20),
              const Text(
                'Where to?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Aeonik',
                ),
              ),
            ],
          ),
        )
    ),
  );
}

Widget bookedLiftItem(String locationImageUrl, String locationName, String date, String time) {
  return Container(
    height: 150,
    width: 150,
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(AppValues.largeBorderRadius - 6)),
      gradient: AppColors.lightGradientBackground,
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(AppValues.largeBorderRadius - 6)),
        image: DecorationImage(
          image: NetworkImage(locationImageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(AppColors.buttonColor.withOpacity(0.8), BlendMode.darken),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            locationName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
              fontFamily: 'Aeonik',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
              fontFamily: 'Aeonik',
            ),
          ),
          const SizedBox(height: 1),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
              fontFamily: 'Aeonik',
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}
