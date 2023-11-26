import 'package:cloud_firestore/cloud_firestore.dart';

class Lift {
  final String driverId;
  final String pickupLocationID;
  final String destinationLocationID;
  final Timestamp departureTime;
  final int availableSeats;
  final int bookedSeats;
  final double tripPrice;
  final bool isLiftCompleted;

  Lift({
    required this.driverId,
    required this.pickupLocationID,
    required this.destinationLocationID,
    required this.departureTime,
    required this.availableSeats,
    required this.bookedSeats,
    required this.tripPrice,
    required this.isLiftCompleted,
  });

  factory Lift.fromDocument(DocumentSnapshot doc) {
    return Lift(
      driverId: doc["driverId"],
      pickupLocationID: doc["pickupLocationID"],
      destinationLocationID: doc["destinationLocationID"],
      departureTime: doc["departureTime"],
      availableSeats: doc["availableSeats"],
      bookedSeats: doc["bookedSeats"],
      tripPrice: doc["tripPrice"],
      isLiftCompleted: doc["isLiftCompleted"],
    );
  }

  Map<String, dynamic> toJson() => {
    "driverId": driverId,
    "pickupLocationID": pickupLocationID,
    "destinationLocationID": destinationLocationID,
    "departureTime": departureTime,
    "availableSeats": availableSeats,
    "bookedSeats": bookedSeats,
    "tripPrice": tripPrice,
    "isLiftCompleted": isLiftCompleted,
  };
}