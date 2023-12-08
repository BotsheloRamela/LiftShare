import 'package:cloud_firestore/cloud_firestore.dart';

class Lift {
  final String driverId;
  final String pickupLocationId;
  final String destinationLocationId;
  final String pickupLocationName;
  final String destinationLocationName;
  final GeoPoint pickupLocationCoordinates;
  final GeoPoint destinationLocationCoordinates;
  final String pickupLocationAddress;
  final String destinationLocationAddress;
  final String destinationLocationPhoto;
  final Timestamp departureTime;
  final Timestamp liftCreatedTime;
  final int availableSeats;
  final int bookedSeats;
  final double tripPrice;
  final bool isLiftCompleted;
  final String documentId;

  bool wasLiftOfferedByUser;
  Timestamp? bookingTime;

  Lift({
    required this.driverId,
    required this.pickupLocationId,
    required this.destinationLocationId,
    required this.pickupLocationName,
    required this.destinationLocationName,
    required this.pickupLocationCoordinates,
    required this.destinationLocationCoordinates,
    required this.pickupLocationAddress,
    required this.destinationLocationAddress,
    required this.destinationLocationPhoto,
    required this.departureTime,
    required this.liftCreatedTime,
    required this.availableSeats,
    required this.bookedSeats,
    required this.tripPrice,
    required this.isLiftCompleted,
    this.documentId = "",
    this.wasLiftOfferedByUser = false,
    this.bookingTime,
  });

  factory Lift.fromDocument(DocumentSnapshot doc) {
    return Lift(
      driverId: doc["driverId"],
      pickupLocationId: doc["pickupLocationId"],
      destinationLocationId: doc["destinationLocationId"],
      pickupLocationName: doc["pickupLocationName"],
      destinationLocationName: doc["destinationLocationName"],
      pickupLocationCoordinates: doc["pickupLocationCoordinates"],
      destinationLocationCoordinates: doc["destinationLocationCoordinates"],
      pickupLocationAddress: doc["pickupLocationAddress"],
      destinationLocationAddress: doc["destinationLocationAddress"],
      destinationLocationPhoto: doc["destinationLocationPhoto"],
      departureTime: doc["departureTime"],
      liftCreatedTime: doc["liftCreatedTime"],
      availableSeats: doc["availableSeats"],
      bookedSeats: doc["bookedSeats"],
      tripPrice: doc["tripPrice"],
      isLiftCompleted: doc["isLiftCompleted"],
      documentId: doc.id,
      wasLiftOfferedByUser: false,
      bookingTime: null,
    );
  }

  Map<String, dynamic> toJson() => {
    "driverId": driverId,
    "pickupLocationId": pickupLocationId,
    "destinationLocationId": destinationLocationId,
    "pickupLocationName": pickupLocationName,
    "destinationLocationName": destinationLocationName,
    "pickupLocationCoordinates": pickupLocationCoordinates,
    "destinationLocationCoordinates": destinationLocationCoordinates,
    "pickupLocationAddress": pickupLocationAddress,
    "destinationLocationAddress": destinationLocationAddress,
    "destinationLocationPhoto": destinationLocationPhoto,
    "departureTime": departureTime,
    "liftCreatedTime": liftCreatedTime,
    "availableSeats": availableSeats,
    "bookedSeats": bookedSeats,
    "tripPrice": tripPrice,
    "isLiftCompleted": isLiftCompleted,
  };
}
