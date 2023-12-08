
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/models/lift.dart';

GoogleMap googleMap(Lift lift, Set<Marker> markers, Set<Polyline> polylines) {

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

  return GoogleMap(
    cloudMapId: dotenv.get("GOOGLE_CLOUD_MAP_ID"),
    zoomControlsEnabled: false,
    myLocationButtonEnabled: false,
    initialCameraPosition: CameraPosition(
      target: LatLng(
        bounds.southwest.latitude + (bounds.northeast.latitude - bounds.southwest.latitude) / 2,
        bounds.southwest.longitude + (bounds.northeast.longitude - bounds.southwest.longitude) / 2,
      ),
      zoom: 8,
    ),
    markers: markers,
    polylines: polylines,
    onMapCreated: (GoogleMapController controller) {
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          bounds,
          100, 
        ),
      );
    },
  );
}