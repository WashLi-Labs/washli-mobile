import 'package:flutter/material.dart';

class RecentPlaceTile extends StatelessWidget {
  final String name;
  final String address;
  final String distance;
  final VoidCallback onTap;

  const RecentPlaceTile({
    super.key,
    required this.name,
    required this.address,
    required this.distance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and Distance column
            SizedBox(
              width: 50,
              child: Column(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: Color(0xFF6B7280),
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    distance,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
