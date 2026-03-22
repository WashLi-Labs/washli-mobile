import 'package:flutter/material.dart';
import '../../../../../../models/order/place_order_response.dart';

class CustomerDetail extends StatelessWidget {
  final String role;
  final PlaceOrderResponse? order;

  const CustomerDetail({
    super.key, 
    this.role = "Merchant",
    this.order,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCustomer = role.toLowerCase() == "customer";
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '#${order?.orderId ?? 'N/A'}',
            style: const TextStyle(
              fontSize: 18,
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
          Text(
            isCustomer ? 'Order Details' : 'Customer Details',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D3A),
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Name', isCustomer ? (order?.merchantName ?? 'Merchant') : (order?.customerName ?? 'Customer')),
          const Divider(),
          // Mobile number not explicitly in PlaceOrderResponse, showing placeholder or omitting
          _buildDetailRow('Address', 
            isCustomer ? (order?.merchantAddress ?? 'N/A') : (order?.pickupAddress ?? 'N/A')),
          if (isCustomer) ...[
            const Divider(),
            _buildDetailRow('Price', 'LKR.${order?.grandTotal.toStringAsFixed(2) ?? '0.00'}'),
          ],
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
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D3A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
