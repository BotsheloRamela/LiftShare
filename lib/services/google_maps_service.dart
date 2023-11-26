import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GoogleMapsService {

  Future<String?> getCurrentLocation() async {
    // TODO: Implement logic to get the user's current location using the device's location services.
    // TODO: Return the address or location details.
    // This can be achieved using packages like location.
    return null;
  }

  Future<String?> fetchPlace(Uri uri, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception("Failed to fetch location");
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }


  Future<String?> searchPlace(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/autocomplete/json",
      {
        "input": query,
        "key": dotenv.get("ANDROID_FIREBASE_API_KEY"),
      },
    );

    return fetchPlace(uri);
  }


  Future<String> getLocationName(String placeId) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/details/json",
      {
        "place_id": placeId,
        "fields": "name",
        "key": dotenv.get("ANDROID_FIREBASE_API_KEY"),
      },
    );

    String? response = await fetchPlace(uri);
    if (response != null) {
      // Parse the JSON response
      Map<String, dynamic> jsonResponse = json.decode(response);

      if (jsonResponse["status"] == "OK") {
        // Get the name of the location
        String locationName = jsonResponse["result"]["name"];
        return locationName;
      } else {
        throw Exception("Failed to fetch location details");
      }
    } else {
      throw Exception("Failed to fetch location details");
    }
  }


  Future<GeoPoint> getLocationCoordinates(String placeId) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/details/json",
      {
        "place_id": placeId,
        "fields": "geometry",
        "key": dotenv.get("ANDROID_FIREBASE_API_KEY"),
      },
    );

    String? response = await fetchPlace(uri);
    if (response != null) {
      // Parse the JSON response
      Map<String, dynamic> jsonResponse = json.decode(response);

      if (jsonResponse["status"] == "OK") {
        // Get the location coordinates
        GeoPoint locationCoordinates = GeoPoint(
          jsonResponse["result"]["geometry"]["location"]["lat"],
          jsonResponse["result"]["geometry"]["location"]["lng"],
        );
        return locationCoordinates;
      } else {
        throw Exception("Failed to fetch location details");
      }
    } else {
      throw Exception("Failed to fetch location details");
    }
  }


  Future<String> getLocationPhotoReference(String placeId) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/details/json",
      {
        "place_id": placeId,
        "fields": "photo",
        "key": dotenv.get("ANDROID_FIREBASE_API_KEY"),
      },
    );

    String? response = await fetchPlace(uri);
    if (response != null) {
      // Parse the JSON response
      Map<String, dynamic> jsonResponse = json.decode(response);

      if (jsonResponse["status"] == "OK") {
        // Get the first photo reference
        List<dynamic> photos = jsonResponse["result"]["photos"];
        if (photos.isNotEmpty) {
          String firstPhotoReference = photos[0]["photo_reference"];
          return firstPhotoReference;
        } else {
          throw Exception("No photos available for this location");
        }
      } else {
        throw Exception("Failed to fetch location details");
      }
    } else {
      throw Exception("Failed to fetch location details");
    }
  }

  Future<String> getLocationPhoto(String placeId) async {
    String photoReference = await getLocationPhotoReference(placeId);

    Uri uri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/photo",
      {
        "maxwidth": "400",
        "photo_reference": photoReference,
        "key": dotenv.get("ANDROID_FIREBASE_API_KEY"),
      },
    );

    return uri.toString();
  }

}