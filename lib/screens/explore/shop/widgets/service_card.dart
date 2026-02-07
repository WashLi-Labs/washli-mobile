import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final String imagePath;
  final VoidCallback? onAdd;

  const ServiceCard({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.imagePath,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D3A),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onAdd ?? () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF), // Blue color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: const Size(60, 30),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add_circle_outline, size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            "Add",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  "Fee : $price",
                   style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                     color: Color(0xFF2D2D3A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
