
class PlacePrediction  {
  final String? description;
  final PlaceFormatting structuredFormatting;
  final String? placeId;
  final String? reference;

  PlacePrediction ({
    this.description,
    required this.structuredFormatting,
    this.placeId,
    this.reference
  });

  factory PlacePrediction .fromJson(Map<String, dynamic> json) {
    return PlacePrediction (
      description: json["description"],
      structuredFormatting: PlaceFormatting .fromJson(json["structured_formatting"]),
      placeId: json["place_id"],
      reference: json["reference"]
    );
  }
}

class PlaceFormatting {
  final String mainText;
  final String secondaryText;

  PlaceFormatting ({
    required this.mainText,
    required this.secondaryText
  });

  factory PlaceFormatting .fromJson(Map<String, dynamic> json) {
    return PlaceFormatting (
      mainText: json["main_text"],
      secondaryText: json["secondary_text"]
    );
  }
}