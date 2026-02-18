import 'package:flutter/material.dart';
import '../../payment/payment_screen.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Cash Icon (Green bill)
             Container(
              width: 32,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                // Replace with actual asset later, using simple design for now
                color: Colors.green.shade100, 
              ),
               child: const Icon(Icons.money, color: Colors.green, size: 20),
            ),
             const SizedBox(width: 12),
            const Text(
              'Cash',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D2D3A),
              ),
            ),
          ],
        ),
        
        TextButton(
          onPressed: () {
             Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PaymentScreen()),
            );
          },
          child: const Text(
            'Change',
            style: TextStyle(
              color: Color(0xFF0062FF),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
