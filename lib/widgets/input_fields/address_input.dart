import 'package:flutter/material.dart';

class AddressInput extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;

  const AddressInput({super.key, required this.controller, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Address',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }
}
