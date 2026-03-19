import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MerchantNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const MerchantNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85, // Fixed height for a premium feel
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(child: _buildNavItem("assets/home-icons/Home Angle.svg", "Home", 0)),
            Expanded(child: _buildNavItem("assets/home-icons/Bag 4.svg", "Orders", 1)),
            Expanded(child: _buildNavItem("assets/home-icons/Global.svg", "Activities", 2)),
            Expanded(child: _buildNavItem("assets/home-icons/Graph Up.svg", "Dashboard", 3)),
            Expanded(child: _buildNavItem("assets/home-icons/Account.svg", "Account", 4)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? const Color(0xFF007BFF) : Colors.grey;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            // Active indicator bar
            Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
