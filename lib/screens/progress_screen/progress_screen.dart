import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/progress_header.dart';
import 'widgets/status_timeline.dart';
import 'widgets/time_estimation.dart';
import 'widgets/progress_map.dart';
import 'widgets/order_details_sheet.dart';
import '../../models/order/place_order_response.dart';
import '../../providers/order_provider.dart';

/// Used by the PICKUP flow (backend REST, no Firestore needed).
/// Used by the SELF-DELIVER flow via legacy [orderId] + Firestore stream.
class ProgressScreen extends ConsumerWidget {
  final PlaceOrderResponse? order;   // pickup path
  final String? orderId;             // self-deliver / Firestore path
  final bool isPickup;

  const ProgressScreen({
    super.key,
    this.order,
    this.orderId,
    this.isPickup = true,
  }) : assert(order != null || orderId != null,
            'Either order or orderId must be provided');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ── PICKUP path: everything comes from PlaceOrderResponse ──────────
    if (order != null) {
      final isConfirmed = order!.status.toUpperCase() == 'CONFIRMED';
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              ProgressHeader(orderId: order!.orderId),
              StatusTimeline(
                status: order!.status,
                isPickup: order!.pickupMode == 'PARTNER',
              ),
              if (isConfirmed) const TimeEstimation(),
              Expanded(
                child: Stack(
                  children: [
                    ProgressMap(
                      status: order!.status,
                      isPickup: order!.pickupMode == 'PARTNER',
                    ),
                    OrderDetailsSheet(order: order!),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── SELF-DELIVER path: stream from Firestore ───────────────────────
    final orderAsync = ref.watch(orderStreamProvider(orderId!));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: orderAsync.when(
          data: (firestoreOrder) {
            if (firestoreOrder == null) {
              return const Center(child: Text('Order not found'));
            }
            final status = firestoreOrder.status;
            final isConfirmed = status.toUpperCase() == 'CONFIRMED';
            return Column(
              children: [
                ProgressHeader(orderId: firestoreOrder.id),
                StatusTimeline(
                  status: status,
                  isPickup: firestoreOrder.isPickup ?? true,
                ),
                if (isConfirmed) const TimeEstimation(),
                Expanded(
                  child: Stack(
                    children: [
                      ProgressMap(
                        status: status,
                        isPickup: firestoreOrder.isPickup ?? true,
                      ),
                      // Self-deliver still uses old Firestore-backed sheet
                      // (separate widget handles OrderModel)
                      _LegacyOrderDetailsSheet(order: firestoreOrder),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}

// Thin wrapper so OrderDetailsSheet (PlaceOrderResponse) isn't confused
// with the old Firestore OrderModel sheet for self-deliver.
class _LegacyOrderDetailsSheet extends StatelessWidget {
  final dynamic order;
  const _LegacyOrderDetailsSheet({required this.order});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.35,
      maxChildSize: 0.85,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Text(order.shopName ?? 'Unknown Shop',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D2D3A))),
              const SizedBox(height: 8),
              Text(order.address ?? '', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            ],
          ),
        ),
      ),
    );
  }
}
