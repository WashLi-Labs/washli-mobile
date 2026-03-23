import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/order/place_order_response.dart';
import '../../../providers/order_placement_provider.dart';
import '../../../providers/merchant/merchant_list_provider.dart';
import '../../../services/api/direction_service.dart';
import 'return_mode_prompt.dart';

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
    final isReadyForReturn = status == 'READY_FOR_RETURN' || status == 'READY';
    final isReturning = status == 'WALK_IN_RETURN' || status == 'PARTNER_RETURN';
    final isOutForDelivery = status == 'OUT_FOR_DELIVERY';

    // Show pending illustration for AT_LAUNDRY
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

    // Handle return flow prompt
    if (isReadyForReturn && order?.returnMode == null) {
      return Align(
        alignment: const Alignment(0, -0.7), // Position moved upward
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ReturnModePrompt(order: order!),
        ),
      );
    }

    // Show pending illustration for status before confirmation
    if (!isConfirmed && !isPickedUp && !isAtLaundry && !isReadyForReturn && 
        !isReturning && !isOutForDelivery) {
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
    List<LatLng>? waypoints;
    String originTitle = 'Origin';
    String destinationTitle = 'Destination';
    final markers = <Marker>{};

    if (isReadyForReturn || isReturning || isOutForDelivery) {
      if (order?.returnMode == 'WALK_IN') {
        // Self-pickup: User to Merchant
        origin = LatLng(order?.latitude ?? 6.8860, order?.longitude ?? 79.8655);
        originTitle = 'Your Location';
        final merchantLocAsync = ref.watch(merchantCoordinatesProvider(order?.merchantName ?? ''));
        if (merchantLocAsync.hasValue && merchantLocAsync.value != null) {
          destination = merchantLocAsync.value!;
          destinationTitle = order?.merchantName ?? 'Laundry';
        }
      } else if (order?.returnMode == 'PARTNER') {
        // Delivery: Rider -> Merchant -> User
        final returnDelivery = order?.deliveries.where((d) => d.tripType == 'RETURN').firstOrNull;
        if (returnDelivery != null && returnDelivery.latitude != null && returnDelivery.longitude != null) {
          origin = LatLng(returnDelivery.latitude!, returnDelivery.longitude!);
          originTitle = 'Delivery Partner';
          destination = LatLng(order?.latitude ?? 6.8860, order?.longitude ?? 79.8655);
          destinationTitle = 'Your Location';
          
          final merchantLocAsync = ref.watch(merchantCoordinatesProvider(order?.merchantName ?? ''));
          if (merchantLocAsync.hasValue && merchantLocAsync.value != null) {
            waypoints = [merchantLocAsync.value!];
            markers.add(
              Marker(
                markerId: const MarkerId('merchant'),
                position: merchantLocAsync.value!,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                infoWindow: InfoWindow(title: order?.merchantName ?? 'Laundry'),
              ),
            );
          }
        }
      }
    } else if (isPickedUp) {
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

    if (origin != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: origin,
          icon: (isPickedUp || (isReadyForReturn && order?.returnMode == 'WALK_IN'))
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
          icon: (isPickedUp || (isReadyForReturn && order?.returnMode == 'WALK_IN'))
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)    // Merchant
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow), // User
          infoWindow: InfoWindow(title: destinationTitle),
        ),
      );
    }

    final polylines = <Polyline>{};
    if (origin != null && destination != null) {
      final routeAsync = ref.watch(directionProvider(RouteRequest(origin, destination, waypoints: waypoints)));
      final routePoints = routeAsync.value?.points ?? [origin, ...(waypoints ?? []), destination];

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
