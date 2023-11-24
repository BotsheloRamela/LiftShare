
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

      List<Lift> lifts = querySnapshot.docs.map((doc) => Lift.fromDocument(doc)).toList();

      return lifts;
    } catch (e) {
      print('Error searching lifts: $e');
      return [];
    }
  }
}