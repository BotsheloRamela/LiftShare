import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liftshare/ui/widgets/default_app_bar.dart';
import 'package:liftshare/ui/widgets/location_input_form.dart';
import 'package:liftshare/viewmodels/lift_join_viewmodel.dart';
import 'package:liftshare/viewmodels/lift_search_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../../../data/models/lift.dart';
import '../../../utils/constants.dart';
import '../../../utils/firebase_utils.dart';
import '../../widgets/app_background.dart';
import '../../widgets/available_lift_item.dart';
import '../../widgets/location_list_item.dart';
import 'lift_details_screen.dart';

class SearchForLiftScreen extends StatefulWidget {
  final String userUid;
  const SearchForLiftScreen({super.key, required this.userUid});

  @override
  State<SearchForLiftScreen> createState() => _SearchForLiftScreenState();
}

class _SearchForLiftScreenState extends State<SearchForLiftScreen> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LiftSearchViewModel>(
          create: (_) => LiftSearchViewModel(
            widget.userUid,
          ),
        ),
      ],
      builder: (context, child) {
        final viewModel = Provider.of<LiftSearchViewModel>(context, listen: true);
        viewModel.setLiftsSearchCallback(() => _displayBottomSheet(context, viewModel));

        return SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: defaultAppBar(context, "Search for a Lift"),
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
                        const SizedBox(height: 70),
                        LocationInputForm<LiftSearchViewModel>(viewModel: context.watch<LiftSearchViewModel>()),
                        const SizedBox(height: 20),
                        const Divider(color: AppColors.highlightColor, thickness: 1),
                        const SizedBox(height: 20),
                        viewModel.pickupLocationController.text.isNotEmpty
                          || viewModel.destinationLocationController.text.isNotEmpty
                          || !viewModel.isPickupLocationSelected
                          || !viewModel.isDestinationLocationSelected
                          ? Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                itemCount: viewModel.placePredictions.length,
                                itemBuilder: (context, index) {
                                  return locationListItem(viewModel, index, context);
                                },
                              ),
                            )
                            : setLocationOnMapButton(context),
                      ],
                    ),
                  )
              ),
            ),
          ),
        );
      },
    );
  }

  // Callback function to close the bottom sheet
  void closeBottomSheet() {
    Navigator.pop(context);
  }

  Future<void> _displayBottomSheet(BuildContext context, LiftSearchViewModel viewModel) async {

    return showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppValues.largeBorderRadius),
            topRight: Radius.circular(AppValues.largeBorderRadius),
          ),
        ),
        builder: (context) {
          return SizedBox(
            height: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                FutureBuilder<Lift>(
                    future: viewModel.getAvailableLiftsByDestination().then((value) => value.first),
                    builder: (context, snapshot) {
                      if (snapshot.hasData || viewModel.getAvailableLifts.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Available Lifts to your Destination",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
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
                                itemCount: viewModel.getAvailableLifts.length,
                                itemBuilder: (context, index) {
                                  Lift lift = viewModel.getAvailableLifts[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => LiftDetailsScreen(
                                                lift: lift,
                                                joinLiftViewModel: LiftJoinViewModel(widget.userUid),
                                                onClose: closeBottomSheet
                                          )
                                      ));
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
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            Lottie.asset(
                              'assets/animations/not_found.json',
                              height: 150,
                              width: 150,
                              frameRate: FrameRate(60),
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Oops, no lifts available for this trip",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none,
                                fontFamily: 'Aeonik',
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Try searching for another trip",
                              style: TextStyle(
                                color: AppColors.highlightColor,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                                fontFamily: 'Aeonik',
                              ),
                            ),
                          ],
                        );
                      }
                    }
                ),
              ],
            ),
          );
        }
    );
  }
}


Widget setLocationOnMapButton(BuildContext context,) {
  return Column(
    children: [
      Row(
        children: [
          SvgPicture.asset("assets/icons/location_icon.svg", height: 24,),
          const SizedBox(width: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: const Text(
              "Set location on map",
              maxLines: 2,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
                fontFamily: 'Aeonik',
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
    ],
  );
}


