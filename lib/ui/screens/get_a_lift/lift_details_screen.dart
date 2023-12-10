import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liftshare/data/models/lift.dart';
import 'package:liftshare/ui/screens/chats/messaging_screen.dart';
import 'package:liftshare/ui/widgets/action_button.dart';
import 'package:liftshare/ui/widgets/cancel_button.dart';
import 'package:liftshare/ui/widgets/default_app_bar.dart';
import 'package:liftshare/ui/widgets/user_icon.dart';
import 'package:liftshare/utils/firebase_utils.dart';
import 'package:liftshare/viewmodels/lift_join_viewmodel.dart';

import '../../../utils/constants.dart';
import '../../widgets/google_map.dart';

class LiftDetailsScreen extends StatefulWidget {
  final Lift lift;
  final LiftJoinViewModel joinLiftViewModel;
  final VoidCallback? onClose;

  const LiftDetailsScreen({super.key, required this.lift, required this.joinLiftViewModel, this.onClose});

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
    widget.onClose?.call();
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
                  : LayoutBuilder(
                    builder: (context, constraints) {
                      return googleMap(lift, _markers, _polylines, constraints);
                    },
                  )
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
        color: AppColors.backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  userIcon(viewModel.getDriverImage, 60),
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
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            color: Colors.green,
                          ),
                          child: const Text(
                            "Available",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              fontFamily: 'Aeonik',
                            ),
                          )
                      ),
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
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
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
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
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
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
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
                ? Row(
                  children: [
                    Expanded(
                      child: cancelButton("Cancel Lift", () {
                        viewModel.cancelLift(lift.documentId);
                        Navigator.pop(context);
                      }),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagingScreen(lift.driverId),
                          ),
                        );
                      },
                      child: Container(
                        width: 50,
                        alignment: Alignment.center,
                        height: 50,
                        padding: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                          gradient: AppColors.gradientBackground,
                          borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius)),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius - 3)),
                            color: AppColors.buttonColor,
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            "assets/icons/chat_icon.svg",
                            color: Colors.white,
                            width: 30,
                            height: 30,
                          ),
                        )
                      ),
                    )
                  ],
                )
                : actionButton("Join Lift", () {
              viewModel.bookLift(lift.documentId);
              Navigator.pop(context);
            })
        ],
      ),
    );
  }
}
