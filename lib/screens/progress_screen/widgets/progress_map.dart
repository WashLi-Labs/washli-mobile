import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProgressMap extends StatelessWidget {
  final String status;
  final bool isPickup;

  const ProgressMap({super.key, required this.status, this.isPickup = true});

  @override
  Widget build(BuildContext context) {
    final isConfirmed = status.toUpperCase() == 'CONFIRMED';

    // Show pending illustration until confirmed
    if (!isConfirmed) {
      return SizedBox.expand(
        child: Image.asset(
          'assets/images/progress_pending.png',
          fit: BoxFit.cover,
        ),
      );
    }

    const laundryPosition = LatLng(6.8480, 79.9265);
    const pickupDefault = LatLng(6.8649, 79.8997);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: isPickup ? pickupDefault : laundryPosition,
        zoom: 14.0,
      ),
      markers: isPickup
          ? {}
          : {
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
