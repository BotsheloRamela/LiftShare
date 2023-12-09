import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:liftshare/ui/widgets/action_icon_button.dart';
import 'package:liftshare/viewmodels/wallet_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

import '../../../data/models/app_user.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/constants.dart';
import '../../widgets/app_background.dart';
import '../../widgets/home_app_bar.dart';

class WalletHomeScreen extends StatefulWidget {
  const WalletHomeScreen({super.key});

  @override
  State<WalletHomeScreen> createState() => _WalletHomeScreenState();
}

class _WalletHomeScreenState extends State<WalletHomeScreen> {
  late AppUser _user;
  PaystackPlugin plugin = PaystackPlugin();

  @override
  void initState() {
    super.initState();
    _getUser();
    plugin.initialize(publicKey: dotenv.get("PAYSTACK_API_PUBLIC_KEY"));
    setState(() {});
  }

  Future<void> _getUser() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _user = (userProvider.user)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WalletViewModel>(
          create: (_) => WalletViewModel(_user.uid ?? "", _user.email ?? "", plugin),
        )
      ],
      builder: (context, child) {
        final WalletViewModel viewModel = Provider.of<WalletViewModel>(context, listen: true);
        viewModel.getCash();

        return SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: homeAppBar(_user.photoURL, context),
            body: DecoratedBox(
              decoration: appBackground(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppValues.screenPadding, AppValues.screenPadding,
                    AppValues.screenPadding, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    const Text(
                      "Wallet",
                      style: TextStyle(
                        color: AppColors.highlightColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                        fontFamily: 'Aeonik',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(child: walletCard(viewModel)),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget walletCard(WalletViewModel viewModel) {
    return Container(
      height: 220,
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(AppValues.largeBorderRadius - 6)),
        gradient: AppColors.lightGradientBackground,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius - 6)),
          color: AppColors.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "LiftShare Cash",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
                fontFamily: 'Aeonik',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "R ${viewModel.cash}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
                fontFamily: 'Aeonik',
              ),
            ),
            const SizedBox(height: 30),

            GestureDetector(
              onTap: () {
                bottomPaymentCard(context, viewModel);
              },
              child: Container(
                width: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  gradient: AppColors.gradientBackground,
                ),
                padding: const EdgeInsets.all(2),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: AppColors.buttonColor,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Top Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                          fontFamily: 'Aeonik',
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            // TODO: Add a divider, then add Transaction History
          ],
        ),
      ),
    );
  }

  Future<void> bottomPaymentCard(BuildContext context, WalletViewModel viewModel) {
    TextEditingController amountController = TextEditingController();

    double height = 250;

    return showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppValues.largeBorderRadius),
            topRight: Radius.circular(AppValues.largeBorderRadius),
          ),
        ),
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Top Up Wallet",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                      fontFamily: 'Aeonik',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select an amount to top up your wallet",
                    style: TextStyle(
                      color: AppColors.highlightColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      fontFamily: 'Aeonik',
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            TextInputFormatter.withFunction(
                                  (oldValue, newValue) => newValue.copyWith(
                                text: newValue.text.replaceAll('.', ','),
                              ),
                            ),
                          ],
                          decoration: InputDecoration(
                            label: const Text("Amount"),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              fontFamily: 'Aeonik',
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.enabledBorderColor,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppValues.largeBorderRadius)
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(AppValues.largeBorderRadius)
                                )
                            ),
                            prefix: const Text("R "),
                            hintText: "50.00",
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                            fontFamily: 'Aeonik',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an amount';
                            }
                            return null;
                          },
                          onTap: () {
                            setState(() {
                              height = 450;
                            });
                          },
                          onEditingComplete: () {
                            setState(() {
                              height = 250;
                            });
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              height = 250;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          await viewModel.makePayment(context, double.parse(amountController.text));
                          if (viewModel.isPaymentSuccessful) {
                            setState(() {});
                          } else {
                            // TODO: Show error message with toastify
                          }
                        },
                        child: actionIconButton(
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                          60
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    return null;
  }

  String? _validateCVC(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVC is required';
    }
    return null;
  }
}
