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
      margin: const EdgeInsets.all(0),
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem("assets/home-icons/Home Angle.svg", "Home", 0),
          _buildNavItem("assets/home-icons/Bag 4.svg", "Orders", 1),
          _buildNavItem("assets/home-icons/Global.svg", "Activities", 2),
          _buildNavItem("assets/home-icons/Graph Up.svg", "Dashboard", 3),
          _buildNavItem("assets/home-icons/Account.svg", "Account", 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? const Color(0xFF007BFF) : Colors.grey;

    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
