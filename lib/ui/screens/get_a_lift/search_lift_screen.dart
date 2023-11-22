import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liftshare/ui/widgets/default_app_bar.dart';

import '../../../utils/constants.dart';
import '../../widgets/app_background.dart';

class SearchForLiftScreen extends StatefulWidget {
  const SearchForLiftScreen({super.key});

  @override
  State<SearchForLiftScreen> createState() => _SearchForLiftScreenState();
}

class _SearchForLiftScreenState extends State<SearchForLiftScreen> {

  final _pickupLocationController = TextEditingController();
  final _destinationLocationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: defaultAppBar(context, "Search for a Lift"),
        body: DecoratedBox(
          decoration: appBackground(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppValues.screenPadding, AppValues.screenPadding,
                AppValues.screenPadding, 0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  tripInfo(_pickupLocationController, _destinationLocationController),
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.highlightColor, thickness: 1),
                  const SizedBox(height: 20),
                  locationItem("BCX Head Office", "150 Rivonia Road, Sandton, 2196", "2021-10-10", "08:00", 2, 4),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}

Widget tripInfo(TextEditingController pickupLocationController, TextEditingController destinationLocationController) {
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
              controller: pickupLocationController,
              keyboardType: TextInputType.emailAddress,
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
              controller: pickupLocationController,
              keyboardType: TextInputType.emailAddress,
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

Widget locationItem(String location, String address, String date, String time, int seatsAvailable, int seatsTotal) {
  return Row(
    children: [
      SvgPicture.asset("assets/icons/location_icon.svg", height: 24,),
      const SizedBox(width: 20),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
              fontFamily: 'Aeonik',
            ),
          ),
          const SizedBox(height: 5),
          Text(
            address,
            style: const TextStyle(
              color: AppColors.highlightColor,
              fontSize: 16,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
              fontFamily: 'Aeonik',
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "$date - $time • $seatsAvailable/$seatsTotal Seats Available",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
              fontFamily: 'Aeonik',
            ),
          ),
        ],
      ),
    ],
  );
}