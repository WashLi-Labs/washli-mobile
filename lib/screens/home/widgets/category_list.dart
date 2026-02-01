import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'name': 'Shirts', 'icon': Icons.checkroom_rounded},
    {'name': 'Pants', 'icon': Icons.window_rounded}, // Using a window icon as a placeholder for pants if proper icon not found
    {'name': 'Formal', 'icon': Icons.dry_cleaning_rounded},
    {'name': 'More', 'icon': Icons.grid_view_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories.map((category) => _buildCategoryItem(category)).toList(),
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD).withOpacity(0.8),
            shape: BoxShape.circle,
             boxShadow: [
              BoxShadow(
                color: const Color(0xFFE3F2FD).withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            category['icon'],
            color: const Color(0xFF007BFF),
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category['name'],
          style: const TextStyle(
            color: Color(0xFF2D2D3A),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
