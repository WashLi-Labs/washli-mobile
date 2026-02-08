import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final int count;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final bool isCounterMode;

  const AddButton({
    super.key,
    this.onTap,
    this.text = "Add",
    this.count = 0,
    this.onIncrement,
    this.onDecrement,
    this.isCounterMode = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCounterMode) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0066FF),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onDecrement,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.remove, size: 14, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: onIncrement,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.add, size: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0066FF), // Blue color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 0,
        minimumSize: const Size(100, 45), 
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
             decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(2),
            child: const Icon(Icons.add, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold), // Adjusted font size slightly
          ),
        ],
      ),
    );
  }
}
