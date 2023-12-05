import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liftshare/data/models/lift.dart';
import 'package:liftshare/ui/widgets/action_button.dart';
import 'package:liftshare/ui/widgets/cancel_button.dart';
import 'package:liftshare/ui/widgets/default_app_bar.dart';
import 'package:liftshare/utils/firebase_utils.dart';
import 'package:liftshare/viewmodels/lift_join_viewmodel.dart';

import '../../../utils/constants.dart';
import '../../widgets/google_map.dart';

class LiftDetailsScreen extends StatefulWidget {
  final Lift lift;
  final LiftJoinViewModel joinLiftViewModel;

  const LiftDetailsScreen({Key? key, required this.lift, required this.joinLiftViewModel}) : super(key: key);

  @override
  State<LiftDetailsScreen> createState() => _LiftDetailsScreenState();
}

class _LiftDetailsScreenState extends State<LiftDetailsScreen> {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isLoading = true;
  bool buttonsVisible = false;

  @override
  void initState() {
    super.initState();
    // Delay the visibility of buttons by 1 second
    Timer(const Duration(seconds: 1), () {
      setState(() {
        buttonsVisible = true;
      });
    });
    _loadMapData();
  }

  void _loadMapData() async {
    Lift lift = widget.lift;
    LiftJoinViewModel viewModel = widget.joinLiftViewModel;

    _markers.addAll(await viewModel.getMarkers(lift));
    _polylines.add(await viewModel.getPolyline(lift));

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
    LiftJoinViewModel viewModel = widget.joinLiftViewModel;

    viewModel.getDriverProfilePhoto(lift.driverId);
    viewModel.getDriverDetails(lift.driverId);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.backgroundColor,
        appBar: defaultAppBar(context, null),
        body: Stack(
          children: [
            SizedBox(
                height: 500,
                width: double.infinity,
                child: _isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.gradientColor2,
                  ),
                )
                    : googleMap(lift, viewModel, _markers, _polylines)
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                  height: 400,
                  child: _liftDetailsCard(lift, viewModel)
              ),
            )
          ],
        ),
      )
    );
  }
  
  Container _liftDetailsCard(Lift lift, LiftJoinViewModel viewModel) {
    viewModel.isLiftBookedAlready(lift.documentId);
    bool isLiftFull = lift.availableSeats - lift.bookedSeats == 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppValues.largeBorderRadius),
          topRight: Radius.circular(AppValues.largeBorderRadius),
        ),
        color: AppColors.buttonColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    alignment: Alignment.center,
                    height: 60,
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      gradient: AppColors.gradientBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(viewModel.getDriverImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.getDriverName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontFamily: 'Aeonik',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Lift Status: ${isLiftFull ? 'Full' : 'Available'}",
                        style: const TextStyle(
                          color: AppColors.highlightColor,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          fontFamily: 'Aeonik',
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Trip Route",
                style: TextStyle(
                  color: AppColors.highlightColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${lift.pickupLocationName} → ${lift.destinationLocationName}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
              const SizedBox(height: 15),

              const Text(
                "Trip Departure Time",
                style: TextStyle(
                  color: AppColors.highlightColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                formatFirebaseTimestamp(lift.departureTime),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
              const SizedBox(height: 15),

              const Text(
                "Trip Price",
                style: TextStyle(
                  color: AppColors.highlightColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "R${lift.tripPrice} (${lift.availableSeats - lift.bookedSeats} seats left)",
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
          if (buttonsVisible)
            viewModel.isLiftBooked
                ? cancelButton("Cancel Lift", () {
              viewModel.cancelLift(lift.documentId);
              Navigator.pop(context);
            })
                : actionButton("Join Lift", () {
              viewModel.bookLift(lift.documentId);
              Navigator.pop(context);
            })
        ],
      ),
    );
  }
}
