
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liftshare/data/models/lift.dart';
import 'package:liftshare/utils/constants.dart';

class LiftRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Lift>> searchLifts(String pickupLocation, String destinationLocation) async {
    try {
      var querySnapshot = await _firestore
          .collection("lifts")
          .where("pickupLocation", isEqualTo: pickupLocation)
          .where("destinationLocation", isEqualTo: destinationLocation)
          .get();

      List<Lift> lifts = querySnapshot.docs.map((doc) => Lift.fromDocument(doc)).toList();

      return lifts;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Lift>> getUpcomingLiftsByUserId(String userId) async {
    try {
      var querySnapshot = await _firestore
          .collection("lifts")
          .where("driverId", isEqualTo: userId)
          .where("isLiftCompleted", isEqualTo: false)
          .get();

      List<Lift> lifts = querySnapshot.docs.map((doc) {
        Lift lift = Lift.fromDocument(doc);
        return lift;
      }).toList();

      return lifts;
    } catch (e) {
      // print('Error searching lifts: $e');
      return [];
    }
  }

  Future<List<Lift>> getOfferedLiftsByUserId(String userId) async {
    try {
      var querySnapshot = await _firestore
          .collection("lifts")
          .where("driverId", isEqualTo: userId)
          .get();

      List<Lift> lifts = querySnapshot.docs.map((doc) {
        Lift lift = Lift.fromDocument(doc);
        return lift;
      }).toList();

      return lifts;
    } catch (e) {
      // print('Error searching lifts: $e');
      return [];
    }
  }

  Future<void> createLift(Lift lift) async {
    try {
      await _firestore.collection("lifts").add(lift.toJson());
    } catch (e) {
      print('Error creating lift: $e');
    }
  }

  Future<bool> deleteLift(String liftId) async {
    try {
      await _firestore.collection("lifts").doc(liftId).delete();
      return true;
    } catch (e) {
      print('Error deleting lift: $e');
      return false;
    }
  }

  Future<List<Lift>> getBookingsByUserId(String userId) async {
    try {
      var querySnapshot = await _firestore
          .collection("bookings")
          .where("userId", isEqualTo: userId)
          .get();

      List<Lift> lifts = [];

      for (var doc in querySnapshot.docs) {

        var liftQuerySnapshot = await _firestore
            .collection("lifts")
            .doc(doc["liftId"])
            .get();

        Lift lift = Lift.fromDocument(liftQuerySnapshot);

        lifts.add(lift);
      }

      return lifts;
    } catch (e) {
      return [];
    }
  }

  Future<List<Lift>> getAvailableLifts(String userId, String? destination) async {
    final liftsCollection = _firestore.collection("lifts");
    final bookingsCollection = _firestore.collection("bookings");
    List<Lift> availableLifts = [];

    try {
      var liftsQuery = liftsCollection.where("isLiftCompleted", isEqualTo: false);

      if (destination != null) {
        liftsQuery = liftsQuery.where("destinationLocationName", isEqualTo: destination);
      } else {
        liftsQuery = liftsQuery.where("driverId", isNotEqualTo: userId);
      }

      var liftsSnapshot = await liftsQuery.get();

      for (var doc in liftsSnapshot.docs) {
        if (doc["driverId"] != userId && doc["bookedSeats"] < doc["availableSeats"]) {
          Lift lift = Lift.fromDocument(doc);

          // Check if the lift is already booked by the current user
          var bookingQuerySnapshot = await bookingsCollection
              .where("liftId", isEqualTo: lift.documentId)
              .where("userId", isEqualTo: userId)
              .get();

          // If the lift is not booked by the current user, add it to the list of available lifts
          if (bookingQuerySnapshot.docs.isEmpty) {
            availableLifts.add(lift);
          }
        }
      }

      return availableLifts;
    } catch (e) {
      // print('Error getting available lifts: $e');
      return [];
    }
  }

  Future<String> getUserImage(String userId) async {
    try {
      var querySnapshot = await _firestore
          .collection("users")
          .where("uid", isEqualTo: userId)
          .get();

      String? userImage = querySnapshot.docs.map((doc) => doc["profilePhoto"]).toList()[0];

      userImage ??= AppValues.defaultUserImg;

      return userImage;
    } catch (e) {
      return AppValues.defaultUserImg;
    }
  }

  Future<String> getUserName(String userId) async {
    try {
      var querySnapshot = await _firestore
          .collection("users")
          .where("uid", isEqualTo: userId)
          .get();

      String? userName = querySnapshot.docs.map((doc) => doc["name"]).toList()[0];

      return userName ?? "Unknown";
    } catch (e) {
      return "Unknown";
    }
  }

  Future<void> bookLift(String liftId, String userId) async {
    try {
      await _firestore.collection("bookings").add({
        "liftId": liftId,
        "userId": userId,
        "paid": false,
      });
      await _firestore.collection("lifts").doc(liftId).update({
        "bookedSeats": FieldValue.increment(1),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelLift(String liftId, String userId) async {
    try {
      // delete the booking from the bookings collection where the liftId and userId match
      var querySnapshot = await _firestore
          .collection("bookings")
          .where("liftId", isEqualTo: liftId)
          .where("userId", isEqualTo: userId)
          .get();
      querySnapshot.docs.forEach((doc) async {
        await _firestore.collection("bookings").doc(doc.id).delete();
      });


      await _firestore.collection("lifts").doc(liftId).update({
        "bookedSeats": FieldValue.increment(-1),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isLiftBooked(String liftId, String userId) async {
    try {
      var querySnapshot = await _firestore
          .collection("bookings")
          .where("liftId", isEqualTo: liftId)
          .where("userId", isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking if lift is booked: $e');
      return false;
    }
  }
}