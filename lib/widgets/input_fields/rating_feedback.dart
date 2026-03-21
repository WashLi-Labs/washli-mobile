import 'package:flutter/material.dart';

class RatingFeedbackInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const RatingFeedbackInput({
    super.key,
    required this.controller,
    this.hintText = 'Additional feedback',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
