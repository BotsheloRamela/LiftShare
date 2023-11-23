import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liftshare/ui/widgets/default_app_bar.dart';
import 'package:liftshare/viewmodels/search_lift_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants.dart';
import '../../widgets/app_background.dart';

class SearchForLiftScreen extends StatefulWidget {
  const SearchForLiftScreen({super.key});

  @override
  State<SearchForLiftScreen> createState() => _SearchForLiftScreenState();
}

class _SearchForLiftScreenState extends State<SearchForLiftScreen> {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchForLiftViewModel>(
          create: (_) => SearchForLiftViewModel(),
        ),
      ],
      builder: (context, child) {
         final viewModel = context.watch<SearchForLiftViewModel>();
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
                        tripInfo(context.watch<SearchForLiftViewModel>()),
                        const SizedBox(height: 20),
                        const Divider(color: AppColors.highlightColor, thickness: 1),
                        const SizedBox(height: 20),
                        // TODO: If there's no specified location then show a button to set location on a map
                        // TODO: If there's no trip/lift available then display a "No trips/lifts available" message
                        viewModel.pickupLocationController.text.isNotEmpty
                            || viewModel.destinationLocationController.text.isNotEmpty
                            ? Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            itemCount: viewModel.placePredictions.length,
                            itemBuilder: (context, index) {
                              return locationListItem(viewModel, index, context);
                            },
                          ),
                        )
                            : setLocationOnMapButton(context),
                      ],
                    ),
                  )
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget tripInfo(
    SearchForLiftViewModel viewModel
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
              controller: viewModel.pickupLocationController,
              focusNode: viewModel.pickupLocationFocusNode,
              onChanged: (value) {
                viewModel.setActiveLocationController(viewModel.pickupLocationController);
                viewModel.placeAutocomplete(value);
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
                viewModel.placeAutocomplete(value);
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


Widget locationListItem(
    SearchForLiftViewModel viewModel,
    int index,
    BuildContext context
  ) {
  return GestureDetector(
    onTap: () => viewModel.onLocationSelected(
        viewModel.placePredictions[index].structuredFormatting.mainText,
        context
    ),
    child: Column(
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
                    viewModel.placePredictions[index].structuredFormatting.mainText,
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
                    viewModel.placePredictions[index].structuredFormatting.secondaryText,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.highlightColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
    ),
  );
}

Widget setLocationOnMapButton(BuildContext context,) {
  return Column(
    children: [
      Row(
        children: [
          SvgPicture.asset("assets/icons/location_icon.svg", height: 24,),
          const SizedBox(width: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: const Text(
              "Set location on map",
              maxLines: 2,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
                fontFamily: 'Aeonik',
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
    ],
  );
}