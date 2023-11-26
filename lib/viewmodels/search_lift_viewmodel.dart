
import 'package:flutter/cupertino.dart';
import 'package:liftshare/viewmodels/base_lift_viewmodel.dart';

class SearchForLiftViewModel extends BaseLiftViewModel {

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
  void onLocationSelected(String selectedLocation, BuildContext context) async {
    super.onLocationSelected(selectedLocation, context);
    notifyListeners();
  }
}