
import 'package:flutter/cupertino.dart';
import 'package:liftshare/viewmodels/base_lift_viewmodel.dart';

import '../data/models/lift.dart';
import '../data/repositories/lift_repository.dart';

class OfferLiftViewModel extends BaseLiftViewModel with ChangeNotifier{
  // Lift repository
  final LiftRepository _liftRepository = LiftRepository();

  List<Lift> _offeredLifts = [];
  List<Lift> get getLifts => _offeredLifts;

  void getUpcomingLifts(String uid) async {
    List <Lift> lifts = await _liftRepository.getUpcomingLiftsByUserId(uid);
    _offeredLifts = lifts;
    notifyListeners();
  }

}