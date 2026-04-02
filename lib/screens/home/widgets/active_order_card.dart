import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/order/place_order_response.dart';
import '../../progress_screen/progress_screen.dart';

class ActiveOrderCard extends StatelessWidget {
  final PlaceOrderResponse order;

  const ActiveOrderCard({super.key, required this.order});

  int _currentStage(bool isPickup) {
    final status = order.status.toUpperCase();
    switch (status) {
      case 'CONFIRMED':
        return 0;
      case 'PICKED_UP':
        return isPickup ? 1 : 0;
      case 'AT_LAUNDRY':
      case 'HANDED_OVER':
      case 'WASHING':
        return isPickup ? 2 : 1;
      case 'READY':
      case 'READY_FOR_RETURN':
      case 'WALK_IN_RETURN':
      case 'PARTNER_RETURN':
      case 'OUT_FOR_DELIVERY':
        return isPickup ? 3 : 2;
      case 'DELIVERED':
        return isPickup ? 4 : 3;
      default:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPickup = order.pickupMode == 'PARTNER';
    final currentStage = _currentStage(isPickup);
    final stages = isPickup
        ? ['Accepted', 'Picked-up', 'Handed-over', 'Ready', 'Delivered']
        : ['Accepted', 'Handed-over', 'Ready', 'Delivered'];
    final merchantName = order.merchantName.split(' ').first;

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28), // Reduced horizontal padding to lengthen lines
      decoration: BoxDecoration(
        color: const Color(0xFF01113C), // Deeper Dark Navy
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Merchant Icon
              Container(
                width: 60, // Slightly bigger
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.local_shipping_rounded,
                    color: Color(0xFF0066FF), size: 36),
              ),
              const SizedBox(width: 16),
              // Merchant Name & ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchantName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18, // Bigger font
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.orderId,
                      style: const TextStyle(
                        color: Color(0xFFCCD9FC),
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Order Details Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProgressScreen(order: order),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066FF),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Order Details',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32), // More spacing
          // Progress Bar
          Row(
            children: List.generate(stages.length, (index) {
              final isCompleted = index <= currentStage;
              final isWorking = index == currentStage;
              final isLineBeforeCompleted = index <= currentStage;
              final isLineAfterCompleted = index < currentStage;
              final isFirst = index == 0;
              final isLast = index == stages.length - 1;
              final status = order.status.toUpperCase();

              // Only show halfway for the segment starting FROM the current active node
              final isHalfwayLineAfter = index == currentStage && 
                (status == 'PICKED_UP' || status == 'AT_LAUNDRY' || status == 'READY_FOR_RETURN');

              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 3,
                            color: isFirst
                                ? Colors.transparent
                                : (isLineBeforeCompleted
                                    ? const Color(0xFF0741E2)
                                    : const Color(0xFFCCD9FC)),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? const Color(0xFF0741E2)
                                : const Color(0xFFCCD9FC),
                            boxShadow: isWorking
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF0741E2)
                                          .withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : null,
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 3,
                                color: isLast
                                    ? Colors.transparent
                                    : (isLineAfterCompleted
                                        ? const Color(0xFF0741E2)
                                        : const Color(0xFFCCD9FC)),
                              ),
                              if (isHalfwayLineAfter)
                                FractionallySizedBox(
                                  widthFactor: 0.5,
                                  child: Container(
                                    height: 3,
                                    color: const Color(0xFF0741E2),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      stages[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isCompleted
                            ? const Color(0xFF0741E2)
                            : const Color(0xFFCCD9FC),
                        fontSize: 8.5, // Reduced font size for multi-stage labels
                        fontWeight:
                            isCompleted ? FontWeight.w600 : FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
