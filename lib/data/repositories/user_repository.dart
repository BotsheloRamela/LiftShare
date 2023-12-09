
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> incrementUserCash(String userId, double amount) async {
    try {
      await _firestore.collection("users").doc(userId).update({
        "cash": FieldValue.increment(amount)
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deductUserCash(String userId, double amount) async {
    try {
      await _firestore.collection("users").doc(userId).update({
        "cash": FieldValue.increment(-amount)
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getUserCash(String userId) async {
    try {
      final DocumentSnapshot userDoc = await _firestore.collection("users").doc(userId).get();
      final double cash = userDoc.get("cash").toDouble();
      return cash;
    } catch (e) {
      print("Error getting user cash: $e");
      rethrow;
    }
  }
}