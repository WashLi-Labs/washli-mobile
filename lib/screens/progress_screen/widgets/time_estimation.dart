import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../services/api/direction_service.dart';
import '../../../models/order/place_order_response.dart';
import '../../../providers/order_placement_provider.dart';
import '../../../providers/merchant/merchant_list_provider.dart';

class TimeEstimation extends ConsumerWidget {
  final PlaceOrderResponse? order;

  const TimeEstimation({
    super.key,
    this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    
    // Default fallback
    var estimate = now.add(const Duration(minutes: 15));
    var latest = now.add(const Duration(minutes: 30));
    String? durationLabel;

    if (order != null) {
      final status = order!.status.toUpperCase();
      final isPickedUp = status == 'PICKED_UP';
      final isReadyForReturn = status == 'READY_FOR_RETURN' || status == 'READY';
      final isReturning = status == 'WALK_IN_RETURN' || status == 'PARTNER_RETURN';
      final isOutForDelivery = status == 'OUT_FOR_DELIVERY';
      
      LatLng? origin;
      LatLng? destination;
      List<LatLng>? waypoints;

      if (isReadyForReturn || isReturning || isOutForDelivery) {
        if (order!.returnMode == 'WALK_IN') {
          // Self-pickup: User to Merchant
          origin = LatLng(order!.latitude ?? 6.8860, order!.longitude ?? 79.8655);
          final merchantLocAsync = ref.watch(merchantCoordinatesProvider(order!.merchantName));
          if (merchantLocAsync.hasValue && merchantLocAsync.value != null) {
            destination = merchantLocAsync.value!;
          }
        } else if (order!.returnMode == 'PARTNER') {
          // Delivery: Rider -> Merchant -> User
          final returnDelivery = order!.deliveries.where((d) => d.tripType == 'RETURN').firstOrNull;
          if (returnDelivery != null && returnDelivery.latitude != null && returnDelivery.longitude != null) {
            origin = LatLng(returnDelivery.latitude!, returnDelivery.longitude!);
            destination = LatLng(order!.latitude ?? 6.8860, order!.longitude ?? 79.8655);
            
            final merchantLocAsync = ref.watch(merchantCoordinatesProvider(order!.merchantName));
            if (merchantLocAsync.hasValue && merchantLocAsync.value != null) {
              waypoints = [merchantLocAsync.value!];
            }
          }
        }
      } else if (isPickedUp) {
        // From Pickup (Customer) to Merchant
        origin = LatLng(order!.latitude ?? 6.8860, order!.longitude ?? 79.8655);
        final merchantLocAsync = ref.watch(merchantCoordinatesProvider(order!.merchantName));
        if (merchantLocAsync.hasValue && merchantLocAsync.value != null) {
          destination = merchantLocAsync.value!;
        }
      } else {
        // From Driver to Pickup (Customer)
        final pickupDelivery = order!.deliveries.where((d) => d.tripType == 'PICKUP').firstOrNull;
        if (pickupDelivery?.latitude != null && pickupDelivery?.longitude != null) {
          origin = LatLng(pickupDelivery!.latitude!, pickupDelivery!.longitude!);
          destination = LatLng(order!.latitude ?? 6.8860, order!.longitude ?? 79.8655);
        }
      }

      if (origin != null && destination != null) {
        final routeAsync = ref.watch(directionProvider(RouteRequest(origin, destination, waypoints: waypoints)));
        
        if (routeAsync.hasValue) {
          final durationValue = routeAsync.value!.durationValue;
          durationLabel = routeAsync.value!.durationText;
          estimate = now.add(Duration(seconds: durationValue));
          latest = estimate.add(const Duration(minutes: 15));
        }
      }
    }

    final format = DateFormat('h:mm a');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (order?.status.toUpperCase() == 'READY_FOR_RETURN' && order?.returnMode == 'WALK_IN')
                  ? 'Estimated time to reach laundry'
                  : 'Estimated arrival time',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (durationLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0062FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    durationLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0062FF),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            format.format(estimate),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D2D3A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Latest arrival by ${format.format(latest)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            durationLabel != null 
              ? (order?.returnMode == 'WALK_IN' 
                  ? 'The laundry is approximately $durationLabel away.'
                  : 'The Delivery Partner is approximately $durationLabel away.')
              : (order?.returnMode == 'WALK_IN'
                  ? 'The laundry is a short distance away.'
                  : 'The Delivery Partner will arrive shortly.'),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 1, color: Color(0xFFE5E7EB)),
        ],
      ),
    );
  }
}
