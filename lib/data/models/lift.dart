import 'package:cloud_firestore/cloud_firestore.dart';

class Lift {
  final String driverId;
  final String pickupLocationID;
  final String destinationLocationID;
  final String pickupLocationName;
  final String destinationLocationName;
  final GeoPoint pickupLocationCoordinates;
  final GeoPoint destinationLocationCoordinates;
  final String pickupLocationAddress;
  final String destinationLocationAddress;
  final String destinationLocationPhoto;
  final Timestamp departureTime;
  final int availableSeats;
  final int bookedSeats;
  final double tripPrice;
  final bool isLiftCompleted;
  final String documentId;

  String liftIdentifier;

  Lift({
    required this.driverId,
    required this.pickupLocationID,
    required this.destinationLocationID,
    required this.pickupLocationName,
    required this.destinationLocationName,
    required this.pickupLocationCoordinates,
    required this.destinationLocationCoordinates,
    required this.pickupLocationAddress,
    required this.destinationLocationAddress,
    required this.destinationLocationPhoto,
    required this.departureTime,
    required this.availableSeats,
    required this.bookedSeats,
    required this.tripPrice,
    required this.isLiftCompleted,
    this.documentId = "",
    this.liftIdentifier = "",
  });

  factory Lift.fromDocument(DocumentSnapshot doc) {
    return Lift(
      driverId: doc["driverId"],
      pickupLocationID: doc["pickupLocationID"],
      destinationLocationID: doc["destinationLocationID"],
      pickupLocationName: doc["pickupLocationName"],
      destinationLocationName: doc["destinationLocationName"],
      pickupLocationCoordinates: doc["pickupLocationCoordinates"],
      destinationLocationCoordinates: doc["destinationLocationCoordinates"],
      pickupLocationAddress: doc["pickupLocationAddress"],
      destinationLocationAddress: doc["destinationLocationAddress"],
      destinationLocationPhoto: doc["destinationLocationPhoto"],
      departureTime: doc["departureTime"],
      availableSeats: doc["availableSeats"],
      bookedSeats: doc["bookedSeats"],
      tripPrice: doc["tripPrice"],
      isLiftCompleted: doc["isLiftCompleted"],
      documentId: doc.id ?? "",
      liftIdentifier: "",
    );
  }

  Map<String, dynamic> toJson() => {
    "driverId": driverId,
    "pickupLocationID": pickupLocationID,
    "destinationLocationID": destinationLocationID,
    "pickupLocationName": pickupLocationName,
    "destinationLocationName": destinationLocationName,
    "pickupLocationCoordinates": pickupLocationCoordinates,
    "destinationLocationCoordinates": destinationLocationCoordinates,
    "pickupLocationAddress": pickupLocationAddress,
    "destinationLocationAddress": destinationLocationAddress,
    "destinationLocationPhoto": destinationLocationPhoto,
    "departureTime": departureTime,
    "availableSeats": availableSeats,
    "bookedSeats": bookedSeats,
    "tripPrice": tripPrice,
    "isLiftCompleted": isLiftCompleted,
  };
}