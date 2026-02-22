import 'package:flutter/material.dart';

class LastNameInput extends StatelessWidget {
  final TextEditingController controller;

  const LastNameInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        // Match the previous container border
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
        hintText: 'Last Name',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
        isDense: true,
      ),
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Last name is required';
        }
        return null; // Error will appear below the border
      },
    );
  }
}
