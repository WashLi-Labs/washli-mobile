import 'package:flutter/material.dart';

class MobileNumberInput extends StatelessWidget {
  final TextEditingController controller;

  const MobileNumberInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      maxLength: 9,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        // Custom prefix consisting of +94 and a vertical divider
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '+94',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 1,
                height: 24,
                color: Colors.grey.shade300,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        // Match the border style of other inputs
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2688EA), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: '7X XXX XXXX',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
        counterText: "",
        isDense: true,
      ),
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Mobile number is required';
        }
        if (!RegExp(r'^\d{9}$').hasMatch(value)) {
          return 'Enter a valid 9-digit number';
        }
        return null;
      },
    );
  }
}
