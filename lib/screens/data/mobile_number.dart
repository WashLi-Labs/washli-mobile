import 'package:flutter/material.dart';

class MobileNumberInput extends StatelessWidget {
  final TextEditingController controller;

  const MobileNumberInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter your phone number',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }
}
