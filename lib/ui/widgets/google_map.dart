
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/models/lift.dart';

GoogleMap googleMap(Lift lift, Set<Marker> markers, Set<Polyline> polylines, BoxConstraints constraints) {

  LatLng minLatLng(GeoPoint a, GeoPoint b) {
    return LatLng(
      a.latitude < b.latitude ? a.latitude : b.latitude,
      a.longitude < b.longitude ? a.longitude : b.longitude,
    );
  }

  LatLng maxLatLng(GeoPoint a, GeoPoint b) {
    return LatLng(
      a.latitude > b.latitude ? a.latitude : b.latitude,
      a.longitude > b.longitude ? a.longitude : b.longitude,
    );
  }

  // Calculate the bounds that include both pickup and destination locations
  LatLngBounds bounds = LatLngBounds(
    southwest: minLatLng(
      lift.pickupLocationCoordinates,
      lift.destinationLocationCoordinates,
    ),
    northeast: maxLatLng(
      lift.pickupLocationCoordinates,
      lift.destinationLocationCoordinates,
    ),
  );

  // Calculate the center of the extended bounds
  LatLng center = LatLng(
    bounds.southwest.latitude + (bounds.northeast.latitude - bounds.southwest.latitude) / 2,
    bounds.southwest.longitude + (bounds.northeast.longitude - bounds.southwest.longitude) / 2,
  );

  // Calculate zoom level based on the height constraint of the SizedBox
  double zoomLevel = 11.4;
  if (constraints.maxHeight > 500) {
    zoomLevel = 14.0; // Adjust zoom level based on your desired behavior
  } else if (constraints.maxHeight > 300) {
    zoomLevel = 12.0;
  }

  return GoogleMap(
    cloudMapId: dotenv.get("GOOGLE_CLOUD_MAP_ID"),
    zoomControlsEnabled: false,
    myLocationButtonEnabled: false,
    initialCameraPosition: CameraPosition(
      target: center,
      zoom: zoomLevel,
    ),
    markers: markers,
    polylines: polylines
  );
}

