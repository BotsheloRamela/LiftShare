import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String? uid;
  final String? displayName;
  final String? email;
  final String? photoURL;
  final double? cash;

  AppUser({this.uid, this.displayName, this.email, this.photoURL, this.cash});

  factory AppUser.fromDocument(DocumentSnapshot doc) {
    return AppUser(
      uid: doc["uid"],
      displayName: doc["name"],
      email: doc["email"],
      photoURL: doc["profilePhoto"],
      cash: doc["cash"],
    );
  }

  // factory AppUser.fromMap(Map<String, dynamic> data) {
  //   return AppUser(
  //     uid: data['uid'],
  //     displayName: data['displayName'],
  //     email: data['email'],
  //     photoURL: data['photoURL'],
  //     cash: data['cash'],
  //   );
  // }
}