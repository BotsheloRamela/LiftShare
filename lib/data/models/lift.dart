import 'package:cloud_firestore/cloud_firestore.dart';

class Lift {
  final String driverId;
  final String pickupLocation;
  final String destinationLocation;
  final String departureTime;
  final int availableSeats;
  final int bookedSeats;
  final int tripPrice;
  final bool isLiftCompleted;

  Lift({
    required this.driverId,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.departureTime,
    required this.availableSeats,
    required this.bookedSeats,
    required this.tripPrice,
    required this.isLiftCompleted,
  });

  factory Lift.fromDocument(DocumentSnapshot doc) {
    return Lift(
      driverId: doc["driverId"],
      pickupLocation: doc["pickupLocation"],
      destinationLocation: doc["destinationLocation"],
      departureTime: doc["departureTime"],
      availableSeats: doc["availableSeats"],
      bookedSeats: doc["bookedSeats"],
      tripPrice: doc["tripPrice"],
      isLiftCompleted: doc["isLiftCompleted"],
    );
  }
}