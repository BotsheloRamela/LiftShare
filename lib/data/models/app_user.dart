import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String? uid;
  final String? displayName;
  final String? email;
  final String? photoURL;

  AppUser({this.uid, this.displayName, this.email, this.photoURL});

  factory AppUser.fromDocument(DocumentSnapshot doc) {
    return AppUser(
      uid: doc["uid"],
      displayName: doc["displayName"],
      email: doc["email"],
      photoURL: doc["photoURL"],
    );
  }
}