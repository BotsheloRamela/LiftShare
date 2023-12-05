import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liftshare/ui/widgets/cancel_button.dart';
import 'package:liftshare/utils/firebase_utils.dart';
import 'package:liftshare/viewmodels/lift_offer_viewmodel.dart';

import '../../../data/models/lift.dart';
import '../../../utils/constants.dart';
import '../../widgets/default_app_bar.dart';
import '../../widgets/google_map.dart';
import '../../widgets/maps_navigate_button.dart';

class ConfirmedLiftOfferScreen extends StatefulWidget {
  final Lift lift;
  final LiftOfferViewModel offerLiftViewModel;

  const ConfirmedLiftOfferScreen({super.key, required this.lift, required this.offerLiftViewModel});

  @override
  State<ConfirmedLiftOfferScreen> createState() => _ConfirmedLiftOfferScreenState();
}

class _ConfirmedLiftOfferScreenState extends State<ConfirmedLiftOfferScreen> {
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
                : googleMap(lift, viewModel, _markers, _polylines)
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 400,
                child: _liftDetailsCard(lift, viewModel)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _liftDetailsCard(Lift lift, LiftOfferViewModel viewModel) {
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
                child: cancelButton("Cancel Lift", () {
                  viewModel.deleteLift(lift.documentId);
                  Navigator.pop(context);
                }),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  viewModel.launchGoogleMaps(
                    lift.pickupLocationCoordinates,
                    lift.destinationLocationCoordinates,
                  );
                },
                child: mapsNavigateButton(),
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
