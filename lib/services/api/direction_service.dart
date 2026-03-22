import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class RouteResponse {
  final List<LatLng> points;
  final String durationText;
  final int durationValue; // in seconds

  const RouteResponse({
    required this.points,
    required this.durationText,
    required this.durationValue,
  });
}

class DirectionService {
  Future<RouteResponse> getRoute(LatLng origin, LatLng destination) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$kGoogleMapsApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final route = data['routes'][0];
          final pointsString = route['overview_polyline']['points'];
          final leg = route['legs'][0];
          
          return RouteResponse(
            points: _decodePolyline(pointsString),
            durationText: leg['duration']['text'] as String,
            durationValue: leg['duration']['value'] as int,
          );
        } else {
          print('Directions API error: ${data['status']} - ${data['error_message']}');
        }
      }
    } catch (e) {
      print('Error fetching directions: $e');
    }
    
    // Fallback to straight line and default duration if API fails
    return RouteResponse(
      points: [origin, destination],
      durationText: '15 mins',
      durationValue: 900,
    );
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
}
