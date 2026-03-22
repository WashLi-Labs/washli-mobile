import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/order/place_order_response.dart';
import '../../progress_screen/progress_screen.dart';

class ActiveOrderCard extends StatelessWidget {
  final PlaceOrderResponse order;

  const ActiveOrderCard({super.key, required this.order});

  int _currentStage() {
    switch (order.status.toUpperCase()) {
      case 'CONFIRMED': return 0;
      case 'PICKED_UP': return 1;
      case 'HANDED_OVER': return 2;
      case 'READY': return 3;
      case 'DELIVERED': return 4;
      default: return -1; // PLACED / anything else → all grey
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPickup = order.pickupMode == 'PARTNER';
    final currentStage = _currentStage();
    final stages = isPickup
        ? ['Accepted', 'Picked-up', 'Handed-over', 'Ready', 'Delivered']
        : ['Accepted', 'Handed-over', 'Ready', 'Delivered'];
    final merchantName = order.merchantName.split(' ').first;

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28), // Increased padding
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
              final isLineCompleted = index < currentStage;
              final isFirst = index == 0;
              final isLast = index == stages.length - 1;

              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 3, // Slightly thicker line
                            color: isFirst
                                ? Colors.transparent
                                : (isLineCompleted
                                    ? const Color(0xFF0741E2)
                                    : const Color(0xFFCCD9FC)),
                          ),
                        ),
                        Container(
                          width: 10,
                          height: 10,
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
                          child: Container(
                            height: 3,
                            color: isLast
                                ? Colors.transparent
                                : (isLineCompleted
                                    ? const Color(0xFF0741E2)
                                    : const Color(0xFFCCD9FC)),
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
