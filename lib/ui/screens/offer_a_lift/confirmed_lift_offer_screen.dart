import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liftshare/utils/firebase_utils.dart';
import 'package:liftshare/viewmodels/lift_offer_viewmodel.dart';

import '../../../data/models/lift.dart';
import '../../../utils/constants.dart';
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
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
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
                : googleMap(lift, viewModel)
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 400,
                child: liftDetailsCard(lift)
              ),
            ),
          ],
        ),
      ),
    );
  }

  GoogleMap googleMap(Lift lift, LiftOfferViewModel viewModel) {
    // TODO: Make this a reusable widget

    LatLng minLatLng(GeoPoint a, GeoPoint b) {
      return LatLng(
        a.latitude < b.latitude ? a.latitude : b.latitude,
        a.longitude < b.longitude ? a.longitude : b.longitude,
      );
    }

    LatLng maxLatLng(GeoPoint a, GeoPoint b) {
      return LatLng(
        a.latitude > b.latitude ? a.latitude : b.latitude,
        a.longitude > b.longitude ? a.longitude : b.longitude,
      );
    }

    // Calculate the bounds that include both pickup and destination locations
    LatLngBounds bounds = LatLngBounds(
      southwest: minLatLng(
        lift.pickupLocationCoordinates,
        lift.destinationLocationCoordinates,
      ),
      northeast: maxLatLng(
        lift.pickupLocationCoordinates,
        lift.destinationLocationCoordinates,
      ),
    );

    return GoogleMap(
      cloudMapId: dotenv.get("GOOGLE_CLOUD_MAP_ID"),
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          bounds.southwest.latitude + (bounds.northeast.latitude - bounds.southwest.latitude) / 2,
          bounds.southwest.longitude + (bounds.northeast.longitude - bounds.southwest.longitude) / 2,
        ),
        zoom: 12,
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

  Container liftDetailsCard(Lift lift) {
    // TODO: Add a share lift button
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
          liftInfo(lift),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Cancel lift
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
                      border: Border.all(
                        color: AppColors.warningColor,
                        width: 1,
                      ),
                      color: AppColors.backgroundColor.withOpacity(0.2),
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
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  // TODO: Launch Google Maps with directions
                },
                // TODO: Make this icon container a reusable widget
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
                    child: const Icon(
                      Icons.directions,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ),
              )
            ]
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Column liftInfo(Lift lift) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
