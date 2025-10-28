import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:polyline_codec/polyline_codec.dart';

// Future<List<LatLng>> _getRouteBetween(LatLng from, LatLng to) async {
//   try {
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/directions/json?'
//             'origin=${from.latitude},${from.longitude}&'
//             'destination=${to.latitude},${to.longitude}&'
//             'key=AIzaSyAPKYx2O3dnXnFI3iA8XugOv9W__GAOLYg');
//
//     final response = await http.get(url);
//     if (response.statusCode != 200) return [];
//
//     final data = jsonDecode(response.body);
//     if (data['status'] != 'OK' || data['routes'].isEmpty) {
//       debugPrint('Route not found: ${data['status']}');
//       return [];
//     }
//
//     final pointsEncoded =
//     data['routes'][0]['overview_polyline']['points'] as String;
//
//     // Decode polyline and convert to LatLng list
//     final decodedPoints = PolylineCodec.decode(pointsEncoded);
//     return decodedPoints
//         .map((point) => LatLng(point[0].toDouble(), point[1].toDouble()))
//         .toList();
//   } catch (e) {
//     debugPrint('Error fetching route: $e');
//     return [];
//   }
// }

Future<List<LatLng>> _getRouteBetween(LatLng from, LatLng to) async {
  try {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${from.latitude},${from.longitude}&'
          'destination=${to.latitude},${to.longitude}&'
          'key=AIzaSyAPKYx2O3dnXnFI3iA8XugOv9W__GAOLYg', // ⚠️ Replace or use env
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      debugPrint('HTTP error: ${response.statusCode}');
      return [];
    }

    final data = jsonDecode(response.body);
    if (data['status'] != 'OK' || data['routes'].isEmpty) {
      debugPrint('Route not found: ${data['status']}');
      return [];
    }

    final pointsEncoded = data['routes'][0]['overview_polyline']['points'] as String;
    final decodedPoints = PolylineCodec.decode(pointsEncoded);

    return decodedPoints
        .map((point) => LatLng(point[0] / 1e5, point[1] / 1e5)) // ✅ Fix: divide by 1e5
        .toList();
  } catch (e) {
    debugPrint('Error fetching route: $e');
    return [];
  }
}

void main() async {
  LatLng pickupLocation = const LatLng(31.038525, 31.354811);
  LatLng dropoffLocation = const LatLng(31.037119, 31.379824);

  final route = await _getRouteBetween(pickupLocation, dropoffLocation);
  print('Route points: ${route.length}');
}