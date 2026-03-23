import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/order/place_order_response.dart';
import '../../../providers/order_placement_provider.dart';
import '../../../providers/merchant/merchant_list_provider.dart';

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
    final isConfirmed = status == 'CONFIRMED';
    final isPickedUp = status == 'PICKED_UP';
    final isAtLaundry = status == 'AT_LAUNDRY';

    // Show pending illustration until confirmed, picked up, or at laundry
    if (!isConfirmed && !isPickedUp && !isAtLaundry) {
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

    if (isAtLaundry) {
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

    LatLng? origin;
    LatLng? destination;
    String originTitle = 'Origin';
    String destinationTitle = 'Destination';

    if (isPickedUp) {
      // From Pickup (Customer) to Merchant
      origin = LatLng(order?.latitude ?? 6.8860, order?.longitude ?? 79.8655);
      originTitle = 'Your Location';
      final merchantLocAsync = ref.watch(merchantCoordinatesProvider(order?.merchantName ?? ''));
      if (merchantLocAsync.hasValue && merchantLocAsync.value != null) {
        destination = merchantLocAsync.value!;
        destinationTitle = order?.merchantName ?? 'Laundry';
      }
    } else {
      // From Driver to Pickup (Customer)
      final pickupDelivery = order?.deliveries.where((d) => d.tripType == 'PICKUP').firstOrNull;
      if (pickupDelivery?.latitude != null && pickupDelivery?.longitude != null) {
        origin = LatLng(pickupDelivery!.latitude!, pickupDelivery!.longitude!);
        originTitle = 'Delivery Partner';
        destination = LatLng(order?.latitude ?? 6.8860, order?.longitude ?? 79.8655);
        destinationTitle = 'Your Location';
      }
    }

    final markers = <Marker>{};
    if (origin != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: origin,
          icon: isPickedUp 
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow) // User
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),  // Driver
          infoWindow: InfoWindow(title: originTitle),
        ),
      );
    }

    if (destination != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          icon: isPickedUp 
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)    // Merchant
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow), // User
          infoWindow: InfoWindow(title: destinationTitle),
        ),
      );
    }

    final polylines = <Polyline>{};
    if (origin != null && destination != null) {
      final routeAsync = ref.watch(directionProvider(RouteRequest(origin, destination)));
      final routePoints = routeAsync.value?.points ?? [origin, destination];

      polylines.add(
        Polyline(
          polylineId: const PolylineId('active_route'),
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
        target: origin ?? destination ?? const LatLng(6.9271, 79.8612),
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
