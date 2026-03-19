import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/progress_header.dart';
import 'widgets/status_timeline.dart';
import 'widgets/time_estimation.dart';
import 'widgets/progress_map.dart';
import 'widgets/order_details_sheet.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  final bool isPickup;
  const ProgressScreen({super.key, this.isPickup = true});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Safe Area Header
            const ProgressHeader(orderId: '175062474'),
            
            // Timeline
            StatusTimeline(currentStageIndex: 0, isPickup: widget.isPickup),
            
            // Time Estimation Text
            const TimeEstimation(),
            
            // Map + Draggable Sheet Area
            Expanded(
              child: Stack(
                children: [
                  ProgressMap(isPickup: widget.isPickup),
                  OrderDetailsSheet(isPickup: widget.isPickup),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
