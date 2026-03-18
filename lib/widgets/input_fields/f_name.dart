import 'package:flutter/material.dart';

class FirstNameInput extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;
  final String? hintText;
  final String? Function(String?)? validator;

  const FirstNameInput({
    super.key, 
    required this.controller, 
    this.readOnly = false,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
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
        hintText: hintText ?? 'First Name',
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
      validator: validator ?? (value) {
        if (value == null || value.trim().isEmpty) {
          return hintText != null ? '$hintText is required' : 'First name is required';
        }
        return null; // Error will appear below the border
      },
    );
  }
}
