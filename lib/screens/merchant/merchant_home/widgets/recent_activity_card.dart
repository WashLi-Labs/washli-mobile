import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../providers/merchant/merchant_order_provider.dart';

class RecentActivityCard extends ConsumerWidget {
  const RecentActivityCard({super.key});

  String _getTimeAgo(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt);
      final difference = DateTime.now().difference(dateTime);
      
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minutes ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago';
      } else {
        return DateFormat('MMM dd, yyyy').format(dateTime);
      }
    } catch (_) {
      return 'Recently';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingOrdersAsync = ref.watch(merchantOrdersProvider('PLACED'));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D3A),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See all', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          pendingOrdersAsync.when(
            data: (orders) {
              if (orders.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'No recent pending orders',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              // Show the latest order
              final latestOrder = orders.first;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5), // Light grey background
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'New Order Received',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D3A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getTimeAgo(latestOrder.createdAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Order ID - ${latestOrder.orderId} - RS.${latestOrder.grandTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 32,
                      color: Colors.black54,
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ],
      ),
    );
  }
}
