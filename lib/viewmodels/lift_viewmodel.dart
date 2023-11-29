import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liftshare/utils/constants.dart';

import '../data/models/directions.dart';
import '../data/models/lift.dart';
import '../data/models/place_autocomplete_result.dart';
import '../data/models/place_prediction.dart';
import '../data/repositories/lift_repository.dart';
import '../services/google_maps_service.dart';

class LiftViewModel extends ChangeNotifier {
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

  // Location selected
  bool _isPickupLocationSelected = false;
  bool _isDestinationLocationSelected = false;
  bool get isPickupLocationSelected => _isPickupLocationSelected;
  bool get isDestinationLocationSelected => _isDestinationLocationSelected;

  // Place ids
  String _pickupLocationID = "";
  String _destinationLocationID = "";
  String get pickupLocationID => _pickupLocationID;
  String get destinationLocationID => _destinationLocationID;

  // Place coordinates
  GeoPoint _pickupLocationCoordinates = const GeoPoint(0, 0);
  GeoPoint _destinationLocationCoordinates = const GeoPoint(0, 0);
  GeoPoint get pickupLocationCoordinates => _pickupLocationCoordinates;
  GeoPoint get destinationLocationCoordinates => _destinationLocationCoordinates;

  // Place photos
  String _destinationLocationPhoto = "";
  String get destinationLocationPhoto => _destinationLocationPhoto;

  // PLace names
  String _pickupLocationName = "";
  String _destinationLocationName = "";
  String get pickupLocationName => _pickupLocationName;
  String get destinationLocationName => _destinationLocationName;

  // Place addresses
  String _pickupLocationAddress = "";
  String _destinationLocationAddress = "";
  String get pickupLocationAddress => _pickupLocationAddress;
  String get destinationLocationAddress => _destinationLocationAddress;

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
        // String placeId = _placePredictions[0].placeId!;
        notifyListeners();
      }
    }
  }

  void onLocationSelected(int selectedLocationIndex, String selectedLocation, BuildContext context) async {
    _activeLocationController.text = "";
    _activeLocationController.text = selectedLocation;
    GoogleMapsService googleMapsService = GoogleMapsService();

    // Move focus to the next text field
    if (_activeLocationController == _pickupLocationController) {
      FocusScope.of(context).requestFocus(_destinationLocationFocusNode);
      _pickupLocationID = _placePredictions[selectedLocationIndex].placeId!;
      _pickupLocationAddress = _placePredictions[selectedLocationIndex].structuredFormatting.secondaryText;
      _placePredictions = [];
      _pickupLocationCoordinates = await googleMapsService.getLocationCoordinates(_pickupLocationID);
      _pickupLocationName = await googleMapsService.getLocationName(_pickupLocationID);
      _isPickupLocationSelected = true;
    } else if (_activeLocationController == _destinationLocationController) {
      FocusScope.of(context).unfocus();
      if (_pickupLocationController.text.isNotEmpty
          && _destinationLocationController.text.isNotEmpty) {
        await searchLifts();
        _destinationLocationID = _placePredictions[selectedLocationIndex].placeId!;
        _destinationLocationAddress = _placePredictions[selectedLocationIndex].structuredFormatting.secondaryText;
        _liftsSearchCallback();
        _placePredictions = [];
        _destinationLocationCoordinates = await googleMapsService.getLocationCoordinates(_destinationLocationID);
        _destinationLocationName = await googleMapsService.getLocationName(_destinationLocationID);
        _destinationLocationPhoto = await googleMapsService.getLocationPhoto(_destinationLocationID);
        _isDestinationLocationSelected = true;
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

  Future<Directions> _getDirections(GeoPoint pickupLocationCoordinates, GeoPoint destinationLocationCoordinates) async {
    return await GoogleMapsService().getDirections(pickupLocationCoordinates, destinationLocationCoordinates);
  }

  Future<Set<Marker>> getMarkers(Lift lift) async {
    Set<Marker> markers = {};

    Marker pickupMarker = Marker(
      markerId: const MarkerId("pickup"),
      position: LatLng(
        lift.pickupLocationCoordinates.latitude,
        lift.pickupLocationCoordinates.longitude,
      ),
      infoWindow: InfoWindow(
        title: lift.pickupLocationName,
        snippet: lift.pickupLocationAddress,
      ),
      icon: await _getMarkerIcon(lift.pickupLocationName, "Pickup"),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destination"),
      position: LatLng(
        lift.destinationLocationCoordinates.latitude,
        lift.destinationLocationCoordinates.longitude,
      ),
      infoWindow: InfoWindow(
        title: lift.destinationLocationName,
        snippet: lift.destinationLocationAddress,
      ),
      icon: await _getMarkerIcon(lift.destinationLocationName, "Destination"),
    );

    markers.add(pickupMarker);
    markers.add(destinationMarker);

    return markers;
  }

  Future<BitmapDescriptor> _getMarkerIcon(String locationName, String caption) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    const double width = 400.0;
    const double height = 150.0;
    const double borderRadius = 20.0;

    final RRect roundedRect = RRect.fromRectAndRadius(
      Rect.fromPoints(const Offset(0.0, 0.0), const Offset(width, height)),
      const Radius.circular(borderRadius),
    );

    // Draw the rectangle
    final Paint paintRect = Paint()..color = AppColors.buttonColor;
    canvas.drawRRect(roundedRect, paintRect);

    // Calculate responsive font size
    final double fontSize = _calculateResponsiveFontSize(locationName, width, height);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: locationName,
        style: TextStyle(fontSize: fontSize, color: Colors.white),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: width, maxWidth: width);
    textPainter.paint(canvas, Offset(0.0, (height - textPainter.height) - 13));

    // Draw caption
    const double captionFontSize = 38.0;
    final TextPainter captionTextPainter = TextPainter(
      text: TextSpan(
        text: caption,
        style: const TextStyle(fontSize: captionFontSize, color: AppColors.highlightColor), // Adjust color as needed
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    captionTextPainter.layout(minWidth: width, maxWidth: width);
    captionTextPainter.paint(
        canvas,
        Offset(0.0, (height + textPainter.height ) / 3 - captionTextPainter.height)
    );

    final img = await pictureRecorder.endRecording().toImage(width.toInt(), height.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(Uint8List.view(data!.buffer));
  }

  double _calculateResponsiveFontSize(String text, double width, double height) {
    // Adjust this factor to control the responsiveness
    const double responsivenessFactor = 0.8;

    final double maxSize = min(width, height) * responsivenessFactor;

    double fontSize = 48.0; // Default font size

    while (true) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(fontSize: fontSize),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      if (painter.width < width && painter.height < height) {
        // The text fits within the marker
        break;
      }

      fontSize -= 1.0;

      if (fontSize < 8.0) {
        // Minimum font size to prevent an infinite loop
        break;
      }
    }

    return fontSize;
  }

  Future<Polyline> getPolyline(Lift lift) async {
    Directions directions =
        await _getDirections(lift.pickupLocationCoordinates, lift.destinationLocationCoordinates);

    return Polyline(
      polylineId: const PolylineId("route"),
      points: directions.polylinePoints
          .map((e) => LatLng(e.latitude, e.longitude))
          .toList(),
      color: Colors.white,
      width: 4,
    );
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