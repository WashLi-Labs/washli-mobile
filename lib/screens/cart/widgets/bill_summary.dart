import 'package:flutter/material.dart';

class BillSummary extends StatelessWidget {
  final double subTotal;
  final double deliveryFee;

  const BillSummary({
    super.key,
    required this.subTotal,
    required this.deliveryFee,
  });

  @override
  Widget build(BuildContext context) {
    final total = subTotal + deliveryFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Total Bill (LKR)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D3A),
          ),
        ),
        const SizedBox(height: 12),
        _buildRow('Sub Total', subTotal),
        const SizedBox(height: 8),
        _buildRow('Delivery Fee', deliveryFee, isPlus: true),
        const SizedBox(height: 12),
        const Divider(color: Color(0xFFEAEFF3), thickness: 1),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D2D3A),
              ),
            ),
            Text(
              '${total.toStringAsFixed(2)}', // Assuming format #,###.00 handled by logic later or simple formatting
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D2D3A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(String label, double amount, {bool isPlus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          '${isPlus ? "+" : ""}${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D2D3A),
          ),
        ),
      ],
    );
  }
}
