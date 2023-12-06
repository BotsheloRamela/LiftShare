
import 'package:liftshare/viewmodels/lift_viewmodel.dart';

import '../data/models/lift.dart';
import '../data/repositories/lift_repository.dart';

class LiftSearchViewModel extends LiftViewModel {

  final String _userID;
  LiftSearchViewModel(this._userID);

  List<Lift> _availableLifts = [];
  List<Lift> get getAvailableLifts => _availableLifts;

  final LiftRepository _liftRepository = LiftRepository();

  Future<List<Lift>> getAvailableLiftsByDestination() async {
    List<Lift> lifts = await _liftRepository.getAvailableLifts(_userID, destinationLocationController.text);
    lifts.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    _availableLifts = lifts;
    return lifts;
  }
}