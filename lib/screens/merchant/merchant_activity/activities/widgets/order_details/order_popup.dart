import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'customer_detail.dart';
import 'item_details.dart';
import '../../../../orders/widgets/order_accept_btn.dart';
import '../../../../orders/widgets/order_cancel_btn.dart';
import '../../../../../../services/api/merchant_api_service.dart';
import '../../../../../../providers/merchant/merchant_order_provider.dart';
import '../../../../../../providers/merchant/merchant_profile_provider.dart';
import '../../../../../../models/order/place_order_response.dart';

class OrderPopup extends ConsumerWidget {
  final bool showActions;
  final PlaceOrderResponse? order;
  final String role;

  const OrderPopup({
    super.key,
    this.showActions = false,
    this.order,
    this.role = "Merchant",
  });

  static void show(BuildContext context, {bool showActions = false, PlaceOrderResponse? order, String role = "Merchant"}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderPopup(showActions: showActions, order: order, role: role),
    );
  }

  Future<void> _handleStatusUpdate(WidgetRef ref, String status) async {
    if (order?.orderId == null) return;
    
    try {
      final service = ref.read(merchantApiServiceProvider);
      await service.updateOrderStatus(order!.orderId, status);
      
      // Refresh providers to reflect the change
      ref.invalidate(merchantOrdersProvider('PLACED'));
      ref.invalidate(merchantOrdersProvider('CONFIRMED'));
      ref.invalidate(merchantOrdersProvider('CANCELLED'));
      ref.invalidate(merchantOrdersProvider('COMPLETE'));
    } catch (e) {
      debugPrint('Error updating order status: $e');
    }
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
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
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
                const SizedBox(width: 20),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  if (showActions && order != null) ...[
                    Row(
                      children: [
                        OrderCancelButton(
                          onTap: () async {
                            await _handleStatusUpdate(ref, 'CANCELLED');
                            if (context.mounted) Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 16),
                        OrderAcceptButton(
                          onTap: () async {
                            await _handleStatusUpdate(ref, 'CONFIRMED');
                            if (context.mounted) Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  CustomerDetail(role: role, order: order),
                  const SizedBox(height: 16),
                  ItemDetails(order: order),
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
