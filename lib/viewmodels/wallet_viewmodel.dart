
import 'package:flutter/cupertino.dart';
import 'package:liftshare/data/repositories/user_repository.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class WalletViewModel extends ChangeNotifier {
  final String _userID;
  final String _userEmail;
  final PaystackPlugin plugin;

  WalletViewModel(this._userID, this._userEmail, this.plugin);

  num _cash = 0;
  num get cash => _cash;

  bool _isPaymentSuccessful = false;
  bool get isPaymentSuccessful => _isPaymentSuccessful;

  final UserRepository _userRepository = UserRepository();

  void getCash() async {
    _cash = await _userRepository.getUserCash(_userID);
    notifyListeners();
  }

  Future<void> makePayment(BuildContext context, double amount) async {
    try {
      CheckoutResponse response = await makePayStackPayment(context, amount);
      if (response.status) {
        await _userRepository.incrementUserCash(_userID ,amount);
        getCash();
        _isPaymentSuccessful = true;
        notifyListeners();
      } else {
        throw Exception("Payment failed");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CheckoutResponse> makePayStackPayment(BuildContext context, double amount) async {
    try {
      Charge charge = Charge()
        ..amount = amount.toInt() * 100
        ..email = _userEmail
        ..reference = _getReference()
        ..currency = "ZAR";

      CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  String _getReference() {
    return 'TX-${DateTime.now().millisecondsSinceEpoch}';
  }
}