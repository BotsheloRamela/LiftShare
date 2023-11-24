import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants.dart';
import '../../../viewmodels/offer_lift_viewmodel.dart';
import '../../widgets/app_background.dart';
import '../../widgets/default_app_bar.dart';
import '../../widgets/location_input_form.dart';

class OfferLiftScreen extends StatefulWidget {
  const OfferLiftScreen({super.key});

  @override
  State<OfferLiftScreen> createState() => _OfferLiftScreenState();
}

class _OfferLiftScreenState extends State<OfferLiftScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OfferLiftViewModel>(
          create: (context) => OfferLiftViewModel(),
        ),
      ],
      builder: (context, child) {
        return SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: defaultAppBar(context, "Offer for a Lift"),
            body: DecoratedBox(
              decoration: appBackground(),
              child: Padding(
                padding:  const EdgeInsets.fromLTRB(
                    AppValues.screenPadding, AppValues.screenPadding,
                    AppValues.screenPadding, 0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      const SizedBox(height: 70),
                      LocationInputForm<OfferLiftViewModel>(viewModel: context.watch<OfferLiftViewModel>()),
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.highlightColor, thickness: 1),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            ),
          ),
        );
      }
    );
  }
}
