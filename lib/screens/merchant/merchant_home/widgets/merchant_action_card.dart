import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MerchantActionCard extends StatelessWidget {
  final VoidCallback? onTap;

  const MerchantActionCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD), // Light blue tint
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                'assets/home-icons/Promo logo.svg',
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Add Promotions Here',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
