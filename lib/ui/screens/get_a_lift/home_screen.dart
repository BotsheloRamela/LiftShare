import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liftshare/data/models/lift.dart';
import 'package:liftshare/ui/screens/get_a_lift/lift_details_screen.dart';
import 'package:liftshare/ui/screens/get_a_lift/search_lift_screen.dart';
import 'package:liftshare/ui/widgets/no_lifts_error.dart';
import 'package:liftshare/utils/enums.dart';
import 'package:liftshare/utils/firebase_utils.dart';
import 'package:liftshare/viewmodels/lift_join_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../data/models/app_user.dart';
import '../../../providers/user_provider.dart';
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
        ChangeNotifierProvider<LiftJoinViewModel>(
          create: (_) => LiftJoinViewModel(_user.uid ?? ""),
        )],
      builder: (context, child) {
        final LiftJoinViewModel viewModel = Provider.of<LiftJoinViewModel>(context, listen: true);
        viewModel.getLiftsAvailable();
        viewModel.getLiftBookings();

        return SafeArea(
          child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: homeAppBar(_user.photoURL),
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
                        whereToButton(context, _user.uid ?? ""),
                        const SizedBox(height: 40),

                        viewModel.getLifts.isEmpty && viewModel.getBookedLifts.isEmpty ?
                          Center(child: noLiftsFound(ErrorScreen.getALift)) :
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              FutureBuilder<Lift>(
                                future: viewModel.getBookings().then((value) => value.first),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData || viewModel.getBookedLifts.isNotEmpty) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
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
                                            shrinkWrap: true,
                                            physics: const BouncingScrollPhysics(),
                                            padding: const EdgeInsets.all(0),
                                            itemCount: viewModel.getBookedLifts.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {

                                              Lift lift = viewModel.getBookedLifts[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(right: 20.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => LiftDetailsScreen(
                                                                lift: lift,
                                                                joinLiftViewModel: viewModel)
                                                        )
                                                    );
                                                  },
                                                  child: bookedLiftItem(
                                                      lift.destinationLocationPhoto,
                                                      lift.destinationLocationName,
                                                      formatFirebaseTimestamp(lift.departureTime)
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                      ],
                                    );
                                  } else {
                                    return const SizedBox(height: 0);
                                  }
                                },
                              ),

                              FutureBuilder<Lift>(
                                  future: viewModel.getAvailableLifts().then((value) => value.first),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData || viewModel.getLifts.isNotEmpty) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
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
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: const BouncingScrollPhysics(),
                                            padding: const EdgeInsets.all(0),
                                            itemCount: viewModel.getLifts.length,
                                            itemBuilder: (context, index) {
                                              Lift lift = viewModel.getLifts[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => LiftDetailsScreen(
                                                            lift: lift,
                                                            joinLiftViewModel: viewModel)
                                                      )
                                                  );
                                                },
                                                child: availableLiftItem(
                                                    lift.destinationLocationPhoto,
                                                    lift.destinationLocationName,
                                                    formatFirebaseTimestamp(lift.departureTime),
                                                    lift.bookedSeats, lift.availableSeats
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      );
                                    } else {
                                      return const SizedBox(height: 0);
                                    }
                                  }
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              )
          ),
        );
      },
    );
  }
}

Widget whereToButton(BuildContext context, String userUid) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchForLiftScreen(userUid: userUid))
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

Widget bookedLiftItem(String locationImageUrl, String locationName, String date) {
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            locationName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
              fontFamily: 'Aeonik',
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 90,
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
                fontFamily: 'Aeonik',
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    ),
  );
}
