import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpPinput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;

  const OtpPinput({
    super.key, 
    required this.controller,
    this.onCompleted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // ... theme definitions ...
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFF0062FF)), // Match button color
      borderRadius: BorderRadius.circular(12),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Pinput(
      controller: controller,
      length: 4,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      showCursor: true,
      onCompleted: onCompleted,
      onChanged: onChanged,
    );
  }
}
