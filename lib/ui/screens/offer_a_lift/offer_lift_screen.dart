import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants.dart';
import '../../../viewmodels/offer_lift_viewmodel.dart';
import '../../widgets/action_button.dart';
import '../../widgets/app_background.dart';
import '../../widgets/default_app_bar.dart';
import '../../widgets/location_input_form.dart';
import '../../widgets/location_list_item.dart';

class OfferLiftScreen extends StatefulWidget {
  final String userUid;

  const OfferLiftScreen({super.key, required this.userUid});

  @override
  State<OfferLiftScreen> createState() => _OfferLiftScreenState();
}

class _OfferLiftScreenState extends State<OfferLiftScreen> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OfferLiftViewModel>(
          create: (context) => OfferLiftViewModel(widget.userUid),
        ),
      ],
      builder: (context, child) {
        final OfferLiftViewModel viewModel =
            Provider.of<OfferLiftViewModel>(context, listen: false);
        return SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: defaultAppBar(context, "Offer a Lift"),
            body: DecoratedBox(
              decoration: appBackground(),
              child: Padding(
                padding:  const EdgeInsets.fromLTRB(
                    AppValues.screenPadding, AppValues.screenPadding,
                    AppValues.screenPadding, 0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 70),
                      LocationInputForm<OfferLiftViewModel>(
                          viewModel: context.watch<OfferLiftViewModel>()
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.highlightColor, thickness: 1),
                      const SizedBox(height: 20),
                      viewModel.pickupLocationController.text.isEmpty
                        || viewModel.destinationLocationController.text.isEmpty
                        || !viewModel.isPickupLocationSelected
                        || !viewModel.isDestinationLocationSelected
                        ? Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              itemCount: viewModel.placePredictions.length,
                              itemBuilder: (context, index) {
                                return locationListItem(viewModel, index, context);
                              },
                            ),
                          ) :
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                                'Departure Date',
                                style: TextStyle(
                                    color: AppColors.highlightColor, fontSize: 18)),
                            const SizedBox(height: 10),
                            departureDateButton(context, viewModel),
                            const SizedBox(height: 30),
                            additionalLiftInfoInputs(viewModel),
                            const Spacer(),
                            const Text(
                              "Note: Lift cost will be shared equally among passengers.",
                              style: TextStyle(
                                color: AppColors.highlightColor,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                                fontFamily: 'Aeonik',
                              ),
                            ),
                            const SizedBox(height: 30),
                            actionButton('Offer Lift', () {
                              viewModel.createLift();
                              Navigator.pop(context);
                            }),
                            const SizedBox(height: 20),
                          ],
                        ),
                      )
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

  Container departureDateButton(BuildContext context, OfferLiftViewModel viewModel) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(AppValues.largeBorderRadius)),
        color: AppColors.buttonColor,
        border: Border.fromBorderSide(
            BorderSide(color: AppColors.enabledBorderColor, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DateFormat('dd MMM y \'at\' HH:mm').format(viewModel.getSelectedDate),
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Aeonik', fontSize: 18
            )
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              DatePickerBdaya.showDateTimePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  onConfirm: (date) => viewModel.setLiftDate(date),
                  currentTime: DateTime.now(), locale: LocaleType.en,
                  theme: const DatePickerThemeBdaya(
                    backgroundColor: AppColors.buttonColor,
                    itemStyle: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold, fontSize: 18),
                    cancelStyle: TextStyle(color: AppColors.warningColor,
                        fontWeight: FontWeight.bold, fontSize: 18),
                  )
              );
            },
            icon: const Icon(
              Icons.edit_calendar,
              color: AppColors.highlightColor,
              size: 24,
            ),
          )
        ],
      ),
    );
  }

  Row additionalLiftInfoInputs(OfferLiftViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Lift Price',
                  style: TextStyle(
                      color: AppColors.highlightColor, fontSize: 18)),
              const SizedBox(height: 10),
              TextField(
                controller: viewModel.liftPriceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Aeonik',
                    fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'ZAR 0.00',
                  filled: true,
                  fillColor: AppColors.buttonColor,
                  hintStyle: const TextStyle(
                      color: AppColors.highlightColor,
                      fontFamily: 'Aeonik',
                      fontSize: 18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
                    borderSide: BorderSide(
                        color: AppColors.enabledBorderColor,
                        width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
                    borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Available Seats',
                  style: TextStyle(
                      color: AppColors.highlightColor, fontSize: 18)),
              const SizedBox(height: 10),
              TextField(
                controller: viewModel.liftSeatsController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[1-4]$'))
                ],
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Aeonik',
                    fontSize: 18),
                decoration: InputDecoration(
                  hintText: '1-4',
                  filled: true,
                  fillColor: AppColors.buttonColor,
                  hintStyle: const TextStyle(
                      color: AppColors.highlightColor,
                      fontFamily: 'Aeonik',
                      fontSize: 18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
                    borderSide: BorderSide(
                        color: AppColors.enabledBorderColor,
                        width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
                    borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
