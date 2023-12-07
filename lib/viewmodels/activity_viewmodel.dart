
import 'package:flutter/cupertino.dart';

import '../data/models/lift.dart';
import '../data/repositories/lift_repository.dart';

class ActivityViewModel extends ChangeNotifier {
  final String _userID;
  ActivityViewModel(this._userID);

  final LiftRepository _liftRepository = LiftRepository();

  List<Lift> _offeredLifts = [];
  List<Lift> _bookedLifts = [];

  List<Lift> _allLifts = [];
  List<Lift> get allLifts => _allLifts;

  Future<List<Lift>> getAllLifts() async {
    _offeredLifts = await _liftRepository.getOfferedLiftsByUserId(_userID);
    _bookedLifts = await _liftRepository.getBookingsByUserId(_userID);

    _offeredLifts.forEach((lift) => lift.liftIdentifier = "Offered");
    _bookedLifts.forEach((lift) => lift.liftIdentifier = "Booked");

    _allLifts = [..._offeredLifts, ..._bookedLifts]; // Concatenate the two lists
    _allLifts.sort((a, b) => b.departureTime.compareTo(a.departureTime));
    notifyListeners();

    return _allLifts;
  }
}