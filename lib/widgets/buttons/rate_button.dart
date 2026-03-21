import 'package:flutter/material.dart';

class RateButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const RateButton({
    super.key,
    required this.onTap,
    this.text = 'Rate',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0062FF), // Primary Blue to match "other buttons"
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28), // Rounded pill shape as seen in screenshot
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
