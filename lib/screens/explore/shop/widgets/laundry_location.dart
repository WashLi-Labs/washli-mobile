import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LaundryLocationMap extends StatefulWidget {
  const LaundryLocationMap({super.key});

  @override
  State<LaundryLocationMap> createState() => _LaundryLocationMapState();
}

class _LaundryLocationMapState extends State<LaundryLocationMap> {
  // Coordinates for Maharagama based on the static data
  static const LatLng _initialPosition = LatLng(6.8480, 79.9265);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _initialPosition,
          zoom: 14.0,
        ),
        markers: {
          const Marker(
            markerId: MarkerId('laundry_location'),
            position: _initialPosition,
          ),
        },
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),
    );
  }
}
