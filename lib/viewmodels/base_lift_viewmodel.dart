import 'package:flutter/cupertino.dart';

class BaseLiftViewModel {
  // Example properties, replace with your actual properties
  TextEditingController pickupLocationController = TextEditingController();
  TextEditingController destinationLocationController = TextEditingController();
  FocusNode pickupLocationFocusNode = FocusNode();
  FocusNode destinationLocationFocusNode = FocusNode();

  void setActiveLocationController(TextEditingController controller) {}

  void searchPlace(String query) {}
}