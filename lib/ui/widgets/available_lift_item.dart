
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

Widget availableLiftItem(
    String locationImageUrl,
    String locationName,
    String date,
    int bookedSeats,
    int availableSeats,
    ) {
  return Container(
    height: 80,
    width: double.infinity,
    padding: const EdgeInsets.all(2),
    margin: const EdgeInsets.only(bottom: 15),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(AppValues.largeBorderRadius - 6)),
      gradient: AppColors.lightGradientBackground,
    ),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppValues.largeBorderRadius - 6)),
        color: AppColors.buttonColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(locationImageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locationName,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  fontFamily: 'Aeonik',
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            "$bookedSeats/$availableSeats",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
              fontFamily: 'Aeonik',
            ),
          )
        ],
      ),
    ),
  );
}