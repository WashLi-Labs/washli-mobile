import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'customer_detail.dart';
import 'item_details.dart';
import '../../../../orders/widgets/order_accept_btn.dart';
import '../../../../orders/widgets/order_cancel_btn.dart';
import 'package:washli_mobile/providers/order_provider.dart';

class OrderPopup extends ConsumerWidget {
  final bool showActions;
  final String? orderId;
  final String role;

  const OrderPopup({
    super.key,
    this.showActions = false,
    this.orderId,
    this.role = "Merchant",
  });

  static void show(BuildContext context, {bool showActions = false, String? orderId, String role = "Merchant"}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderPopup(showActions: showActions, orderId: orderId, role: role),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, size: 20),
                ),
                const Expanded(
                  child: Text(
                    'Order Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D3A),
                    ),
                  ),
                ),
                const SizedBox(width: 20), // Placeholder for symmetry
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  if (showActions && orderId != null) ...[
                    Row(
                      children: [
                        OrderCancelButton(
                          onTap: () {
                            ref.read(orderProvider.notifier).updateOrderStatus(orderId!, 'Canceled');
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 16),
                        OrderAcceptButton(
                          onTap: () {
                            ref.read(orderProvider.notifier).updateOrderStatus(orderId!, 'In Progress');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  CustomerDetail(role: role),
                  const SizedBox(height: 16),
                  const ItemDetails(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
