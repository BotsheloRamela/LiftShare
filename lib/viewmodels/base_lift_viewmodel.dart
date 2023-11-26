import 'package:flutter/cupertino.dart';

import '../data/models/lift.dart';
import '../data/models/place_autocomplete_result.dart';
import '../data/models/place_prediction.dart';
import '../data/repositories/lift_repository.dart';
import '../services/google_maps_service.dart';

class BaseLiftViewModel extends ChangeNotifier {
  // Example properties, replace with your actual properties
  final TextEditingController _pickupLocationController = TextEditingController();
  final TextEditingController _destinationLocationController = TextEditingController();
  TextEditingController _activeLocationController = TextEditingController();
  final FocusNode _pickupLocationFocusNode = FocusNode();
  final FocusNode _destinationLocationFocusNode = FocusNode();

  TextEditingController get pickupLocationController => _pickupLocationController;
  TextEditingController get destinationLocationController => _destinationLocationController;
  TextEditingController get activeLocationController => _activeLocationController;
  FocusNode get pickupLocationFocusNode => _pickupLocationFocusNode;
  FocusNode get destinationLocationFocusNode => _destinationLocationFocusNode;

  // Place predictions
  List<PlacePrediction> _placePredictions = [];
  List<PlacePrediction> get placePredictions => _placePredictions;

  // Lift repository
  final LiftRepository _liftRepository = LiftRepository();

  // Available lifts
  List<Lift> _availableLifts = [];
  List<Lift> get availableLifts => _availableLifts;

  // Callback
  VoidCallback _liftsSearchCallback = () {};
  VoidCallback get liftsSearchCallback => _liftsSearchCallback;

  // void notifyListenersInBase(VoidCallback notifyListeners) {
  //   notifyListeners();
  // }

  void setLiftsSearchCallback(VoidCallback callback) {
    _liftsSearchCallback = callback;
  }

  void setActiveLocationController(TextEditingController controller) {
    if (controller == pickupLocationController) {
      _activeLocationController = _pickupLocationController;
    } else if (controller == destinationLocationController) {
      _activeLocationController = _destinationLocationController;
    }
    notifyListeners();
  }

  void searchPlace(String query) async {
    String? response = await GoogleMapsService().searchPlace(query);

    if (response != null) {
      PlaceAutocompleteResponse result =
      PlaceAutocompleteResponse.parseAutocompleteResult(response);

      if (result.predictions != null) {
        _placePredictions = result.predictions!;
        notifyListeners();
        print("Result: ${result.predictions!.length}");
      }
    }
  }

  void onLocationSelected(String selectedLocation, BuildContext context) async {
    _activeLocationController.text = "";
    _activeLocationController.text = selectedLocation;

    // Move focus to the next text field
    if (_activeLocationController == _pickupLocationController) {
      FocusScope.of(context).requestFocus(_destinationLocationFocusNode);
      _placePredictions = [];
    } else if (_activeLocationController == _destinationLocationController) {
      FocusScope.of(context).unfocus();
      if (_pickupLocationController.text.isNotEmpty
          && _destinationLocationController.text.isNotEmpty) {
        await searchLifts();
        _liftsSearchCallback();
        _placePredictions = [];
      }
    }
    notifyListeners();
  }

  Future<void> searchLifts() async {
    String pickupLocation = _pickupLocationController.text;
    String destinationLocation = _destinationLocationController.text;

    if (pickupLocation.isNotEmpty && destinationLocation.isNotEmpty) {
      List<Lift> lifts =
      await _liftRepository.searchLifts(pickupLocation, destinationLocation);

      if (lifts.isNotEmpty) {
        _availableLifts = lifts;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    pickupLocationController.dispose();
    _destinationLocationController.dispose();
    _pickupLocationFocusNode.dispose();
    _destinationLocationFocusNode.dispose();
    super.dispose();
  }
}