import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liftshare/viewmodels/base_lift_viewmodel.dart';

import '../../utils/constants.dart';

class LocationInputForm<T extends BaseLiftViewModel> extends StatelessWidget {
  final T viewModel;

  const LocationInputForm({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          'assets/icons/trip_line_icon.svg',
          height: 80,
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            children: [
              TextField(
                controller: viewModel.pickupLocationController,
                focusNode: viewModel.pickupLocationFocusNode,
                onChanged: (value) {
                  viewModel.setActiveLocationController(viewModel.pickupLocationController);
                  viewModel.searchPlace(value);
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Pickup location',
                  filled: true,
                  fillColor: AppColors.buttonColor,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: const TextStyle(
                    color: AppColors.highlightColor,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: 'Aeonik',
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.enabledBorderColor,
                        width: 1.5,
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
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: viewModel.destinationLocationController,
                focusNode: viewModel.destinationLocationFocusNode,
                onChanged: (value) {
                  viewModel.setActiveLocationController(viewModel.destinationLocationController);
                  viewModel.searchPlace(value);
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Destination',
                  filled: true,
                  fillColor: AppColors.buttonColor,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: const TextStyle(
                    color: AppColors.highlightColor,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: 'Aeonik',
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.enabledBorderColor,
                        width: 1.5,
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
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
