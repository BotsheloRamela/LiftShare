
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(name);
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

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'ERROR_USER_NOT_FOUND') {
        print('The email address is not found.');
        throw Exception('No matching account found');
      } else if (e.code == 'ERROR_USER_DISABLED') {
        print('The user has been disabled.');
        throw Exception('The user has been disabled.');
      } else if (e.code == 'ERROR_TOO_MANY_REQUESTS') {
        print('Too many requests. Try again later.');
        throw Exception('Too many requests. Try again later.');
      } else if (e.code == 'ERROR_OPERATION_NOT_ALLOWED') {
        print('Signing in with Email and Password is not enabled.');
        throw Exception('Signing in with Email and Password is not enabled.');
      } else if (e.code == 'ERROR_INVALID_EMAIL') {
        print('The email address is not valid.');
        throw Exception('The email address is not valid.');
      } else if (e.code == 'ERROR_WRONG_PASSWORD') {
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
}