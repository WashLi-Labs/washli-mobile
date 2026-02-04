import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isEnabled;

  const SubmitButton({
    super.key,
    required this.onTap,
    this.text = 'Submit',
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isEnabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0057FF), // Blue color when enabled
          disabledBackgroundColor: const Color(0xFFD9D9D9), // Grey color when disabled
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isEnabled ? Colors.white : Colors.black.withOpacity(0.5),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
