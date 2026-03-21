import 'package:flutter/material.dart';
import '../../../../models/order/place_order_response.dart';

class OrderDetailsSheet extends StatelessWidget {
  final PlaceOrderResponse order;

  const OrderDetailsSheet({super.key, required this.order});

  /// Takes "No 41/3 Chithara Lane, Bernard Soysa Mawatha, Colombo 5"
  /// and returns "Bernard Soysa Mawatha, Colombo 5" (everything after 2nd comma).
  String _shortAddress(String full) {
    final parts = full.split(',');
    if (parts.length > 2) {
      return parts.sublist(2).join(',').trim();
    }
    return full;
  }

  @override
  Widget build(BuildContext context) {
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
                // ── Drag Handle ──────────────────────────────────
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

                // ── Merchant Info Row ────────────────────────────
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
                            order.merchantName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D3A),
                            ),
                          ),
                          Text(
                            _shortAddress(order.merchantAddress),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    // Action buttons (static UI kept as-is)
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
                  ],
                ),

                const SizedBox(height: 24),

                // ── Pickup Address ───────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        order.merchantAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2D3A),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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

                // ── Order Items ──────────────────────────────────
                if (order.items.isEmpty)
                  const Text('No items in order', style: TextStyle(color: Colors.grey))
                else
                  ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.itemName,
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

                // ── Invoice ──────────────────────────────────────
                _invoiceRow('Sub Total', '+ LKR ${order.itemsTotal.toStringAsFixed(2)}'),
                const SizedBox(height: 12),
                _invoiceRow('Pickup Delivery Fee', '+ LKR ${order.pickupDeliveryFee.toStringAsFixed(2)}'),
                const SizedBox(height: 12),
                _invoiceRow('Service Fee', '+ LKR ${order.serviceFee.toStringAsFixed(2)}'),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D3A),
                      ),
                    ),
                    Text(
                      'LKR ${order.grandTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0062FF),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                const Divider(color: Color(0xFFE5E7EB)),
                const SizedBox(height: 16),

                // ── Payment Method ───────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.payment, size: 16, color: Colors.blueGrey),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Points',
                      style: TextStyle(
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

  Widget _invoiceRow(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        Text(amount, style: TextStyle(fontSize: 13, color: Colors.grey[800])),
      ],
    );
  }
}
