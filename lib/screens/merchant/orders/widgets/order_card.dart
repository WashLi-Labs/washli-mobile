import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String timeAgo;
  final String orderDescription;
  final String status;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.timeAgo,
    required this.orderDescription,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                    orderId,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D3A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    orderDescription,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            _buildStatusTag(status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    Color bgColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case 'pending':
        bgColor = const Color(0xFFFFA06A);
        break;
      case 'completed':
        bgColor = const Color(0xFF70E89B);
        break;
      case 'in progress':
        bgColor = const Color(0xFF5AB2FF);
        break;
      case 'canceled':
        bgColor = const Color(0xFFFF6B6B);
        break;
      default:
        bgColor = Colors.grey;
    }

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10), // Slab-like rounded corners per screenshot
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          height: 1.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
