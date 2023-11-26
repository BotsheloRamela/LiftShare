
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liftshare/data/models/app_user.dart';
import 'package:liftshare/data/models/lift.dart';
import 'package:liftshare/ui/screens/offer_a_lift/offer_lift_screen.dart';
import 'package:liftshare/utils/firebase_utils.dart';
import 'package:liftshare/viewmodels/offer_lift_viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../../utils/constants.dart';
import '../../widgets/app_background.dart';
import '../../widgets/home_app_bar.dart';

class OfferALiftHomeScreen extends StatefulWidget {
  const OfferALiftHomeScreen({super.key});

  @override
  State<OfferALiftHomeScreen> createState() => _OfferALiftHomeScreenState();
}

class _OfferALiftHomeScreenState extends State<OfferALiftHomeScreen> {
  late AppUser _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _user = (userProvider.user)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OfferLiftViewModel>(
          create: (_) => OfferLiftViewModel(
            _user.uid ?? "",
          ),
        )
      ],
      builder: (context, child) {
        final OfferLiftViewModel offerLiftViewModel =
            Provider.of<OfferLiftViewModel>(context, listen: true);
        offerLiftViewModel.getUpcomingLifts();
        return SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            floatingActionButton: FloatingActionButton.extended(
              label: const Text(
                "Offer Lift",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
              backgroundColor: AppColors.buttonColor,
              icon: SvgPicture.asset(
                'assets/icons/car_icon.svg',
                color: Colors.white,
                height: 24,
                width: 24,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OfferLiftScreen(
                      userUid: _user.uid ?? "",
                    ),
                  ),
                );
              },

            ),
            appBar: homeAppBar(_user.photoURL),
            body: DecoratedBox(
              decoration: appBackground(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppValues.screenPadding, AppValues.screenPadding,
                    AppValues.screenPadding, 0),
                child: Column(
                  mainAxisAlignment: offerLiftViewModel.getLifts.isNotEmpty
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  crossAxisAlignment: offerLiftViewModel.getLifts.isNotEmpty
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    FutureBuilder<Lift>(
                      future: offerLiftViewModel.getOfferedLifts().then((value) => value.first),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Upcoming Lifts",
                                style: TextStyle(
                                  color: AppColors.highlightColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Aeonik',
                                ),
                              ),
                              const SizedBox(height: 30),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                itemCount: offerLiftViewModel.getLifts.length,
                                itemBuilder: (context, index) {
                                  Lift lift = offerLiftViewModel.getLifts[index];
                                  return offeredLiftListItem(
                                    lift.destinationLocationName,  // Use actual data fields
                                    lift.destinationLocationPhoto,
                                    lift.departureTime,
                                  );
                                },
                              ),
                            ],
                          );
                        } else {
                          return Center(child: noUpcomingLifts());
                        }
                      }
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget noUpcomingLifts() {
  return Column(
    children: [
      // TODO: Fix lottie animation freezing
      // Lottie.asset(
      //   'assets/animations/not_found.json',
      //   height: 150,
      //   width: 150,
      //   frameRate: FrameRate(60),
      //   fit: BoxFit.cover,
      // ),
      const SizedBox(height: 20),
      const Text(
        "No upcoming lifts",
        style: TextStyle(
          color: AppColors.highlightColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.none,
          fontFamily: 'Aeonik',
        ),
      ),
    ],
  );
}

Widget offeredLiftListItem(
    String locationName,
    String? locationImageUrl,
    Timestamp date,
  ) {
  String _date = formatFirebaseTimestamp(date);
  return Container(
    height: 80,
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 15),
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(AppValues.largeBorderRadius - 6)),
      gradient: AppColors.lightGradientBackground,
    ),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius - 6)),
        color: AppColors.buttonColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: locationImageUrl != null ? BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(locationImageUrl),
                fit: BoxFit.cover,
              ),
            ) : const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.highlightColor,
            ),
            child: locationImageUrl == null ? const Icon(
              Icons.location_on,
              color: AppColors.buttonColor,
              size: 30,
            ) : null,
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locationName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
              Text(
                _date,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}