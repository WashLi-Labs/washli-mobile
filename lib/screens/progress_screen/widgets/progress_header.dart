import 'package:flutter/material.dart';
import '../../../../widgets/buttons/back_button.dart';
import '../../home/home_screen.dart';

class ProgressHeader extends StatelessWidget {
  final String orderId;

  const ProgressHeader({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CustomBackButton(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
            ),
          ),
          Text(
            orderId,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D2D3A),
            ),
          ),
        ],
      ),
    );
  }
}

