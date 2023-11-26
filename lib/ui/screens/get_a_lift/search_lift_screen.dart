import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liftshare/ui/widgets/default_app_bar.dart';
import 'package:liftshare/ui/widgets/location_input_form.dart';
import 'package:liftshare/viewmodels/search_lift_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/constants.dart';
import '../../widgets/app_background.dart';
import '../../widgets/location_list_item.dart';

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
        viewModel.setLiftsSearchCallback(() => _displayBottomSheet(context));
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
                        LocationInputForm<SearchForLiftViewModel>(viewModel: context.watch<SearchForLiftViewModel>()),
                        const SizedBox(height: 20),
                        const Divider(color: AppColors.highlightColor, thickness: 1),
                        const SizedBox(height: 20),
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
  
  Future<void> _displayBottomSheet(BuildContext context) {
    // TODO: Add functionality to check if lifts are available or not and display appropriate message
    // TODO: If there are lifts available, display them in a list
    return showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.buttonColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppValues.largeBorderRadius),
            topRight: Radius.circular(AppValues.largeBorderRadius),
          ),
        ),
        builder: (context) => SizedBox(
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Lottie.asset(
                'assets/animations/not_found.json',
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              const Text(
                "Oops, no lifts available for this trip",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Try searching for another trip",
                style: TextStyle(
                  color: AppColors.highlightColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
            ],
          ),
        )
    );
  }
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


