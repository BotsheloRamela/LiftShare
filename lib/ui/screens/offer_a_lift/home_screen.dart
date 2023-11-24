import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: true);
    setState(() {
      _user = userProvider.user as User?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OfferLiftViewModel>(
          create: (_) => OfferLiftViewModel(),
        )
      ],
      builder: (context, child) {
        final OfferLiftViewModel _offerLiftViewModel =
            Provider.of<OfferLiftViewModel>(context);
        _offerLiftViewModel.getUpcomingLifts(_user?.uid ?? "");
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
                // TODO: Navigate to offer a lift screen
              },

            ),
            appBar: homeAppBar(_user?.photoURL),
            body: DecoratedBox(
              decoration: appBackground(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppValues.screenPadding, AppValues.screenPadding,
                    AppValues.screenPadding, 0),
                child: Column(
                  mainAxisAlignment: _offerLiftViewModel.getLifts.isNotEmpty
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  crossAxisAlignment: _offerLiftViewModel.getLifts.isNotEmpty
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    _offerLiftViewModel.getLifts.isNotEmpty ? Column(
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
                        offeredLiftListItem(
                          "The Zone @ Rosebank",
                          null,
                          "2021-09-30",
                          "10:00"
                        ),
                      ],
                    ) : Center(
                        child: noUpcomingLifts()),
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
      Lottie.asset(
        'assets/animations/not_found.json',
        repeat: true,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      ),
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
    String date,
    String time,
  ) {
  return Container(
    height: 80,
    width: double.infinity,
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
                "$date - $time",
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
          const Spacer(),
          // const Text(
          //   "View",
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 14,
          //     fontWeight: FontWeight.normal,
          //     decoration: TextDecoration.none,
          //     fontFamily: 'Aeonik',
          //   ),
          // ),
          // const SizedBox(width: 10),
          // const Icon(
          //   Icons.arrow_forward_ios,
          //   color: Colors.white,
          //   size: 14,
          // ),
        ],
      ),
    ),
  );
}