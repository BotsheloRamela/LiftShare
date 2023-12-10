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
import '../../widgets/action_icon_button.dart';

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
            ),
          ],
        ),
      ),
    );
  }

  Widget _liftDetailsCard(Lift lift, LiftOfferViewModel viewModel) {
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
                  viewModel.cancelLift(lift.documentId);
                  Navigator.pop(context);
                }),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () async {
                  try {
                    await viewModel.completeLift(lift.documentId);
                    Navigator.pop(context);
                  } catch (e) {
                    print('Error completing lift: $e');
                  }
                },
                child: actionIconButton(
                    const Icon(Icons.done, color: Colors.white, size: 30),
                    50
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  viewModel.launchGoogleMaps(
                    lift.pickupLocationCoordinates,
                    lift.destinationLocationCoordinates,
                  );
                },
                child: actionIconButton(
                  const Icon(Icons.directions, color: Colors.white, size: 30),
                  50
                ),
              )
            ]
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget liftInfo(Lift lift) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Pickup Time",
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
            fontSize: 16,
            fontWeight: FontWeight.normal,
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
                    color: AppColors.highlightColor,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: 'Aeonik',
                  ),
                ),
                Text(
                  "R${lift.tripPrice}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
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
                    color: AppColors.highlightColor,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: 'Aeonik',
                  ),
                ),
                Text(
                  "${lift.availableSeats - lift.bookedSeats}/${lift.availableSeats} available",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
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
                    color: AppColors.highlightColor,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: 'Aeonik',
                  ),
                ),
                Text(
                  lift.liftStatus.capitalize(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
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

extension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
