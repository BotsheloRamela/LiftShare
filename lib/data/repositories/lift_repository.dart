
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liftshare/data/models/lift.dart';

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
      print('Error searching lifts: $e');
      return [];
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
        lift.documentId = doc.id;
        return lift;
      }).toList();

      return lifts;
    } catch (e) {
      print('Error searching lifts: $e');
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
}