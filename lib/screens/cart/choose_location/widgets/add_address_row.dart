import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddAddressRow extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const AddAddressRow({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Color(0xFF0062FF), // Primary blue
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2D2D3A),
                ),
              ),
            ),
             const Icon(
              Icons.add_box_outlined, // Fallback similar to square with plus or just use add_circle_outline
              size: 20, 
              color: Color(0xFF0062FF),
            ), 
          ],
        ),
      ),
    );
  }
}
