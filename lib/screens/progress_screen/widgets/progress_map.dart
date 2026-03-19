import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProgressMap extends StatelessWidget {
  final bool isPickup;
  const ProgressMap({super.key, this.isPickup = true});

  @override
  Widget build(BuildContext context) {
    // Coordinates for Maharagama (from laundry_location.dart) for Walk-in
    const laundryPosition = LatLng(6.8480, 79.9265);
    // Default Nugegoda for Pickup
    const pickupDefault = LatLng(6.8649, 79.8997);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: isPickup ? pickupDefault : laundryPosition,
        zoom: 14.0,
      ),
      markers: isPickup ? {} : {
        const Marker(
          markerId: MarkerId('laundry_location'),
          position: laundryPosition,
        ),
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }
}
