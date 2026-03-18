import 'package:flutter/material.dart';

class OrderCancelButton extends StatelessWidget {
  final VoidCallback onTap;

  const OrderCancelButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF2D2D3A)),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Reject',
              style: TextStyle(
                color: Color(0xFF2D2D3A),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
