
import 'dart:convert';

import 'place_prediction.dart';

class PlaceAutocompleteResponse {

  final String? status;
  final List<PlacePrediction>? predictions;

  PlaceAutocompleteResponse({this.status, this.predictions});

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) =>
      PlaceAutocompleteResponse(
      status: json["status"] as String?,
        predictions: json["predictions"] != null
          ? List<PlacePrediction>.from(
              json["predictions"].map(
                    (json) => PlacePrediction.fromJson(json),
              ),
            )
          : null,
    );

    static PlaceAutocompleteResponse parseAutocompleteResult(String responseBody) {
      final parsed = json.decode(responseBody).cast<String, dynamic>();
      return PlaceAutocompleteResponse.fromJson(parsed);
    }
}