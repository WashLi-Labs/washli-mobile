import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/progress_header.dart';
import 'widgets/status_timeline.dart';
import 'widgets/time_estimation.dart';
import 'widgets/progress_map.dart';
import 'widgets/order_details_sheet.dart';

import '../../providers/order_provider.dart';
import '../../models/order_model.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  final String orderId;
  final bool isPickup;
  const ProgressScreen({super.key, required this.orderId, this.isPickup = true});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(orderStreamProvider(widget.orderId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: orderAsync.when(
          data: (order) {
            if (order == null) {
              return const Center(child: Text('Order not found'));
            }
            return Column(
              children: [
                // Safe Area Header
                ProgressHeader(orderId: order.id),
                
                // Timeline - Using status from Firestore
                StatusTimeline(
                  currentStageIndex: _getStatusIndex(order.status), 
                  isPickup: order.isPickup ?? true,
                ),
                
                // Time Estimation Text
                const TimeEstimation(),
                
                // Map + Draggable Sheet Area
                Expanded(
                  child: Stack(
                    children: [
                      ProgressMap(isPickup: order.isPickup ?? true),
                      OrderDetailsSheet(order: order),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  int _getStatusIndex(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return 0;
      case 'accepted': return 1;
      case 'processing': return 2;
      case 'ready': return 3;
      case 'delivered': return 4;
      default: return 0;
    }
  }
}
