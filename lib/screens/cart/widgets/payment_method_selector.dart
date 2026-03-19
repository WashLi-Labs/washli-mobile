import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/payment_provider.dart';
import '../../payment/payment_screen.dart';

class PaymentMethodSelector extends ConsumerWidget {
  const PaymentMethodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payment = ref.watch(paymentProvider);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Payment Icon
             Container(
              width: 32,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: payment.selectedType == PaymentType.points ? Colors.orange.shade100 : Colors.blue.shade100, 
              ),
               child: payment.isSvg 
                 ? const SizedBox() // Future SVG support
                 : Image.asset(payment.iconPath, width: 20, height: 20, fit: BoxFit.contain),
            ),
             const SizedBox(width: 12),
            Text(
              payment.displayName,
              style: const TextStyle(
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
