
import 'package:flutter/cupertino.dart';
import 'package:liftshare/viewmodels/lift_viewmodel.dart';

class LiftSearchViewModel extends LiftViewModel {

  final String _userID;
  LiftSearchViewModel(this._userID);

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