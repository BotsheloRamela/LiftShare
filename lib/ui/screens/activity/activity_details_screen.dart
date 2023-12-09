import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liftshare/ui/widgets/user_icon.dart';
import 'package:liftshare/utils/firebase_utils.dart';
import 'package:liftshare/viewmodels/lift_viewmodel.dart';

import '../../../data/models/lift.dart';
import '../../../utils/constants.dart';
import '../../../viewmodels/activity_viewmodel.dart';
import '../../widgets/app_background.dart';
import '../../widgets/default_app_bar.dart';
import '../../widgets/google_map.dart';

class ActivityDetailsScreen extends StatefulWidget {
  final Lift lift;
  final ActivityViewModel viewModel;

  const ActivityDetailsScreen({super.key, required this.lift, required this.viewModel});

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Delay the visibility of buttons by 1 second
    // Timer(const Duration(seconds: 1), () {
    //   setState(() {
    //     buttonsVisible = true;
    //   });
    // });
    _loadMapData();
  }

  void _loadMapData() async {
    Lift lift = widget.lift;
    LiftViewModel liftViewModel = LiftViewModel();

    _markers.addAll(await liftViewModel.getMarkers(lift));
    _polylines.add(await liftViewModel.getPolyline(lift));

    await widget.viewModel.getDriverDetails(lift.driverId);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _markers.clear();
    _polylines.clear();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Lift lift = widget.lift;
    ActivityViewModel viewModel = widget.viewModel;
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: defaultAppBar(context, "Lift Details"),
        body: DecoratedBox(
          decoration: appBackground(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppValues.screenPadding, AppValues.screenPadding,
                AppValues.screenPadding, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: _isLoading
                    ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.gradientColor2,
                      ),
                    )
                    : ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(AppValues.largeBorderRadius - 8)
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return googleMap(lift, _markers, _polylines, constraints);
                        },
                      )
                    )
                ),
                const SizedBox(height: 20),
                if (lift.wasLiftOfferedByUser)
                  const Text(
                    "Offered a Lift",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                      fontFamily: 'Aeonik',
                    ),
                  ),

                if (!lift.wasLiftOfferedByUser)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: mediaQuery.size.width - 120,
                        child: Text(
                          "Booked a Lift with ${viewModel.getDriverName}",
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                            fontFamily: 'Aeonik',
                          ),
                        ),
                      ),
                      // const SizedBox(width: 10),
                      userIcon(viewModel.getDriverImage, 60)
                    ],
                  ),

                const SizedBox(height: 30),
                Text(
                  lift.wasLiftOfferedByUser
                      ? formatFirebaseTimestamp(lift.liftCreatedTime)
                      : formatFirebaseTimestamp(lift.bookingTime!),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: 'Aeonik',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  lift.wasLiftOfferedByUser
                      ? "R${lift.tripPrice}"
                      : "R${lift.tripPrice / lift.bookedSeats}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: 'Aeonik',
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    color: lift.liftStatus == "cancelled"
                        ? AppColors.warningColor
                        : (lift.liftStatus == "completed"
                        ? Colors.green
                        : Colors.orange),
                  ),
                  child: Text(
                    lift.liftStatus.capitalize(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      fontFamily: 'Aeonik',
                    ),
                  )
                ),
                const SizedBox(height: 40),
                const Text(
                  "Trip Route",
                  style: TextStyle(
                    color: AppColors.highlightColor,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: 'Aeonik',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/trip_line_icon.svg',
                      height: 60,
                    ),
                    const SizedBox(width: 18),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: mediaQuery.size.width - 90
                      ),
                      child: Column(
                        children: [
                          Text(
                            "${lift.pickupLocationName}, ${lift.pickupLocationAddress}",
                            softWrap: false,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              fontFamily: 'Aeonik',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${lift.destinationLocationName}, ${lift.destinationLocationAddress}",
                            softWrap: false,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              fontFamily: 'Aeonik',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 40),
                const Text(
                  "Time of Departure",
                  style: TextStyle(
                    color: AppColors.highlightColor,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: 'Aeonik',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  formatFirebaseTimestamp(lift.departureTime),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: 'Aeonik',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}