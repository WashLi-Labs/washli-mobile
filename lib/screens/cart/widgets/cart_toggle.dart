import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartToggle extends StatelessWidget {
  final bool isPickup;
  final ValueChanged<bool> onToggle;

  const CartToggle({
    super.key,
    required this.isPickup,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton(
          context,
          label: 'Pickup',
          iconPath: 'assets/icons/pickup.svg',
          isSelected: isPickup,
          onTap: () => onToggle(true),
        ),
        const SizedBox(width: 12),
        _buildButton(
          context,
          label: 'Walk-in',
          iconPath: 'assets/icons/walk_in.svg',
          isSelected: !isPickup,
          onTap: () => onToggle(false),
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), // Increased padding
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0062FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12), // Slightly more rounded
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[ // Only show icon if selected? Or always? Design shows icons on both.
                SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : Colors.black87,
                    BlendMode.srcIn,
                  ),
                  height: 20,
                ),
                const SizedBox(width: 8),
            ] else ...[
                 SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : Colors.black87,
                    BlendMode.srcIn,
                  ),
                  height: 20,
                ),
                const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 15, // Slightly larger
              ),
            ),
          ],
        ),
      ),
    );
  }
}
