import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LaundryLocationMap extends StatefulWidget {
  final double? lat;
  final double? lng;

  const LaundryLocationMap({super.key, this.lat, this.lng});

  @override
  State<LaundryLocationMap> createState() => _LaundryLocationMapState();
}

class _LaundryLocationMapState extends State<LaundryLocationMap> {
  // Fallback coordinates for Maharagama
  static const LatLng _fallbackPosition = LatLng(6.8480, 79.9265);

  LatLng get _targetPosition => (widget.lat != null && widget.lng != null)
      ? LatLng(widget.lat!, widget.lng!)
      : _fallbackPosition;

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
        initialCameraPosition: CameraPosition(
          target: _targetPosition,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('laundry_location'),
            position: _targetPosition,
          ),
        },
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),
    );
  }
}
