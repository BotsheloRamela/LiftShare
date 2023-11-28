import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liftshare/utils/firebase_utils.dart';
import 'package:liftshare/viewmodels/lift_offer_viewmodel.dart';

import '../../../data/models/lift.dart';
import '../../../utils/constants.dart';
import '../../widgets/app_background.dart';
import '../../widgets/default_app_bar.dart';

class ConfirmedLiftOfferScreen extends StatefulWidget {
  final Lift lift;
  final LiftOfferViewModel offerLiftViewModel;

  const ConfirmedLiftOfferScreen({super.key, required this.lift, required this.offerLiftViewModel});

  @override
  State<ConfirmedLiftOfferScreen> createState() => _ConfirmedLiftOfferScreenState();
}

class _ConfirmedLiftOfferScreenState extends State<ConfirmedLiftOfferScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void dispose() {
    _mapController.dispose();
    _markers.clear();
    _polylines.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Lift lift = widget.lift;
    LiftOfferViewModel viewModel = widget.offerLiftViewModel;

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
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  googleMap(lift, viewModel),
                  const SizedBox(height: 20),
                  liftInfo(lift),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // TODO: Cancel lift
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
                        border: Border.all(
                          color: AppColors.warningColor,
                          width: 1,
                        ),
                        color: AppColors.buttonColor,
                      ),
                      child: const Text(
                        "Cancel Lift",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.warningColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox googleMap(Lift lift, LiftOfferViewModel viewModel) {
    // TODO: Make this a reusable widget
    return SizedBox(
        height: 350,
        width: double.infinity,
        child: GoogleMap(
          cloudMapId: dotenv.get("GOOGLE_CLOUD_MAP_ID"),
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              lift.pickupLocationCoordinates.latitude,
              lift.pickupLocationCoordinates.longitude,
            ),
            zoom: 15,
          ),
          onMapCreated: (controller) async {
            _mapController = controller;
            _markers.addAll(await viewModel.getMarkers(lift));
            _polylines.add(await viewModel.getPolyline(lift));
            setState(() {});

          },
          markers: _markers,
          polylines: _polylines,
        )
    );
  }

  Column liftInfo(Lift lift) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Pickup Location",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.highlightColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          lift.pickupLocationName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Destination",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.highlightColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          lift.destinationLocationName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Pickup Time",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.highlightColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          formatFirebaseTimestamp(lift.departureTime),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Price",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.highlightColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "R${lift.tripPrice}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Seats",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.highlightColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${lift.availableSeats - lift.bookedSeats} available",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Status",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.highlightColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  lift.isLiftCompleted ? "Completed" : "Upcoming",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
