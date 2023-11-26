
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/constants.dart';
import '../../viewmodels/base_lift_viewmodel.dart';

Widget locationListItem(
    BaseLiftViewModel viewModel,
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