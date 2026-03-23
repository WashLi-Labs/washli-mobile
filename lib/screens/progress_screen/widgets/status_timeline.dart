import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/order/place_order_response.dart';

class StatusTimeline extends ConsumerStatefulWidget {
  final PlaceOrderResponse? order;
  final String? manualStatus;
  final bool? manualIsPickup;

  const StatusTimeline({
    super.key,
    this.order,
    this.manualStatus,
    this.manualIsPickup,
  }) : assert(order != null || (manualStatus != null && manualIsPickup != null));

  @override
  ConsumerState<StatusTimeline> createState() => _StatusTimelineState();
}

class _StatusTimelineState extends ConsumerState<StatusTimeline> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _updateAnimation();
  }

  @override
  void didUpdateWidget(covariant StatusTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAnimation();
  }

  void _updateAnimation() {
    final status = (widget.order?.status ?? widget.manualStatus ?? '').toUpperCase();
    if (status == 'CONFIRMED' || status == 'PICKED_UP' || status == 'AT_LAUNDRY') {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Maps the backend status string to a stage index.
  int _stageIndex() {
    final status = (widget.order?.status ?? widget.manualStatus ?? '').toUpperCase();
    switch (status) {
      case 'CONFIRMED': return 0;
      case 'PICKED_UP': return 1;
      case 'AT_LAUNDRY': return 2;
      case 'HANDED_OVER': return 2; // Legacy or alias
      case 'READY': return 3;
      case 'DELIVERED': return 4;
      default: return -1; // PLACED / anything else → all grey
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPickup = widget.order?.pickupMode == 'PARTNER' || (widget.manualIsPickup ?? true);
    final stages = isPickup
        ? ['Accepted', 'Picked-up', 'Handed-over', 'Ready', 'Delivered']
        : ['Accepted', 'Handed-over', 'Ready', 'Delivered'];
    final currentStageIndex = _stageIndex();
    final status = (widget.order?.status ?? widget.manualStatus ?? '').toUpperCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(stages.length, (index) {
          final isCompleted = index <= currentStageIndex;
          final isFirst = index == 0;
          final isLast = index == stages.length - 1;

          // Segment between (index-1) and index
          final isLineBeforeCompleted = index <= currentStageIndex;
          // Segment between index and (index+1) 
          final isLineAfterCompleted = index < currentStageIndex;

          // Special animation for the current active segment
          final isAnimatingLineBefore = (status == 'CONFIRMED' && index == 1) || 
                                        (status == 'PICKED_UP' && index == 2) ||
                                        (status == 'AT_LAUNDRY' && index == 3);

          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 2,
                            color: isFirst
                                ? Colors.transparent
                                : (isLineBeforeCompleted ? const Color(0xFF2ECA7F) : Colors.grey[300]),
                          ),
                          if (isAnimatingLineBefore)
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return FractionallySizedBox(
                                  widthFactor: 1.0,
                                  child: Align(
                                    alignment: Alignment(_animationController.value * 2 - 1, 0),
                                    child: Container(
                                      width: 8,
                                      height: 2,
                                      color: const Color(0xFF2ECA7F),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted ? const Color(0xFF2ECA7F) : Colors.grey[300],
                        border: Border.all(
                          color: isCompleted ? const Color(0xFF2ECA7F) : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : const SizedBox(),
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isLast
                            ? Colors.transparent
                            : (isLineAfterCompleted ? const Color(0xFF2ECA7F) : Colors.grey[300]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  stages[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
                    color: isCompleted ? Colors.black87 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

