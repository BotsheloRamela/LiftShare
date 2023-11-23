
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../data/models/place_autocomplete_result.dart';
import '../data/models/place_prediction.dart';
import '../services/google_maps_service.dart';

class SearchForLiftViewModel extends ChangeNotifier {
  final TextEditingController _pickupLocationController = TextEditingController();
  TextEditingController get pickupLocationController => _pickupLocationController;
  final TextEditingController _destinationLocationController = TextEditingController();
  TextEditingController get destinationLocationController => _destinationLocationController;
  TextEditingController _activeLocationController = TextEditingController();
  TextEditingController get activeLocationController => _activeLocationController;
  final FocusNode _pickupLocationFocusNode = FocusNode();
  FocusNode get pickupLocationFocusNode => _pickupLocationFocusNode;
  final FocusNode _destinationLocationFocusNode = FocusNode();
  FocusNode get destinationLocationFocusNode => _destinationLocationFocusNode;

  List<PlacePrediction> _placePredictions = [];
  List<PlacePrediction> get placePredictions => _placePredictions;

  void setActiveLocationController(TextEditingController controller) {
    if (controller == pickupLocationController) {
      _activeLocationController = _pickupLocationController;
    } else if (controller == destinationLocationController) {
      _activeLocationController = _destinationLocationController;
    }
    notifyListeners();
  }

  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/autocomplete/json",
        {
          "input": query,
          "key": dotenv.get("ANDROID_FIREBASE_API_KEY")
        }
    );

    String? response = await GoogleMapsService().fetchPlace(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
      PlaceAutocompleteResponse.parseAutocompleteResult(response);

      if (result.predictions != null) {
        _placePredictions = result.predictions!;
        notifyListeners();
      }
    }

  }


  void onLocationSelected(String selectedLocation, BuildContext context) {
    _activeLocationController.text = "";
    _activeLocationController.text = selectedLocation;

    // Move focus to the next text field
    if (_activeLocationController == _pickupLocationController) {
      FocusScope.of(context).requestFocus(_destinationLocationFocusNode);
      _placePredictions = [];
    } else if (_activeLocationController == _destinationLocationController) {
      // TODO: Search for trips/lifts
    }
    notifyListeners();
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