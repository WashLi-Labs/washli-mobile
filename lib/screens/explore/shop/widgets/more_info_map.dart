import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MoreInfoMap extends StatelessWidget {
  final Map<String, dynamic>? location;

  const MoreInfoMap({super.key, this.location});

  @override
  Widget build(BuildContext context) {
    // Default location (Colombo) if no location provided
    final LatLng targetLocation = const LatLng(6.927079, 79.861244);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: targetLocation,
            zoom: 14.0,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('shop_location'),
              position: targetLocation,
            ),
          },
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
        ),
      ),
    );
  }
}
