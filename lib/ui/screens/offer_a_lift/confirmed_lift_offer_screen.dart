import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liftshare/data/models/directions.dart';
import 'package:liftshare/utils/firebase_utils.dart';
import 'package:provider/provider.dart';

import '../../../data/models/lift.dart';
import '../../../services/google_maps_service.dart';
import '../../../utils/constants.dart';
import '../../widgets/app_background.dart';
import '../../widgets/default_app_bar.dart';

class ConfirmedLiftOfferScreen extends StatefulWidget {
  final Lift lift;

  const ConfirmedLiftOfferScreen({required this.lift, Key? key}) : super(key: key);

  @override
  State<ConfirmedLiftOfferScreen> createState() => _ConfirmedLiftOfferScreenState();
}

class _ConfirmedLiftOfferScreenState extends State<ConfirmedLiftOfferScreen> {
  GoogleMapController? _mapController;
  LatLng? _pickupLocation;
  LatLng? _destinationLocation;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  Directions? _directions;

  Future<Directions> _getDirections(GeoPoint pickupLocation, GeoPoint destinationLocation) async {
    final directions = await GoogleMapsService()
        .getDirections(pickupLocation, destinationLocation);
    return directions;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Lift lift = widget.lift;

    _getDirections(lift.pickupLocationCoordinates, lift.destinationLocationCoordinates)
        .then((value) {
      _directions = value;
      // setState(() {});
    });

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
                  SizedBox(
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
                      onMapCreated: (controller) {
                        _mapController = controller;
                        _pickupLocation = LatLng(
                          lift.pickupLocationCoordinates.latitude,
                          lift.pickupLocationCoordinates.longitude,
                        );
                        _destinationLocation = LatLng(
                          lift.destinationLocationCoordinates.latitude,
                          lift.destinationLocationCoordinates.longitude,
                        );
                        _markers.add(
                          Marker(
                            markerId: const MarkerId("pickup"),
                            position: _pickupLocation!,
                            icon: BitmapDescriptor.defaultMarker,
                          ),
                        );
                        _markers.add(
                          Marker(
                            markerId: const MarkerId("destination"),
                            position: _destinationLocation!,
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueBlue
                            ),
                          ),
                        );
                        _polylines.add(
                          Polyline(
                            polylineId: const PolylineId("route"),
                            points: _directions!.polylinePoints
                                      .map((e) => LatLng(e.latitude, e.longitude))
                                      .toList(),
                            color: Colors.blue,
                            width: 2,
                          ),
                        );
                        setState(() {});

                      },
                      markers: _markers,
                      polylines: _polylines,
                    )
                  ),
                  const SizedBox(height: 20),
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
}
