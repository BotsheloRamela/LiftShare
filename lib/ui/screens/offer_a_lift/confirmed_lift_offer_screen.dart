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
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMapData();
  }

  void _loadMapData() async {
    Lift lift = widget.lift;
    LiftOfferViewModel viewModel = widget.offerLiftViewModel;

    _markers.addAll(await viewModel.getMarkers(lift));
    _polylines.add(await viewModel.getPolyline(lift));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
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
        backgroundColor: AppColors.backgroundColor,
        appBar: defaultAppBar(context, null),
        body: Expanded(
          child: Stack(
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
                  : googleMap(lift, viewModel)
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 400,
                  child: liftDetailsCard(lift)
                ),
              ),
              // const Spacer(),
              // GestureDetector(
              //   onTap: () {
              //     // TODO: Cancel lift
              //   },
              //   child: Container(
              //     width: double.infinity,
              //     alignment: Alignment.center,
              //     height: 50,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
              //       border: Border.all(
              //         color: AppColors.warningColor,
              //         width: 1,
              //       ),
              //       color: AppColors.buttonColor,
              //     ),
              //     child: const Text(
              //       "Cancel Lift",
              //       style: TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w500,
              //         color: AppColors.warningColor,
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Container liftDetailsCard(Lift lift) {
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
        children: [
          const Text(
            "Lift Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 25),
          liftInfo(lift)
        ],
      ),
    );
  }

  GoogleMap googleMap(Lift lift, LiftOfferViewModel viewModel) {
    // TODO: Make this a reusable widget
    return GoogleMap(
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
      onMapCreated: (controller) {
        setState(() {
          _mapController = controller;
        });
      },
      markers: _markers,
      polylines: _polylines,
    );
  }

  Column liftInfo(Lift lift) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pickup",
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
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              ],
            )
          ],
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
