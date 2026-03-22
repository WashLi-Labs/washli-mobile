import 'package:flutter/material.dart';
import '../../../../../../models/order/place_order_response.dart';

class ItemDetails extends StatelessWidget {
  final PlaceOrderResponse? order;
  const ItemDetails({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Item Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D3A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Order ID - ${order?.orderId ?? ''} - RS.${order?.grandTotal.toStringAsFixed(2) ?? '0.00'}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const Text(
            'Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D3A),
            ),
          ),
          const SizedBox(height: 12),
          if (order?.items != null)
            ...order!.items.map((item) => Column(
              children: [
                _buildDetailRow(item.itemName, 'Quantity: ${item.quantity}'), // Omit washType
                const Divider(),
              ],
            )).toList(),
          _buildDetailRow('Grand Total', 'RS.${order?.grandTotal.toStringAsFixed(2) ?? '0.00'}'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D3A),
            ),
          ),
        ],
      ),
    );
  }
}
