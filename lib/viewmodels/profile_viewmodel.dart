
import 'package:flutter/cupertino.dart';

import '../data/repositories/lift_repository.dart';
import '../services/authentication_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final String _userID;
  ProfileViewModel(this._userID);

  final LiftRepository _liftRepository = LiftRepository();
  FirebaseAuthService authService = FirebaseAuthService();

  Future<void> deleteAccount() async {
    await _liftRepository.deleteUserData(_userID);
    await authService.deleteUser();
  }

  Future<void> signOut() async {
    await authService.signOut();
  }
}