import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/cart_provider.dart';
import '../../../../providers/payment_provider.dart';

import '../../../../models/order/order_model.dart';

class OrderDetailsSheet extends ConsumerWidget {
  final OrderModel order;
  const OrderDetailsSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPickup = order.isPickup ?? true;
    final deliveryFee = order.deliveryFee ?? 0.0;
    final finalTotal = order.total ?? 0.0;

    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.35,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Minimal Drag Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                // Driver/Merchant Info Row
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/profile1.png'),
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.shopName ?? 'Unknown Shop',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D2D3A)),
                          ),
                          Text(
                            'Colombo', // Placeholder or derive from shop address if available
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '4.98',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: const Icon(Icons.phone, size: 16, color: Colors.black54),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'BCE 051',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          'WEGO',
                          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Store Pick/Drop Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        order.address ?? 'No address provided',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2D2D3A)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0062FF)),
                      ),
                      child: const Icon(Icons.phone, size: 14, color: Color(0xFF0062FF)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Order Items
                if (order.items == null || order.items!.isEmpty)
                  const Text('No items in order', style: TextStyle(color: Colors.grey))
                else
                  ...order.items!.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.quantity.toString().padLeft(2, '0'),
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                      )),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFE5E7EB)),
                const SizedBox(height: 16),
                
                // Dynamic Invoice Details
                _buildInvoiceRow('Sub Total', '+ LKR ${(order.subTotal ?? 0.0).toStringAsFixed(2)}'),
                const SizedBox(height: 12),
                if (isPickup) ...[
                  _buildInvoiceRow('Delivery Fee', '+ LKR ${deliveryFee.toStringAsFixed(2)}'),
                  const SizedBox(height: 12),
                ],
                _buildInvoiceRow('High Demand Surge', '+ LKR 0.00'),
                const SizedBox(height: 16),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D2D3A)),
                    ),
                    Text(
                      'LKR ${finalTotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0062FF)),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFE5E7EB)),
                const SizedBox(height: 16),
                
                // Dynamic Payment Method from OrderModel
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 24,
                      decoration: BoxDecoration(
                        color: (order.paymentMethod ?? 'Points') == 'Points' ? Colors.orange.shade100 : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // Since we don't store the icon path in Firestore, we can just show the name or a default icon
                      child: const Icon(Icons.payment, size: 16, color: Colors.blueGrey),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      order.paymentMethod ?? 'Points',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D2D3A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInvoiceRow(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
        ),
        Text(
          amount,
          style: TextStyle(fontSize: 13, color: Colors.grey[800]),
        ),
      ],
    );
  }
}
