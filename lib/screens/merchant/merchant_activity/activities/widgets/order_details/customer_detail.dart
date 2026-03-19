import 'package:flutter/material.dart';

class CustomerDetail extends StatelessWidget {
  final String role;
  const CustomerDetail({super.key, this.role = "Merchant"});

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
          const Text(
            '#ORD-1523',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D3A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Order ID - ORD1523 - RS.3500.00',
            style: TextStyle(
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
          _buildDetailRow('Name', isCustomer ? 'Fresh Wash Laundry' : 'Amal Silva'),
          const Divider(),
          _buildDetailRow('Mobile Number', '+9471 6545 334'),
          const Divider(),
          _buildDetailRow('Address', 'No 69, Main Road, Nugegoda'),
          if (isCustomer) ...[
            const Divider(),
            _buildDetailRow('Price', 'LKR.3500.00'),
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
