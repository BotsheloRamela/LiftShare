
import 'package:liftshare/viewmodels/lift_viewmodel.dart';

import '../data/models/lift.dart';
import '../data/repositories/lift_repository.dart';

class LiftJoinViewModel extends LiftViewModel {
  final String _userID;
  LiftJoinViewModel(this._userID);

  List<Lift> _availableLifts = [];
  List<Lift> get getLifts => _availableLifts;

  List<Lift> _bookedLifts = [];
  List<Lift> get getBookedLifts => _bookedLifts;

  final LiftRepository _liftRepository = LiftRepository();

  Future<List<Lift>> getBookings() async {
    List<Lift> lifts = await _liftRepository.getBookingsByUserId(_userID);
    lifts.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    _bookedLifts = lifts;
    notifyListeners();
    return lifts;
  }

  Future<List<Lift>> getAvailableLifts() async {
    List<Lift> lifts = await _liftRepository.getAvailableLifts(_userID);
    lifts.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    _availableLifts = lifts;
    notifyListeners();
    return lifts;
  }
}