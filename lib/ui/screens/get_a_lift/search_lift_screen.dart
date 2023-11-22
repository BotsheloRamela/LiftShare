import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liftshare/data/models/place_autocomplete_response.dart';
import 'package:liftshare/ui/widgets/default_app_bar.dart';

import '../../../data/models/autocomplete_prediction.dart';
import '../../../services/google_maps_service.dart';
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

  List<AutocompletePrediction> placePredictions = [];

  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/autocomplete/json",
      {
        "input": query,
        "key": dotenv.get("ANDROID_FIREBASE_API_KEY")
      }
    );
    String? response = await GoogleMapsService().fetchPlace(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);

      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

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
                  tripInfo(
                    placeAutocomplete,
                    _pickupLocationController,
                    _destinationLocationController),
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.highlightColor, thickness: 1),
                  const SizedBox(height: 20),
                  // TODO: Replace with ListView.builder
                  // TODO: If there's no specified location then show a button to set location on a map
                  // TODO: If there's no trip/lift available then display a "No trips/lifts available" message
                  // locationListItem("BCX Head Office", "150 Rivonia Road, Sandton, 2196", "2021-10-10", "08:00", 2, 4),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      itemCount: placePredictions.length,
                      itemBuilder: (context, index) {
                        return locationListItem(
                          placePredictions[index].description as String,
                          "2021-10-10", "08:00", 2, 4,
                          context
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}

Widget tripInfo(
  Function(String) placeAutocomplete,
  TextEditingController pickupLocationController,
  TextEditingController destinationLocationController,
  ) {
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
              onChanged: (value) => placeAutocomplete(value),
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
              controller: destinationLocationController,
              onChanged: (value) => placeAutocomplete(value),
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


Widget locationListItem(
    String location,
    String date,
    String time,
    int seatsAvailable,
    int seatsTotal,
    BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          SvgPicture.asset("assets/icons/location_icon.svg", height: 24,),
          const SizedBox(width: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  maxLines: 2,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
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
                  "$date - $time",
                  style: const TextStyle(
                    color: AppColors.highlightColor,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: 'Aeonik',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "$seatsAvailable/$seatsTotal Seats Available",
                  style: const TextStyle(
                    color: AppColors.gradientColor2,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontFamily: 'Aeonik',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Divider(color: AppColors.enabledBorderColor, thickness: 1),
      const SizedBox(height: 10),
    ],
  );
}