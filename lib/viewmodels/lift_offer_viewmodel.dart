
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftshare/utils/enums.dart';
import 'package:liftshare/viewmodels/lift_viewmodel.dart';

import '../data/models/lift.dart';
import '../data/repositories/lift_repository.dart';

class LiftOfferViewModel extends LiftViewModel{
  // TextControllers and FocusNodes
  final TextEditingController _liftPriceController = TextEditingController();
  final TextEditingController _liftSeatsController = TextEditingController();

  TextEditingController get liftPriceController => _liftPriceController;
  TextEditingController get liftSeatsController => _liftSeatsController;

  // Lift repository
  final LiftRepository _liftRepository = LiftRepository();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  DateTime get getSelectedDate => _selectedDate;

  List<Lift> _offeredLifts = [];
  List<Lift> get getLifts => _offeredLifts;

  final String _userID;
  LiftOfferViewModel(this._userID);

  void setLiftDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<List<Lift>> getOfferedLifts() async {
    List<Lift> lifts = await _liftRepository.getUpcomingLiftsByUserId(_userID);
    lifts.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    _offeredLifts = lifts;
    notifyListeners();

    return lifts;
  }

  void createLift() async {
    Timestamp timestamp = Timestamp.fromDate(_selectedDate);
    Timestamp now = Timestamp.now();
    Lift lift = Lift(
      driverId: _userID,
      pickupLocationId: super.pickupLocationID,
      destinationLocationId: super.destinationLocationID,
      pickupLocationName: super.pickupLocationName,
      destinationLocationName: super.destinationLocationName,
      pickupLocationCoordinates: super.pickupLocationCoordinates,
      destinationLocationCoordinates: super.destinationLocationCoordinates,
      pickupLocationAddress: super.pickupLocationAddress,
      destinationLocationAddress: super.destinationLocationAddress,
      destinationLocationPhoto: super.destinationLocationPhoto??"",
      departureTime: timestamp,
      liftCreatedTime: now,
      availableSeats: int.parse(_liftSeatsController.text),
      bookedSeats: 0,
      tripPrice: double.parse(_liftPriceController.text),
      liftStatus: LiftStatus.pending,
    );
    await _liftRepository.createLift(lift);
    notifyListeners();
  }

  @override
  void setActiveLocationController(TextEditingController controller) {
    super.setActiveLocationController(controller);
    notifyListeners();
  }

  @override
  void searchPlace(String query) async {
    super.searchPlace(query);
    notifyListeners();
  }

  @override
  void onLocationSelected(int selectedLocationIndex, String selectedLocation, BuildContext context) async {
    super.onLocationSelected(selectedLocationIndex, selectedLocation, context);
    notifyListeners();
  }

  void cancelLift(String liftId) async {
    await _liftRepository.cancelLift(liftId);
    notifyListeners();
  }

  void launchGoogleMaps(GeoPoint pickupLocationCoordinates, GeoPoint destinationLocationCoordinates) async {
    if (Platform.isAndroid) {
      final AndroidIntent intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull(
            "https://www.google.com/maps/dir/?api=1&origin=${pickupLocationCoordinates.latitude},${pickupLocationCoordinates.longitude}&destination=${destinationLocationCoordinates.latitude},${destinationLocationCoordinates.longitude}&travelmode=driving&dir_action=navigate"),
        package: 'com.google.android.apps.maps',
      );

      await intent.launch();
    }
  }
}