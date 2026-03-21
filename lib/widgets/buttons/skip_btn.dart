import 'package:flutter/material.dart';

class SkipBtn extends StatelessWidget {
  final VoidCallback onTap;

  const SkipBtn({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: const Text(
        'Skip',
        style: TextStyle(
          color: Color(0xFF8E99A3), // Greyish blue color from screenshot
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
