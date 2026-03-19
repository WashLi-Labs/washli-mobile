import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'order_details/order_popup.dart';
import 'package:washli_mobile/providers/order_provider.dart';
import 'package:washli_mobile/widgets/empty_state_widget.dart';

class CanceledActivities extends ConsumerWidget {
  const CanceledActivities({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);
    final canceledOrders = orderState.pastOrders.where((o) => o.status == 'Canceled').toList();

    if (canceledOrders.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.cancel_outlined,
        title: 'No canceled activities',
        subtitle: 'If an order is canceled, it will be listed here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: canceledOrders.length,
      itemBuilder: (context, index) {
        final order = canceledOrders[index];
        return GestureDetector(
          onTap: () => OrderPopup.show(context, orderId: order.id, showActions: false),
          child: _buildActivityCard(order),
        );
      },
    );
  }

  Widget _buildActivityCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.orderId,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D3A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.timeAgo,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.orderDescription,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Canceled',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
