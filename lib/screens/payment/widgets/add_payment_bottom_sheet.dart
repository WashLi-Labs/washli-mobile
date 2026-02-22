
import 'package:flutter/material.dart';


class AddPaymentBottomSheet extends StatelessWidget {
  const AddPaymentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          
          // Add Card Option
          _buildOption(
            context,
            icon: Image.asset("assets/icons/card_payment_icon.png", width: 32, height: 32), // Using card_payment_icon.png
            title: "Add Card",
            onTap: () {
              Navigator.pop(context, "add_card");
            },
          ),
          
          const Divider(height: 1, indent: 24, endIndent: 24),
          
          // Touch Option
          _buildOption(
            context,
            icon: Image.asset("assets/icons/touch_payment.png", width: 32, height: 32),
            title: "Touch",
            onTap: () {
               Navigator.pop(context, "touch");
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, {required Widget icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(
          
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
