import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlternativeContact extends StatelessWidget {
  const AlternativeContact({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEFF3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/phone_plus.svg',
            width: 24,
            height: 24,
             colorFilter: const ColorFilter.mode(
                Color(0xFF2D2D3A),
                BlendMode.srcIn,
              ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alternative Contact',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D3A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'In Case the driver is Unable to reach you',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 1.5),
              borderRadius: BorderRadius.circular(6),
            ),
             child: const Center(
               child: Icon(Icons.add, size: 16, color: Colors.black54),
             ),
          ),
        ],
      ),
    );
  }
}
