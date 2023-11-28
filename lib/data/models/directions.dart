
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  Directions({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    if ((map["routes"] as List).isEmpty) {
      throw Exception("No routes available");
    }

    // Get the route information
    final data = Map<String, dynamic>.from(map["routes"][0]);

    // Get the bounds
    final northeast = data["bounds"]["northeast"];
    final southwest = data["bounds"]["southwest"];
    final bounds = LatLngBounds(
      southwest: LatLng(southwest["lat"], southwest["lng"]),
      northeast: LatLng(northeast["lat"], northeast["lng"]),
    );

    // Get the distance and duration
    String distance = "";
    String duration = "";
    if (data["legs"] != null) {
      distance = data["legs"][0]["distance"]["text"];
      duration = data["legs"][0]["duration"]["text"];
    }

    // Get the encoded polyline
    final List<PointLatLng> polylinePoints =
        PolylinePoints().decodePolyline(data["overview_polyline"]["points"]);

    return Directions(
      bounds: bounds,
      polylinePoints: polylinePoints,
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}