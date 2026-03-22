import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/order/place_order_response.dart';
import '../../../providers/order_placement_provider.dart';

class ProgressMap extends ConsumerWidget {
  final PlaceOrderResponse? order;
  final String? manualStatus;
  final bool? manualIsPickup;

  const ProgressMap({
    super.key,
    this.order,
    this.manualStatus,
    this.manualIsPickup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = (order?.status ?? manualStatus ?? '').toUpperCase();
    final isConfirmed = status == 'CONFIRMED' || status == 'PICKED_UP';

    // Show pending illustration until confirmed
    if (!isConfirmed) {
      return Align(
        alignment: const Alignment(0, -0.9),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Image.asset(
            'assets/images/progress_pending1.png',
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    final customerLocation = LatLng(order?.latitude ?? 6.8860, order?.longitude ?? 79.8655);
    
    // Find pickup delivery for driver location
    final pickupDelivery = order?.deliveries.where((d) => d.tripType == 'PICKUP').firstOrNull;
    final driverLocation = pickupDelivery?.latitude != null && pickupDelivery?.longitude != null
        ? LatLng(pickupDelivery!.latitude!, pickupDelivery!.longitude!)
        : null;

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('customer_location'),
        position: customerLocation,
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    };

    if (driverLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver_location'),
          position: driverLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Delivery Partner'),
        ),
      );
    }

    final polylines = <Polyline>{};
    if (driverLocation != null) {
      final routeAsync = ref.watch(directionProvider(RouteRequest(driverLocation, customerLocation)));
      final routePoints = routeAsync.value?.points ?? [driverLocation, customerLocation];

      polylines.add(
        Polyline(
          polylineId: const PolylineId('driver_to_customer'),
          points: routePoints,
          color: const Color(0xFF0062FF),
          width: 5,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: driverLocation ?? customerLocation,
        zoom: 14.5,
      ),
      markers: markers,
      polylines: polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }
}
