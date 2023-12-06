
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

  String _driverImage = '';
  String get getDriverImage => _driverImage;

  String _driverName = '';
  String get getDriverName => _driverName;

  bool _isLiftBooked = false;
  bool get isLiftBooked => _isLiftBooked;

  final LiftRepository _liftRepository = LiftRepository();

  void getLiftBookings() async {
    _bookedLifts = await _liftRepository.getBookingsByUserId(_userID);
    _bookedLifts.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    notifyListeners();
  }

  Future<List<Lift>> getBookings() async {
    List<Lift> lifts = await _liftRepository.getBookingsByUserId(_userID);
    lifts.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    return lifts;
  }

  void getLiftsAvailable() async {
    _availableLifts = await _liftRepository.getAvailableLifts(_userID, null);
    _availableLifts.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    notifyListeners();
  }

  Future<List<Lift>> getAvailableLifts() async {
    List<Lift> lifts = await _liftRepository.getAvailableLifts(_userID, null);
    lifts.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    return lifts;
  }

  Future getDriverProfilePhoto(String uid) async {
    String image = await _liftRepository.getUserImage(uid);
    _driverImage = image;
  }

  Future getDriverDetails(String uid) async {
    String name = await _liftRepository.getUserName(uid);
    _driverName = name;
  }

  Future<void> bookLift(String liftId) async {
    await _liftRepository.bookLift(liftId, _userID);
  }

  Future<void> cancelLift(String liftId) async {
    await _liftRepository.cancelLift(liftId, _userID);
  }

  Future<void> isLiftBookedAlready(String liftId) async {
    _isLiftBooked = await _liftRepository.isLiftBooked(liftId, _userID);
    notifyListeners();
  }

  @override
  void dispose() {
    _availableLifts.clear();
    _bookedLifts.clear();
    super.dispose();
  }
}