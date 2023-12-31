
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
          .where("liftStatus", isEqualTo: "pending")
          .get();

      List<Lift> lifts = querySnapshot.docs.map((doc) {
        Lift lift = Lift.fromDocument(doc);
        return lift;
      }).toList();

      return lifts;
    } catch (e) {
      print('Error getting upcoming lifts: $e');
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
      print('Error getting offered lifts: $e');
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

  Future<bool> cancelLift(String liftId) async {
    try {
      await _firestore.collection("lifts").doc(liftId).update({
        "liftStatus": "cancelled",
      });
      return true;
    } catch (e) {
      print('Error cancelling lift: $e');
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

        lift.bookingTime = doc["bookedAt"];
        lifts.add(lift);
      }

      return lifts;
    } catch (e) {
      print('Error getting bookings: $e');
      return [];
    }
  }

  Future<List<Lift>> getAvailableLifts(String userId, String? destination) async {
    final liftsCollection = _firestore.collection("lifts");
    final bookingsCollection = _firestore.collection("bookings");
    List<Lift> availableLifts = [];

    try {
      var liftsSnapshot = await liftsCollection.get();
      var bookingsSnapshot = await bookingsCollection.where("userId", isEqualTo: userId).get();

      for (var doc in liftsSnapshot.docs) {
        Lift lift = Lift.fromDocument(doc);

        // NOTE: We're avoiding Firebase queries for certain conditions due to a recurring
        // "[cloud_firestore/failed-precondition] The query requires an index" error. Fetching
        // all lifts and bookings once and filtering locally helps circumvent this issue.

        if (doc["driverId"] != userId &&
            (destination != null && doc["destinationLocationName"] == destination ||
                destination == null && doc["liftStatus"] == "pending") &&
            doc["bookedSeats"] < doc["availableSeats"] &&
            bookingsSnapshot.docs
                .where((bookingDoc) => bookingDoc["liftId"] == doc.id)
                .isEmpty) {
          availableLifts.add(lift);
        }
      }

      return availableLifts;
    } catch (e) {
      print('Error getting available lifts: $e');
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
        "bookedAt": Timestamp.now(),
      });
      await _firestore.collection("lifts").doc(liftId).update({
        "bookedSeats": FieldValue.increment(1),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelBooking(String liftId, String userId) async {
    try {
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

  Future<void> deleteUserData(String userId) async {
    try {
      final bookingsCollection = _firestore.collection("bookings");
      final liftsCollection = _firestore.collection("lifts");

      var liftsSnapshot = await liftsCollection
          .where("driverId", isEqualTo: userId)
          .get();

      for (var doc in liftsSnapshot.docs) {
        if (doc["liftStatus"] == "pending") {
          await liftsCollection.doc(doc.id).update({
            "liftStatus": "cancelled",
          });
        }
      }

      var bookingsSnapshot = await _firestore
          .collection("bookings")
          .where("userId", isEqualTo: userId)
          .get();

      for (var doc in bookingsSnapshot.docs) {
        var liftDoc = await liftsCollection.doc(doc["liftId"]).get();
        if (liftDoc["liftStatus"] == "pending") {
          await liftsCollection.doc(doc["liftId"]).update({
            "bookedSeats": FieldValue.increment(-1),
          });
        }
        await bookingsCollection.doc(doc.id).delete();
      }
    } catch (e) {
      print('Error deleting user data: $e');
    }
  }

  Future<void> completeLift(String liftId) async {
    try {
      final bookingsCollection = _firestore.collection("bookings");
      final liftsCollection = _firestore.collection("lifts");

      var bookingsSnapshot = await bookingsCollection
          .where("liftId", isEqualTo: liftId)
          .get();

      var liftDoc = await liftsCollection.doc(liftId).get();

      num tripPrice = liftDoc["tripPrice"];
      num bookedSeats = liftDoc["bookedSeats"];

      num amountToDeduct = tripPrice / bookedSeats;

      if (bookingsSnapshot.docs.isNotEmpty) {
        for (var doc in bookingsSnapshot.docs) {
          await bookingsCollection.doc(doc.id).update({
            "paid": true,
          });

          var userDoc = await _firestore.collection("users").doc(doc["userId"]).get();
          num userCash = userDoc["cash"];
          num newCash = userCash - amountToDeduct;
          await _firestore.collection("users").doc(doc["userId"]).update({
            "cash": newCash,
          });
        }

        var driverDoc = await _firestore.collection("users").doc(liftDoc["driverId"]).get();
        num driverCash = driverDoc["cash"];
        num newDriverCash = driverCash + tripPrice;
        await _firestore.collection("users").doc(liftDoc["driverId"]).update({
          "cash": newDriverCash,
        });
      }

      await liftsCollection.doc(liftId).update({
        "liftStatus": "completed",
      });

    } catch (e) {
      print('Error completing lift: $e');
      rethrow;
    }
  }
}