import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'order_details/order_popup.dart';
import '../../../../../providers/merchant/merchant_order_provider.dart';
import 'package:washli_mobile/screens/merchant/merchant_activity/activities/widgets/empty_state_widget.dart';

class CanceledActivities extends ConsumerWidget {
  final String role;
  const CanceledActivities({super.key, this.role = "Merchant"});

  String _getTimeAgo(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt);
      final difference = DateTime.now().difference(dateTime);
      if (difference.inMinutes < 60) return '${difference.inMinutes} mins ago';
      if (difference.inHours < 24) return '${difference.inHours} hours ago';
      return DateFormat('MMM dd').format(dateTime);
    } catch (_) {
      return 'Recently';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (role != "Merchant") {
      return const EmptyStateWidget(
        icon: Icons.cancel_outlined,
        title: 'No canceled activities',
        subtitle: 'If an order is canceled, it will be listed here.',
      );
    }

    final canceledOrdersAsync = ref.watch(merchantCanceledOrdersProvider);

    return canceledOrdersAsync.when(
      data: (orders) {
        if (orders.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.cancel_outlined,
            title: 'No canceled activities',
            subtitle: 'If an order is canceled, it will be listed here.',
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(merchantAllActiveOrdersProvider),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final itemsDesc = order.items
                  .map((i) => '${i.itemName} x ${i.quantity}')
                  .join(', ');

              return GestureDetector(
                onTap: () => OrderPopup.show(
                  context,
                  order: order,
                  showActions: false,
                  role: role,
                ),
                child: Container(
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
                              _getTimeAgo(order.createdAt),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              itemsDesc,
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
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => const EmptyStateWidget(
        icon: Icons.error_outline,
        title: 'Connection Error',
        subtitle: 'Unable to load orders. Please check your connection.',
      ),
    );
  }
}
