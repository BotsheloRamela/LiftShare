import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftshare/ui/screens/activity/activity_details_screen.dart';
import 'package:liftshare/utils/firebase_utils.dart';
import 'package:liftshare/viewmodels/activity_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../data/models/app_user.dart';
import '../../../data/models/lift.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/enums.dart';
import '../../widgets/app_background.dart';
import '../../widgets/home_app_bar.dart';
import '../../widgets/no_lifts_error.dart';

class ActivityHomeScreen extends StatefulWidget {
  const ActivityHomeScreen({super.key});

  @override
  State<ActivityHomeScreen> createState() => _ActivityHomeScreenState();
}

class _ActivityHomeScreenState extends State<ActivityHomeScreen> {
  late AppUser _user;

  @override
  void initState() {
    super.initState();
    _getUser();
    setState(() {});
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
        ChangeNotifierProvider<ActivityViewModel>(
          create: (_) => ActivityViewModel(_user.uid ?? ""),
        )
      ],
      builder: (context, child) {
        final ActivityViewModel viewModel = Provider.of<ActivityViewModel>(context, listen: true);
        viewModel.getAllLifts();

        return SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: homeAppBar(_user.photoURL, context),
            body: DecoratedBox(
              decoration: appBackground(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppValues.screenPadding, AppValues.screenPadding,
                  AppValues.screenPadding, 0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    FutureBuilder<Lift>(
                      future: viewModel.getAllLifts().then((value) => value.first),
                      builder: (context, snapshot) {
                        if (snapshot.hasData || viewModel.allLifts.isNotEmpty) {
                          return Column(
                            mainAxisAlignment: viewModel.allLifts.isNotEmpty
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            crossAxisAlignment: viewModel.allLifts.isNotEmpty
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Activity",
                                style: TextStyle(
                                  color: AppColors.highlightColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Aeonik',
                                ),
                              ),
                              const SizedBox(height: 20),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                itemCount: viewModel.allLifts.length,
                                itemBuilder: (context, index) {
                                  Lift lift = viewModel.allLifts[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ActivityDetailsScreen(
                                                lift: lift, viewModel: viewModel
                                            )
                                          )
                                        );
                                      },
                                      child: activityItem(lift),
                                    ),
                                  );
                                },
                              )
                            ],
                          );
                        } else {
                          return Center(child: noLiftsFound(ErrorScreen.activity));
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget activityItem(Lift lift) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(AppValues.largeBorderRadius - 6)),
        gradient: AppColors.lightGradientBackground,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius - 6)),
          color: AppColors.buttonColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lift.destinationLocationName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                fontFamily: 'Aeonik',
              ),
            ),
            const SizedBox(height: 23),
            Text(
              formatFirebaseTimestamp(lift.departureTime),
              style: const TextStyle(
                color: AppColors.highlightColor,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
                fontFamily: 'Aeonik',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "R${lift.tripPrice}",
              style: const TextStyle(
                color: AppColors.highlightColor,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
                fontFamily: 'Aeonik',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Status: ${lift.liftStatus}",
              style: const TextStyle(
                color: AppColors.highlightColor,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
                fontFamily: 'Aeonik',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
