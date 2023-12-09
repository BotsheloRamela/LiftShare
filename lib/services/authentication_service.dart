
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();

  factory FirebaseAuthService() {
    return _instance;
  }

  FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(name);
        DocumentSnapshot doc = await _firestore.collection("users").doc(user.uid).get();
        if (!doc.exists) {
          await _firestore.collection("users").doc(user.uid).set({
            "uid": user.uid,
            "name": name,
            "email": email,
            "profilePhoto": user.photoURL,
            "cash": 0.0,
          });
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        throw Exception('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('The email address is not valid.');
        throw Exception('The email address is not valid.');
      } else if (e.code == 'invalid-password') {
        print('The password is not valid.');
        throw Exception('The password is not valid.');
      } else {
        print(e);
        throw Exception('An error occurred while signing up.');
      }
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection("users").doc(user.uid).get();
        if (!doc.exists) {
          return null;
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'ERROR_USER_NOT_FOUND' || e.code == "user-not-found") {
        print('User not found.');
        throw Exception('User not found.');
      } else if (e.code == 'ERROR_USER_DISABLED' || e.code == "user-disabled") {
        print('Account has been disabled.');
        throw Exception('Account has been disabled.');
      } else if (e.code == 'ERROR_TOO_MANY_REQUESTS') {
        print('Too many requests. Try again later.');
        throw Exception('Too many requests. Try again later.');
      } else if (e.code == 'ERROR_OPERATION_NOT_ALLOWED') {
        print('Signing in with Email and Password is not enabled.');
        throw Exception('Signing in with Email and Password is not enabled.');
      } else if (e.code == 'ERROR_INVALID_EMAIL' || e.code == "invalid-email") {
        print('The email address is not valid.');
        throw Exception('The email address is not valid.');
      } else if (e.code == 'ERROR_WRONG_PASSWORD' || e.code == "wrong-password") {
        print('The password is not valid.');
        throw Exception('The password is not valid.');
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        print('Invalid login credentials.');
        throw Exception('Invalid login credentials.');
      } else {
        print(e.code);
        throw Exception('An error occurred while signing in.');
      }
    }
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);

        DocumentSnapshot doc = await _firestore.collection("users").doc(googleUser.id).get();
        if (!doc.exists) {
          await _firestore.collection("users").doc(googleUser.id).set({
            "uid": googleUser.id,
            "name": googleUser.displayName,
            "email": googleUser.email,
            "profilePhoto": googleUser.photoUrl,
            "cash": 0.0,
          });
        }
      }

      return _auth.currentUser;
    } catch (e) {
      throw Exception('An error occurred while signing in with Google.');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('An error occurred while signing out.');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('An error occurred while resetting password.');
    }
  }

  Future<void> deleteUser() async {
    try {
      await _auth.currentUser!.delete();
    } catch (e) {
      throw Exception('An error occurred while deleting user.');
    }
  }
}