
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:liftshare/viewmodels/base_lift_viewmodel.dart';

import '../data/models/lift.dart';
import '../data/repositories/lift_repository.dart';

class OfferLiftViewModel extends BaseLiftViewModel{
  // TextControllers and FocusNodes
  final TextEditingController _liftPriceController = TextEditingController();
  final TextEditingController _liftSeatsController = TextEditingController();

  TextEditingController get liftPriceController => _liftPriceController;
  TextEditingController get liftSeatsController => _liftSeatsController;

  // Lift repository
  final LiftRepository _liftRepository = LiftRepository();

  final DateTime _selectedDate = DateTime.now();

  DateTime get getSelectedDate => _selectedDate;

  List<Lift> _offeredLifts = [];
  List<Lift> get getLifts => _offeredLifts;

  final String _userID;
  OfferLiftViewModel(this._userID);

  void getUpcomingLifts() async {
    _offeredLifts = await _liftRepository.getUpcomingLiftsByUserId(_userID);
    _offeredLifts.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    notifyListeners();
  }

  Future<List<Lift>> getOfferedLifts() async {
    List<Lift> lifts = await _liftRepository.getUpcomingLiftsByUserId(_userID);
    lifts.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    notifyListeners();
    return lifts;
  }

  void createLift() async {
    Timestamp timestamp = Timestamp.fromDate(_selectedDate);
    Lift lift = Lift(
      driverId: _userID,
      pickupLocationID: super.pickupLocationID,
      destinationLocationID: super.destinationLocationID,
      departureTime: timestamp,
      availableSeats: int.parse(_liftSeatsController.text),
      bookedSeats: 0,
      tripPrice: double.parse(_liftPriceController.text),
      isLiftCompleted: false,
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
  void onLocationSelected(int selectedLocationIndex,  String selectedLocation, BuildContext context) async {
    super.onLocationSelected(selectedLocationIndex, selectedLocation, context);
    notifyListeners();
  }

}